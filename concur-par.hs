import Control.Monad.Par
import Text.Printf

spawnProcs :: Par String
spawnProcs = do
    [a, b, c] <- sequence [new, new, new]
    d <- spawn $ do
        [x, y, z] <- sequence [get a, get b, get c]
        return $ printf "%d + %d + %d = %d" x y z (x + y + z)
    fork $ put a ((2 * 10) :: Int)
    fork $ put b ((2 * 20) :: Int)
    fork $ put c ((30 + 40) :: Int)
    get d

main = putStrLn $ runPar spawnProcs
