require 'fiber'  # ruby >= 2.0

receiver = Fiber.new do |queue|
    x = queue.get
    y = queue.get
    z = queue.get
    queue.put("#{x} + #{y} + #{z} = %d" % [x + y + z])
end

class Queue
    def initialize(scheduler)
        @scheduler = scheduler
        @queue = []
        @waiters = []
    end
    def put(item)
        if !@waiters.empty?
            f = @waiters.shift
            @scheduler.schedule(f, item)
        else
            @queue.push(item)
        end
    end
    def get
        if @queue.empty?
            @waiters.push(Fiber.current)
            return Fiber.yield
        else
            return @queue.shift
        end
    end
end

class Scheduler
    def initialize
        @runnable = []
    end
    def run
        while ! @runnable.empty?
            f = @runnable.shift
            f[0].transfer(*f.slice(1, f.length))
        end
    end
    def schedule(f, *args)
        @runnable.push([f, *args])
    end
end

s = Scheduler.new
q = Queue.new(s)
s.schedule(receiver, q)
s.schedule(Fiber.new do q.put(2 * 10) end)
s.schedule(Fiber.new do q.put(2 * 20) end)
s.schedule(Fiber.new do q.put(30 + 40) end)
s.run
puts q.get
