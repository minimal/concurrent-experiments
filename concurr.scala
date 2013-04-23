import scala.actors.Actor
import scala.actors.Actor._

case object Adder
case class Value(value: Integer)

class Adder extends Actor {
  def act() {
    val a = receive { case Value(x) => x }
    val b = receive { case Value(x) => x }
    val c = receive { case Value(x) => x }
    Console.println("%d + %d + %d = %d".format(a, b, c, a+b+c))
  }
}

object pingpong extends Application {
  val adder = new Adder
  adder.start
  adder ! Value(2 * 10)
  adder ! Value(2 * 20)
  adder ! Value(30 + 40)
}
