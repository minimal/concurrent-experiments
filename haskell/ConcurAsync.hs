module ConcurAsync where
import Control.Concurrent.Async
import Text.Printf

main = do
  numbers <- sequence $ [async (return $ 2 * 10 :: IO Int),
                         async (return $ 2 * 20 :: IO Int),
                         async (return $ 30 + 40 :: IO Int)]
  result <- async $ do
              all@[x, y, z] <- mapConcurrently wait numbers
              return $ printf "%d + %d + %d = %d" x y z (sum all)
  wait result >>= putStrLn

-- Alternatively, for this example, we could use the applicative
-- instance of the Concurrently newtype wrapper:

-- > import Control.Applicative
-- > import Control.Concurrent.Async
-- > import Text.Printf
-- >
-- > format :: Int -> Int -> Int -> String
-- > format x y z = printf "%d + %d + %d = %d" x y z (x + y + z)
-- >
-- > main :: IO ()
-- > main = do
-- >   resp <- runConcurrently $ pure format
-- >        <*> Concurrently (return $ 2 * 10)
-- >        <*> Concurrently (return $ 2 * 20)
-- >        <*> Concurrently (return $ 30 + 40)
-- >   putStrLn resp

-- Intentionally use `pure` on the applied `format` function
-- rather than fmap `format <$> ...` so that it gets its own
-- thread of execution.
