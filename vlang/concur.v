import sync

// these need to be top-level functions rather than
// anonymous functions eg
//   a := fn(ch chan int) { ch <- 1 }
// due to a bug with anonymous functions and usage of
// the new channels that exists in the current version
// of v (0.1.30)
fn task1(ch chan int) {
  ch <- (2 * 10)
}
fn task2(ch chan int) {
  ch <- (2 * 20)
}
fn task3(ch chan int) {
  ch <- (30 + 40)
}
fn combine(ch chan int, mut wg sync.WaitGroup) {
  a := <- ch
  b := <- ch
  c := <- ch
  println("$a + $b + $c = ${a + b + c}")
  wg.done()
}

fn main() {
   mut wg := sync.new_waitgroup()
   wg.add(1)
   vals := chan int{}
   go combine(vals, mut wg)
   go task1(vals)
   go task2(vals)
   go task3(vals)
   wg.wait()
}
