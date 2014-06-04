numbers = (1..3).map do IO.pipe end
result_r, result_w = IO.pipe

get_ready = Proc.new do
    IO::select(numbers.map do |i| i[0] end)[0][0]
end

proc = fork {
    x = Marshal.load(get_ready.call)
    y = Marshal.load(get_ready.call)
    z = Marshal.load(get_ready.call)
    result_w.puts "#{x} + #{y} + #{z} = %d" % [x + y + z]
}

Process.detach(fork { Marshal.dump(2 * 10, numbers[0][1]) })
Process.detach(fork { Marshal.dump(2 * 20, numbers[1][1]) })
Process.detach(fork { Marshal.dump(30 + 40, numbers[2][1]) })

Process.waitpid(proc)
puts result_r.gets
