module ConcurMVar where
import Control.Concurrent
import Control.Concurrent.MVar
import Control.Monad (replicateM)
import qualified Data.IVar as IVar
import Text.Printf

-- uses lower level primitives than the Concur.hs example.
-- illustrates how haskell's mutable locations can be used
-- as single-item sized threadsafe queues.
-- they can also be used like futures with `readMVar` instead of `takeMVar`.
-- `result` could have been used like this (with implicit blocking):
--     result <- newEmptyMVar
--     readMVar result >>= putStrLn
-- ...but instead we use an IVar to demo usage of those also.
main :: IO ()
main = do
  numbers <- newEmptyMVar :: IO (MVar Int)
  result <- IVar.new
  forkIO $ do
         all@[x, y, z] <- replicateM 3 $ takeMVar numbers
         IVar.write result $! printf "%d + %d + %d = %d" x y z (sum all)
  forkIO $ putMVar numbers $! (2 * 10)
  forkIO $ putMVar numbers $! (2 * 20)
  forkIO $ putMVar numbers $! (30 + 40)
  IVar.blocking (IVar.read result) >>= putStrLn
