# eventlet runs the spawned processes in coroutines (greenlets) in a single thread
# so we don't see speed up here.
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
