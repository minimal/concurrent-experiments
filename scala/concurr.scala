import scala.concurrent.ops._
import scala.actors.Actor
import scala.actors.Actor._

class Adder extends Actor {
  def act() {
    val a = receive { case x: Integer => x }
    val b = receive { case x: Integer => x }
    val c = receive { case x: Integer => x }
    Console.println("%d + %d + %d = %d".format(a, b, c, a+b+c))
  }
}

object pingpong extends Application {

  val adder = new Adder
  adder.start
    
  spawn { adder ! 2 * 10 }
  spawn { adder ! 2 * 20 }
  spawn { adder ! 30 + 40 }

}
