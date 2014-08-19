let proc mb =
  lwt x = Lwt_mvar.take mb and
      y = Lwt_mvar.take mb and
      z = Lwt_mvar.take mb in
  let resp = Printf.sprintf "%d + %d + %d = %d" x y z (x + y + z) in
  Lwt.return resp

let mb = Lwt_mvar.create_empty () in
lwt r = proc mb and
    _ = Lwt_mvar.put mb (2 * 10) and
    _ = Lwt_mvar.put mb (2 * 20) and
    _ = Lwt_mvar.put mb (30 + 40) in
Lwt.return (print_string r)
