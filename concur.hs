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
            writeChan result $! printf "%d + %d + %d = %d" x y z (x + y + z)
        forkIO $ do writeChan numbers $! (2 * 10)
        forkIO $ do writeChan numbers $! (2 * 20)
        forkIO $ do writeChan numbers $! (30 + 40)
        readChan result >>= putStrLn
