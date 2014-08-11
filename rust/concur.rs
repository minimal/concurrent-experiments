use std::task::spawn;

fn main() {
    let (tx, rx) = channel::<int>();
    let (strtx, strrx) =  channel();

    spawn(proc() {
        let x = rx.recv();
        let y = rx.recv();
        let z = rx.recv();
        strtx.send(format!("{} + {} + {} = {}" , x , y , z , x + y + z));
    });

    let my_in = tx.clone();
    spawn(proc() { my_in.send(2 * 10); });
    let my_in = tx.clone();
    spawn(proc() { my_in.send(2 * 20); });
    let my_in = tx.clone();
    spawn(proc() { my_in.send(30 + 40); });
    println!("{}", strrx.recv());
}
