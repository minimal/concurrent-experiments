module ConcurParallel where
import Control.Monad.Eff
import Control.Monad.Cont.Trans
import Control.Parallel
import Debug.Trace

foreign import data Timeout :: *

foreign import setTimeoutImpl
  "function setTimeoutImpl(t) {\
  \  var env = typeof global !== 'undefined' ? global : window;\
  \  return function(fn) {\
  \    return function() {\
  \      return env.setTimeout(fn, t);\
  \    }\
  \  }\
  \}" :: forall eff a. Number -> Eff eff a -> Eff eff Timeout

async :: forall eff a. (Unit -> Eff eff a) -> ContT Unit (Eff eff) a
async f = ContT $ \x -> let f' = do val <- f unit >>= x
                                    return val -- purescript isn't lazy
                        in void $ setTimeoutImpl 0 f'

format :: Number -> Number -> Number -> String
format a b c = show a ++ " + " ++ show b ++ " + " ++ show c
                      ++ " = " ++ show (a + b + c)

main = run concur trace
     where a = Parallel <<< async $ \_ -> return (2 * 10)
           b = Parallel <<< async $ \_ -> return (2 * 20)
           c = Parallel <<< async $ \_ -> return (30 + 40)
           concur = format <$> a <*> b <*> c
           run = runContT <<< runParallel
