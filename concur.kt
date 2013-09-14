import java.util.concurrent.LinkedBlockingQueue
import kotlin.concurrent.thread
import java.util.Random 

fun main(args : Array<String>) {
  val numq = LinkedBlockingQueue<Int>()
  val strq = LinkedBlockingQueue<String>()
  thread() {
    val a = numq.take()
    val b = numq.take()
    val c = numq.take()
    if (a != null && b != null && c != null) {
      val d = a + b + c
      strq.put("$a + $b + $c = $d")
    }
  }
  val rand = Random()
  thread() { Thread.sleep(rand.nextInt(10).toLong()); numq.put(2 * 10) }
  thread() { Thread.sleep(rand.nextInt(10).toLong()); numq.put(2 * 20) }
  thread() { Thread.sleep(rand.nextInt(10).toLong()); numq.put(30 + 40) }
  println(strq.take())
}
