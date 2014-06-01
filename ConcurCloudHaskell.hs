module ConcurCloudHaskell where
import Control.Distributed.Process
import Control.Distributed.Process.Node
import Control.Monad (replicateM)
import Network.Transport.TCP
import Text.Printf
    
numProc1 :: SendPort Int -> Process ()
numProc1 chan = do
  sendChan chan (2 * 10)

numProc2 :: SendPort Int -> Process ()
numProc2 chan = do
  sendChan chan (2 * 20)
           
numProc3 :: SendPort Int -> Process ()
numProc3 chan = do
  sendChan chan (30 + 40)
           
proc :: ProcessId -> ReceivePort Int -> Process ()
proc resultId numbers = do
  all@[x, y, z] <- replicateM 3 (receiveChan numbers)
  let result = printf "%d + %d + %d = %d" x y z (sum all) :: String
  send resultId result

master :: Process ()
master = do
  ourId <- getSelfPid
  numbers <- spawnChannelLocal $ proc ourId
  spawnLocal $ numProc1 numbers
  spawnLocal $ numProc2 numbers
  spawnLocal $ numProc3 numbers
  r <- expect :: Process String
  liftIO $ putStrLn r

main :: IO ()
main = do
  Right transport <- createTransport "127.0.0.1" "8080" defaultTCPParameters
  node <- newLocalNode transport initRemoteTable
  runProcess node master
