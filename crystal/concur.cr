channel = Channel(Int32).new
result = Channel(String).new
spawn do
  channel.send(2 * 10)
end
spawn do
  channel.send(2 * 20)
end
spawn do
  channel.send(30 + 40)
end
spawn do
  x = channel.receive
  y = channel.receive
  z = channel.receive
  result.send "#{x} + #{y} + #{z} = #{x + y + z}"
end

puts result.receive