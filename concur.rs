use core::task::spawn;
use core::comm::{stream, Port, Chan, SharedChan};

fn main() {
    let (out, in): (Port<int>, Chan<int>) = stream();
    let in = SharedChan(in);
    let (strout, strin): (Port<~str>, Chan<~str>) = stream();

    do spawn {
        let x = out.recv();
        let y = out.recv();
        let z = out.recv();
        strin.send(fmt!("%d + %d + %d = %d", x, y, z, x+y+z));
    }

    let my_in = in.clone();
    do spawn { my_in.send(2 * 10); }
    let my_in = in.clone();
    do spawn { my_in.send(2 * 20); }
    let my_in = in.clone();
    do spawn { my_in.send(30 + 40); }

    io::println(strout.recv());
}
