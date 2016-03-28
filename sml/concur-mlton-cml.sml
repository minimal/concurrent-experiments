local
  open CML
in
val _ = RunCML.doit (fn () =>
  let
    val chan : int CML.chan = CML.channel ()
    val resultChan : string CML.chan = CML.channel ()
  in (CML.spawn (fn () => let
                            val a = CML.recv chan
                            val b = CML.recv chan
                            val c = CML.recv chan
                          in
                            send (resultChan, Int.toString a ^ " + "
                                            ^ Int.toString b ^ " + "
                                            ^ Int.toString c ^ " + "
                                            ^ Int.toString (a + b + c)
                                            ^ "\n")
                          end);
      CML.spawn (fn () => send (chan, 2 * 10));
      CML.spawn (fn () => send (chan, 2 * 20));
      CML.spawn (fn () => send (chan, 30 + 40));
      print (CML.recv resultChan))
  end, NONE)
end