module ConcurPipes where
import Control.Concurrent (forkIO)
import Control.Monad (replicateM, mapM_)
import Pipes
import Pipes.Concurrent
import Text.Printf

proc :: Pipe Int String IO ()
proc = do
  all@[x, y, z] <- replicateM 3 await
  yield $ printf "%d + %d + %d = %d" x y z (sum all)

main :: IO ()
main = do
  let x = yield (2 * 10)
      y = yield (2 * 20)
      z = yield (30 + 40)
      run o f = forkIO $ do
                  runEffect $ f >-> toOutput o
                  performGC
  (output, input) <- spawn Unbounded
  (output', input') <- spawn Single
  mapM_ (run output) [x, y, z]
  run output' $ fromInput input >-> proc
  runEffect $ for (fromInput input') (lift . putStrLn)
