lockfile = File.open(Dir.getwd)
numbers_r, numbers_w = IO.pipe
result_r, result_w = IO.pipe

proc = fork {
    numbers_w.close
    result_r.close
    x = Marshal.load(numbers_r)
    y = Marshal.load(numbers_r)
    z = Marshal.load(numbers_r)
    result_w.puts "#{x} + #{y} + #{z} = %d" % [x + y + z]
}

lockndump = Proc.new do |val, out|
    lockfile.flock(File::LOCK_EX)
    Marshal.dump(val, out)
    lockfile.flock(File::LOCK_UN)
end

Process.detach(fork { lockndump.call(2 * 10, numbers_w) })
Process.detach(fork { lockndump.call(2 * 20, numbers_w) })
Process.detach(fork { lockndump.call(30 + 40, numbers_w) })

Process.waitpid(proc)
puts result_r.gets
