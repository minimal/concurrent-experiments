module ConcurMachines where
import Control.Concurrent.Async
import Control.Monad (replicateM, forM_)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Machine
import Text.Printf
    
asyncYield :: MonadIO m => a -> PlanT k a m ()
asyncYield v = liftIO a >>= yield
    where a = async (return v) >>= wait
               
numbers :: MonadIO m => WyeT m Int Int Int
numbers = let left = capX x (addY y a)
          in wye left z a
              where x = construct $ asyncYield (2 * 10)
                    y = construct $ asyncYield (2 * 20)
                    z = construct $ asyncYield (30 + 40)
                    a = repeatedly $ do
                          x <- awaits Z
                          case x of
                            Left a -> yield a
                            Right a -> yield a
                                       
proc :: Monad m => MachineT m ((->) Int) String
proc = construct $ do
  all@[x, y, z] <- replicateM 3 $ awaits id
  yield $ printf "%d + %d + %d = %d" x y z (sum all)

main :: IO ()
main = do
  y <- runT $ numbers ~> (process id proc)
  forM_ y putStrLn
