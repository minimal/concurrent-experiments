module ConcurConduit where
import Control.Concurrent (forkIO)
import Control.Monad (replicateM)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.STM (atomically)
import Data.Conduit
import Data.Conduit.TMChan
import Data.Maybe (fromJust)
import Text.Printf (printf)

proc :: Monad m => Conduit Int m String
proc = do
  all@[x, y, z] <- replicateM 3 $ await >>= return . fromJust
  yield $ printf "%d + %d + %d = %d" x y z (sum all)

main :: IO ()
main = do
  numbers <- atomically $ newTBMChan 1
  result <- atomically $ newTBMChan 1
  forkIO $ sourceTBMChan numbers $$ proc =$ sinkTBMChan result True
  forkIO $ yield (2 * 10) $$ sinkTBMChan numbers False
  forkIO $ yield (2 * 20) $$ sinkTBMChan numbers False
  forkIO $ yield (30 + 40) $$ sinkTBMChan numbers False
  sourceTBMChan result $$ await >>= liftIO . putStrLn . fromJust
