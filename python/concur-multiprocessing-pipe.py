import multiprocessing


def proc(conn):
    x = conn.recv()
    y = conn.recv()
    z = conn.recv()
    conn.send("%d + %d + %d = %d" % (x, y, z, x + y + z))
    conn.close()


def withlock(lock, call, *args, **kw):
    with lock:
        return call(*args, **kw)

if __name__ == '__main__':
    lock = multiprocessing.RLock()
    parent_conn, child_conn = multiprocessing.Pipe()
    multiprocessing.Process(target=proc, args=(child_conn,)).start()
    multiprocessing.Process(target=lambda: withlock(lock, parent_conn.send, 2 * 10)).start()
    multiprocessing.Process(target=lambda: withlock(lock, parent_conn.send, 2 * 20)).start()
    multiprocessing.Process(target=lambda: withlock(lock, parent_conn.send, 30 + 40)).start()
    print parent_conn.recv()
