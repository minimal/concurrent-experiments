require 'thread'

queue = Queue.new

receiver = Thread.new do
    x = queue.pop
    y = queue.pop
    z = queue.pop
    "#{x} + #{y} + #{z} = %d" % [x + y + z]
end

Thread.new { queue << 2 * 10 }
Thread.new { queue << 2 * 20 }
Thread.new { queue << 30 + 40 }

receiver.join
puts receiver.value
