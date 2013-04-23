import futures
from multiprocessing import Queue


if __name__ == '__main__':
    numq = Queue()
    stringchan = Queue()
    def add_nums():
        x = numq.get()
        y = numq.get()
        z = numq.get()
        stringchan.put("%d + %d + %d = %d" % (x, y, z, x + y + z))

    def putnum(x):
        numq.put(x)
    with futures.ProcessPoolExecutor() as executor:
        stringfuture = executor.submit(add_nums)
        executor.submit(putnum, 2 * 10)
        executor.submit(putnum, 2 * 20)
        executor.submit(putnum, 30 + 40)

    print stringchan.get()
