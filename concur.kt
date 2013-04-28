import java.util.concurrent.LinkedBlockingQueue
import kotlin.concurrent.thread

fun main(args : Array<String>) {
  val numq = LinkedBlockingQueue<Int>()
  val strq = LinkedBlockingQueue<String>()
  thread() {
    val a = numq.take()
    val b = numq.take()
    val c = numq.take()
    val d = a?.plus(b!!)?.plus(c!!)
    strq.put("$a + $b + $c = $d")
  }
  thread() { numq.put(2 * 10) }
  thread() { numq.put(2 * 20) }
  thread() { numq.put(30 + 40) }
  println(strq.take())
}
