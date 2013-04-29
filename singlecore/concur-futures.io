// pure futures implementation in io
x := futureSend(2 * 10)
y := futureSend(2 * 20)
z := futureSend(30 + 40)
writeln(futureSend(
    "#{x} + #{y} + #{z} = #{x + y + z}" interpolate
))
