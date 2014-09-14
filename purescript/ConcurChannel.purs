module ConcurChannel where
import Debug.Trace
import Control.Monad.Eff
import Control.Monad.Eff.Ref
import Control.Monad.Cont.Trans
import Control.Monad.Trans
import Data.Maybe

foreign import data Async :: !
foreign import data Channel :: * -> *

foreign import newChan
  "function newChan() {\
  \    return { data: [],\
  \             waiters: [] };\
  \}" :: forall a r. Eff (async :: Async | r) (Channel a)

foreign import readChan
  "function readChan(chan) {\
  \  return function(cont) {\
  \    return function() {\
  \      if (chan.data.length > 0) {\
  \         cont(chan.data.shift())();\
  \        }\
  \      else {\
  \        chan.waiters.push(cont); }\
  \      return {};\
  \    }\
  \  }\
  \}" :: forall a eff. Channel a -> ContT Unit (Eff eff) a

foreign import writeChan
  "function writeChan(chan) {\
  \  return function(val) {\
  \   return function() {\
  \     if(chan.waiters.length > 0) {\
  \         chan.waiters.shift()(val)();\
  \       }\
  \     else {\
  \       chan.data.push(val); }\
  \     return {};\
  \   }\
  \  }\
  \}" :: forall a r. Channel a -> a -> Eff (async :: Async | r) Unit

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

proc :: forall eff. Channel Number -> Channel String -> ContT Unit (Eff (async :: Async | eff)) Unit
proc num res = do
  x <- readChan num
  y <- readChan num
  z <- readChan num
  lift $ writeChan res $ show x ++ " + " ++ show y ++ " + " ++ show z ++ " = " ++ show (x + y + z)

main = do
  c <- newChan
  r <- newChan
  runContT (readChan r) trace
  runContT (proc c r) return
  setTimeout 0 (writeChan c (2 * 10))
  setTimeout 0 (writeChan c (2 * 20))
  setTimeout 0 (writeChan c (30 + 40))
