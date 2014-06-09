// swiftz from https://github.com/maxpow4h/swiftz/
import swiftz

let chan: Chan<Int> = Chan()
let proc: Future<String> = Future(exec: gcdExecutionContext, {
    let x = chan.read()
    let y = chan.read()
    let z = chan.read()
    return "\(x) + \(y) + \(z) = \(x + y + z)"
})
Future(exec: gcdExecutionContext, {chan.write(2 * 10)})
Future(exec: gcdExecutionContext, {chan.write(2 * 20)})
Future(exec: gcdExecutionContext, {chan.write(30 + 40)})
println(proc.result())