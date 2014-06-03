function proc(main)
  t = Task(() -> begin
    x = wait()
    y = wait()
    z = wait()
    yieldto(main, "$x + $y + $z = $(x + y + z)")
  end)
  schedule(t)
  t
end
p = proc(current_task())
@schedule(yieldto(p, 2 * 10))
@schedule(yieldto(p, 2 * 20))
@schedule(yieldto(p, 30 + 40))
println(wait())
           