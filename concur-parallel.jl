# julia parallel example
numbers = RemoteRef()
result = @spawn(begin
  x = take(numbers)
  y = take(numbers)
  z = take(numbers)
  "$x + $y + $z + $(x + y + z)"
end)
@spawn(put(numbers, 2 * 10))
@spawn(put(numbers, 2 * 20))
@spawn(put(numbers, 30 + 40))
println(fetch(result))