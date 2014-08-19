open Lwt

let () =
  let n = Lwt_mvar.create_empty () in
  let p = Lwt_mvar.take n >>= fun x -> Lwt_mvar.take n
                          >>= fun y -> Lwt_mvar.take n
                          >>= fun z ->
          return (Printf.sprintf "%d + %d + %d = %d" x y z (x + y + z)) in
  let _ = Lwt.join [Lwt_mvar.put n (2 * 10);
                    Lwt_mvar.put n (2 * 20);
                    Lwt_mvar.put n (30 + 40)] in
  Lwt_main.run(p >|= print_string);
