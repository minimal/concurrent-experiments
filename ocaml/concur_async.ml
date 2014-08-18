open Async.Std
open Core.Never_returns

exception Barf

let proc nums =
  Pipe.read nums
    >>= function `Eof -> raise Barf | `Ok x -> Pipe.read nums
    >>= function `Eof -> raise Barf | `Ok y -> Pipe.read nums
    >>= function `Eof -> raise Barf | `Ok z ->
    let resp = Printf.sprintf "%d + %d + %d = %d" x y z (x + y + z) in
    return resp

let () =
  let (numr, numw) = Pipe.create () in
  let _ = In_thread.run (fun () -> proc numr)
    >>= fun a -> a >>| print_string
    >>| fun a -> Shutdown.shutdown 0 in
  ignore (In_thread.run (fun () -> Pipe.write numw (2 * 10)));
  ignore (In_thread.run (fun () -> Pipe.write numw (2 * 20)));
  ignore (In_thread.run (fun () -> Pipe.write numw (30 + 40)));
  never_returns (Scheduler.go ())
