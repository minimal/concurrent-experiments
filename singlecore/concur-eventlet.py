# eventlet runs the spawned processes in coroutines (greenlets) in a single thread
# so we don't see speed up here. eventlet spawned coroutines behave pretty-much
# *exactly* how you'd expect similar goroutines to run in go WHEN GOMAXPROCS is 1.
# ie: only one runs at any one time and only yields to others when making a blocking
# call or explicitly yielding. greenlets cannot be multiplexed over multiple cores.
import eventlet

numbers = eventlet.queue.Queue()


@eventlet.spawn
def proc():
    x = numbers.get()
    y = numbers.get()
    z = numbers.get()
    return "%d + %d + %d = %d" % (x, y, z, x + y + z)

eventlet.spawn(lambda: numbers.put(2 * 10))
eventlet.spawn(lambda: numbers.put(2 * 20))
eventlet.spawn(lambda: numbers.put(30 + 40))

print proc.wait()
