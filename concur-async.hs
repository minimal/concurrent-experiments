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
