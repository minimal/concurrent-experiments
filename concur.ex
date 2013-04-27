current_pid = self
receiver = spawn fn -> 
    receive do
        {a} -> 
    end
    receive do
        {b} -> 
    end
    receive do
        {c} -> 
        d = a + b + c
        current_pid <- {"#{a} + #{b} + #{c} = #{d}"}
    end
end

spawn fn -> receiver <- { 2 * 10 } end
spawn fn -> receiver <- { 2 * 20 } end
spawn fn -> receiver <- { 30 + 40 } end
receive do
    {result} -> IO.puts result
end
