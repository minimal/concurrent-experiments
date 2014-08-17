let proc res ch =
  let x = Event.sync (Event.receive ch) in
  let y = Event.sync (Event.receive ch) in
  let z = Event.sync (Event.receive ch) in
  let s = Printf.sprintf ("%d + %d + %d = %d") x y z (x + y + z) in
  Event.sync (Event.send res s)

let _ =
  let nch   = Event.new_channel () in
  let rch = Event.new_channel () in
  let _ = Thread.create (proc rch) nch in
  let _ = Thread.create (fun ch -> Event.sync (Event.send ch (2 * 10))) nch in
  let _ = Thread.create (fun ch -> Event.sync (Event.send ch (2 * 20))) nch in
  let _ = Thread.create (fun ch -> Event.sync (Event.send ch (30 + 40))) nch in
  let r = Event.sync (Event.receive rch) in
  print_string r
