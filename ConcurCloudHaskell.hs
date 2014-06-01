module ConcurCloudHaskell where
import Control.Distributed.Process
import Control.Distributed.Process.Node
import Control.Monad (replicateM)
import Network.Transport.TCP
import Text.Printf
    
proc :: ProcessId -> ReceivePort Int -> Process ()
proc resultId numbers = do
  all@[x, y, z] <- replicateM 3 (receiveChan numbers)
  let result = printf "%d + %d + %d = %d" x y z (sum all) :: String
  send resultId result

master :: Process ()
master = do
  ourId <- getSelfPid
  numbers <- spawnChannelLocal $ proc ourId
  spawnLocal $ sendChan numbers (2 * 10)
  spawnLocal $ sendChan numbers (2 * 20)
  spawnLocal $ sendChan numbers (30 + 40)
  r <- expect
  liftIO $ putStrLn r

main :: IO ()
main = do
  Right transport <- createTransport "127.0.0.1" "8080" defaultTCPParameters
  node <- newLocalNode transport initRemoteTable
  runProcess node master
