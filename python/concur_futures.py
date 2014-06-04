import futures
from multiprocessing import Queue
import operator
import functools

if __name__ == '__main__':
    numq = Queue()
    stringchan = Queue()
    def add_nums():
        x = numq.get()
        y = numq.get()
        z = numq.get()
        stringchan.put("%d + %d + %d = %d" % (x, y, z, x + y + z))

    def putnum(f):
        numq.put(f())
    with futures.ProcessPoolExecutor() as executor:
        stringfuture = executor.submit(add_nums)
        executor.map(putnum,
                     [functools.partial(operator.mul, 2, 10),
                      functools.partial(operator.mul, 2, 20),
                      functools.partial(operator.add, 30, 40)])

    print stringchan.get(timeout=5)
