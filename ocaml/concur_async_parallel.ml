open Async.Std
open Async_parallel.Std
open Parallel
open Core.Never_returns
open Core.Std

exception Barf

let proc nums =
  Pipe.read nums
    >>= function `Eof -> raise Barf | `Ok (_, x) -> Pipe.read nums
    >>= function `Eof -> raise Barf | `Ok (_, y) -> Pipe.read nums
    >>= function `Eof -> raise Barf | `Ok (_, z) ->
    let resp = Printf.sprintf "%d + %d + %d = %d" x y z (x + y + z) in
    return resp

let () =
  let _ = init () in
  let _ = spawn (fun h -> proc (Hub.listen_simple h))
    >>= (fun (chan, d) -> ignore(run (fun () -> Channel.write chan (2 * 10);
                                                Channel.flushed chan));
                          ignore(run (fun () -> Channel.write chan (2 * 20);
                                                Channel.flushed chan));
                          ignore(run (fun () -> Channel.write chan (30 + 40);
                                                Channel.flushed chan));
                          d)
    >>= (function Error _ -> raise Barf
                | Ok resp -> print_string resp; shutdown ())
    >>| (fun _ -> Shutdown.shutdown 0) in
  never_returns (Scheduler.go ())
