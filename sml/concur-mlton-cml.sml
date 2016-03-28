local
  open CML
in
val _ = RunCML.doit (fn () =>
  let
    val chan : int chan = channel ()
    val resultChan : string chan = channel ()
  in (spawn (fn () => let
                        val a = recv chan
                        val b = recv chan
                        val c = recv chan
                      in
                        send (resultChan, Int.toString a ^ " + "
                                        ^ Int.toString b ^ " + "
                                        ^ Int.toString c ^ " + "
                                        ^ Int.toString (a + b + c)
                                        ^ "\n")
                      end);
      spawn (fn () => send (chan, 2 * 10));
      spawn (fn () => send (chan, 2 * 20));
      spawn (fn () => send (chan, 30 + 40));
      print (recv resultChan))
  end, NONE)
end
