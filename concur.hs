{-# LANGUAGE BangPatterns #-}
import Control.Concurrent
import Control.Concurrent.Chan
import Text.Printf

main = do
        numbers <- newChan :: IO (Chan Int)
        result <- newChan :: IO (Chan String)
        forkIO $ do
            x <- readChan numbers
            y <- readChan numbers
            z <- readChan numbers
            writeChan result (printf "%d + %d + %d = %d" x y z (x + y + z))
        forkIO $ do { !r <- return (2 * 10); writeChan numbers r }
        forkIO $ do { !r <- return (2 * 20); writeChan numbers r }
        forkIO $ do { !r <- return (30 + 40); writeChan numbers r }
        resultStr <- readChan result
        putStrLn resultStr
