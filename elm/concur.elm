import Graphics.Element exposing (show)
import Task exposing (Task, andThen, spawn, sleep, succeed)
import Signal

mkString : List Int -> String
mkString x = case x of
         (a :: b :: c :: []) ->
           toString a ++ " + "  ++ toString b ++ " + "  ++ toString c ++ " = " ++ toString (a+b+c)
         _ -> ""

results : Signal.Mailbox Int
results = Signal.mailbox 0

report : number -> Task x ()
report num =
  Signal.send results.address num

port tasks : Task x Task.ThreadID
port tasks =
  spawn (sleep 0 `andThen` \_ -> report (2 * 10))
  `andThen` \_ -> spawn (sleep 0 `andThen` \_ -> report (2 * 20))
  `andThen` \_ -> spawn (sleep 0 `andThen` \_ -> report (30 + 40))

main =
  Signal.foldp (::) [] results.signal
    |> Signal.map mkString
    |> Signal.map show
