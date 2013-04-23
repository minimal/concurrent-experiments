import eventlet


if __name__ == '__main__':
    numbers = eventlet.queue.Queue()
    stringchan = eventlet.event.Event()

    @eventlet.spawn
    def proc():
        x = numbers.get()
        y = numbers.get()
        z = numbers.get()
        stringchan.send("%d + %d + %d = %d" % (x, y, z, x + y + z))

    eventlet.spawn(lambda: numbers.put(2 * 10))
    eventlet.spawn(lambda: numbers.put(2 * 20))
    eventlet.spawn(lambda: numbers.put(30 + 40))

    print stringchan.wait()