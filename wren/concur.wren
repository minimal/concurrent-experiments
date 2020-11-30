class Queue {
  construct new() {
    _queue = []
    _waiters = []
  }
  get() {
    if (_queue.count > 0) {
      return _queue.removeAt(0)
    }else {
      _waiters.add(Fiber.current)
      return Fiber.yield()
    }
  }
  put(item) {
    if (_waiters.count > 0) {
      var fib = _waiters.removeAt(0)
      return fib.call(item)
    } else _queue.add(item)
  }
}

var i = Queue.new()
var o = Queue.new()
Fiber.new {i.put(2 * 10)}.call()
Fiber.new {i.put(2 * 20)}.call()
Fiber.new {i.put(30 + 40)}.call()
Fiber.new {
  var a = i.get()
  var b = i.get()
  var c = i.get()
  o.put("%(a) + %(b) + %(c) = %(a + b + c)")
}.call()
System.print(o.get())