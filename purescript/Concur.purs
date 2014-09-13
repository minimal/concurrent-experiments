module Concur where
import Debug.Trace
import Control.Monad.Eff
import Control.Monad.Eff.Ref
import Control.Monad.Cont.Trans
import Control.Monad.Trans
import Data.Maybe

type WithRef eff = Eff (ref :: Ref | eff)
type Chan a = RefVal (Maybe a)

--foreign import data Timer :: !
foreign import data Timeout :: *

foreign import setTimeoutImpl
  "function setTimeoutImpl(t) {\
  \  return function(fn) {\
  \    return function() {\
  \      return setTimeout(fn, t);\
  \    }\
  \  }\
  \}" :: forall eff a. Number -> Eff eff a -> Eff eff Timeout

async :: forall eff a. a -> ContT Unit (Eff eff) a
async a = ContT $ \x -> void $ setTimeoutImpl 0 $ x a

delay :: forall eff. Number -> ContT Unit (Eff eff) Unit
delay n = ContT $ \x -> void $ setTimeoutImpl n $ x unit

wait :: forall a eff b. Chan a
        -> (a -> ContT Unit (WithRef eff) b)
        -> ContT Unit (WithRef eff) b
wait r c = do
     v <- lift $ readRef r
     case v of
         Nothing -> async c >>= wait r
         Just x  -> do
                     lift $ writeRef r Nothing
                     c x

write :: forall a eff. Chan a -> a -> WithRef eff Unit
write r v = do
    x <- readRef r
    case x of
        Nothing -> writeRef r $ Just v
        Just x -> void $ setTimeoutImpl 0 $ write r v

read :: forall a eff. Chan a -> ContT Unit (WithRef eff) a
read r = callCC $ wait r

proc :: forall eff. Chan Number -> Chan String
        -> ContT Unit (WithRef eff) Unit
proc num res = do
    x <- read num
    y <- read num
    z <- read num
    lift $ write res $ show x ++ " + " ++ show y ++ " + " ++ show z ++ " = " ++ show (x + y + z)

main = do
  n <- newRef Nothing
  r <- newRef Nothing
  runContT (read r) trace
  runContT (proc n r) return
  runContT (async n) $ \n -> write n (2 * 10)
  runContT (async n) $ \n -> write n (2 * 20)
  runContT (async n) $ \n -> write n (30 + 40)
