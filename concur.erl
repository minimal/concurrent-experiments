-module(concur).
-compile(export_all).

proc(T) -> receive A -> proc(T, A) end.
proc(T, A) -> receive B -> proc(T, A, B) end.
proc(T, A, B) -> receive C -> T ! io_lib:format("~B + ~B + ~B = ~B~n", [A, B, C, A + B + C]) end.
run() -> Proc = spawn(?MODULE, proc, [self()]),
         spawn(fun() -> Proc ! 2 * 10 end),
         spawn(fun() -> Proc ! 2 * 20 end),
         spawn(fun() -> Proc ! 30 + 40 end),
         receive Result -> io:format(Result) end.
