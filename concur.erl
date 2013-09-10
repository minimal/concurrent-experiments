-module(concur).
-compile(export_all).

proc(T, [A, B, C]) -> T ! io_lib:format("~B + ~B + ~B = ~B~n", [A, B, C, A + B + C]);
proc(T, A) -> receive B -> proc(T, lists:append(A, [B])) end.
run() -> Proc = spawn(?MODULE, proc, [self(), []]),
         spawn(fun() -> Proc ! 2 * 10 end),
         spawn(fun() -> Proc ! 2 * 20 end),
         spawn(fun() -> Proc ! 30 + 40 end),
         receive Result -> io:format(Result) end.
