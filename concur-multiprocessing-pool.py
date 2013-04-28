import operator
import multiprocessing

queue = multiprocessing.Queue()


def proc():
    x = queue.get()
    y = queue.get()
    z = queue.get()
    return "%d + %d + %d = %d" % (x, y, z, x + y + z)

pool = multiprocessing.Pool(4)
r = pool.apply_async(proc)
pool.apply_async(operator.mul, (2, 10), callback=queue.put)
pool.apply_async(operator.mul, (2, 20), callback=queue.put)
pool.apply_async(operator.add, (30, 40), callback=queue.put)
print r.get()
