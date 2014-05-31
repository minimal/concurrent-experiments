module ConcurMVC where
import Control.Applicative (pure, liftA2)
import Control.Monad (replicateM)
import MVC
import MVC.Prelude (producer, stdoutLines)
import Text.Printf
    
numbers :: Managed (Controller Int)
numbers = mconcat $ map (producer Single) ys
          where ys = [yield (2 * 10 :: Int),
                      yield (2 * 20 :: Int),
                      yield (30 + 40 :: Int)]

proc :: Model () Int String
proc = asPipe $ do
  all@[x, y, z] <- replicateM 3 await
  yield $ printf "%d + %d + %d = %d" x y z (sum all)

main :: IO ()
main = runMVC () proc io
       where io = liftA2 (,) (pure stdoutLines) numbers
