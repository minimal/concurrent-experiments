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
           