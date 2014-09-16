module ConcurChannel where
import Debug.Trace
import Control.Monad.Eff
import Control.Monad.Eff.Ref
import Control.Monad.Cont.Trans
import Control.Monad.Trans
import Data.List

foreign import setTimeout
  "function setTimeout(t) {\
  \  var env = typeof global !== 'undefined' ? global : window;\
  \  return function(fn) {\
  \    return function() {\
  \      env.setTimeout(fn, t);\
  \      return {};\
  \    }\
  \  }\
  \}" :: forall eff eff' a. Number -> Eff eff a -> Eff eff' Unit

foreign import data Async :: !
foreign import data Callback :: * -> *
foreign import newCallback
  "function newCallback(fn){\
  \  return {\"fn\": fn};\
  \}" :: forall a eff. (a -> Eff eff Unit) -> Callback a
foreign import runCallback
  "function runCallback(cb) {\
  \  return function(val) {\
  \    return function() {\
  \      return cb.fn(val)();\
  \    }\
  \  }\
  \}" :: forall a eff. Callback a -> a -> Eff (async :: Async | eff) Unit

data ChannelContent a = EmptyChan [Callback a] | Values a [a]
newtype Channel a = Channel (RefVal (ChannelContent a))

readChan (Channel a) = ContT $ \f -> do
  r <- readRef a
  case r of
    EmptyChan b -> writeRef a (EmptyChan (b ++ [newCallback f]))
    Values b [] -> do
                    writeRef a (EmptyChan [])
                    f b
    Values b (x:xs) -> do
                        writeRef a (Values x xs)
                        f b

writeChan (Channel a) v = do
  r <- readRef a
  case r of
    EmptyChan [] -> writeRef a (Values v [])
    EmptyChan (x:xs) -> do
                         writeRef a (EmptyChan xs)
                         runCallback x v
    Values b c -> writeRef a (Values b (c ++ [v]))

newChan :: forall a eff. Eff (ref :: Ref | eff) (Channel a)
newChan = do
  c <- newRef (EmptyChan [])
  return $ Channel c

proc :: forall eff. Channel Number -> Channel String
        -> ContT Unit (Eff (ref :: Ref, async :: Async | eff)) Unit
proc num res = do
  x <- readChan num
  y <- readChan num
  z <- readChan num
  let sum = x + y + z
      f = show x ++ " + " ++ show y ++ " + " ++ show z ++ " = " ++ show sum
  lift $ writeChan res f

main = do
  c <- newChan
  r <- newChan
  runContT (readChan r) trace
  runContT (proc c r) return
  setTimeout 0 (writeChan c (2 * 10))
  setTimeout 0 (writeChan c (2 * 20))
  setTimeout 0 (writeChan c (30 + 40))
