# julia coroutines example
# the below uses the built-in scheduler and yielding
# in an emulation of an actor implementation.

proc = Task(() -> begin
  x = wait()
  y = wait()
  z = wait()
  produce("$x + $y + $z = $(x + y + z)")
end)
@schedule(yieldto(proc, 2 * 10))
@schedule(yieldto(proc, 2 * 20))
@schedule(yieldto(proc, 30 + 40))
println(consume(proc))

# alternatively, we could easily build a queue for
# communication between the coroutines to be similar
# to some of the other implementations:
#
# type Queue
#   cond::Condition
#   values::Array{Any, 1}
#   Queue() = new(Condition(), Any[])
# end
# put(q::Queue, v) = (push!(q.values, v); notify(q.cond))
# get(q::Queue) = while true
#   if length(q.values) > 0
#      return shift!(q.values)
#   else
#     wait(q.cond)
#   end
# end