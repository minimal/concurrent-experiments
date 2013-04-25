current_pid = self

receiver = spawn fn ->
receive do
    { :result, res } ->
    a = res
    receive do
        {:result, res2 } ->
        b = res2
        receive do
            {:result, res3 } ->
            c = res3
            d = a + b + c
            current_pid <- {:final, "#{a} + #{b} + #{c} = #{d}"}
        end
    end
end
end


spawn fn -> receiver <- {:result, 2 * 10}
end
spawn fn -> receiver <- {:result, 2 * 20}
end
spawn fn -> receiver <- {:result, 30 + 40}
end

receive do
    {:final, result} ->
    IO.puts result
end
