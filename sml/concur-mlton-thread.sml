open MLton

local
  val scheduler : Thread.Runnable.t Queue.queue = Queue.mkQueue ()
  fun switchNext f = let val next = Queue.dequeue scheduler
                     in Thread.switch (fn t => (f t; next))
                     end
  fun switchNext' () = switchNext (fn _ => ())
  fun schedule f = Queue.enqueue (scheduler, Thread.prepare (Thread.new (switchNext' o f), ()))

  structure Channel :
    sig
      type 'a channel
      val get : 'a channel -> 'a
      val put : 'a channel * 'a -> unit
      val empty : unit -> 'a channel
    end =
    struct
      type 'a channel = 'a Queue.queue * 'a Thread.t Queue.queue
      fun get (q, waiters) = if Queue.isEmpty q then switchNext (fn t => Queue.enqueue (waiters, t))
                             else Queue.dequeue q
      fun put ((q, waiters), x) = if Queue.isEmpty waiters then Queue.enqueue (q, x)
                                  else (Queue.enqueue (scheduler, Thread.prepare (Queue.dequeue waiters, x)))
      fun empty () = (Queue.mkQueue (), Queue.mkQueue ())
    end

  val chan : int Channel.channel = Channel.empty ()
  val resultChan : string Channel.channel = Channel.empty ()
in
  val _ = schedule (fn () => let
                               val a = Channel.get chan
                               val b = Channel.get chan
                               val c = Channel.get chan
                             in
                               Channel.put (resultChan, Int.toString a ^ " + "
                                                      ^ Int.toString b ^ " + "
                                                      ^ Int.toString c ^ " = "
                                                      ^ Int.toString (a + b + c)
                                                      ^ "\n")
                             end)
  val _ = schedule (fn () => Channel.put (chan, 2 * 10))
  val _ = schedule (fn () => Channel.put (chan, 2 * 20))
  val _ = schedule (fn () => Channel.put (chan, 30 + 40))
  val _ = print (Channel.get resultChan)
end