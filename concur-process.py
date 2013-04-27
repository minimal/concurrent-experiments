import multiprocessing

# multiprocessing queues implement their own magic IPC
numbers = multiprocessing.Queue()
result = multiprocessing.Queue(1)

def proc():
    x = numbers.get()
    y = numbers.get()
    z = numbers.get()
    result.put("%d + %d + %d = %d" % (x, y, z, x + y + z))

multiprocessing.Process(target=proc).start()
multiprocessing.Process(target=lambda: numbers.put(2 * 10)).start()
multiprocessing.Process(target=lambda: numbers.put(2 * 20)).start()
multiprocessing.Process(target=lambda: numbers.put(30 + 40)).start()
print result.get()
