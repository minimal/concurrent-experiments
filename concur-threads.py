# BEWARE THE GIL! (in cpython at least)
import threading
import Queue

numbers = Queue.Queue()
result = Queue.Queue(1)


def proc():
    x = numbers.get()
    y = numbers.get()
    z = numbers.get()
    result.put("%d + %d + %d = %d" % (x, y, z, x + y + z))

threading.Thread(target=proc).start()
threading.Thread(target=numbers.put, args=(2 * 10, )).start()
threading.Thread(target=numbers.put, args=(2 * 20, )).start()
threading.Thread(target=numbers.put, args=(30 + 40, )).start()
print result.get()
