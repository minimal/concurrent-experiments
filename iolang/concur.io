// uses coroutines and is single-threaded
numbers := Object clone do (
    queue := List clone
    futures := List clone
    put := method(item,
        if(futures size > 0, futures removeAt(0) setResult(item), queue append(item))
        self)
    get := method(
        if(queue size < 1,
            future := Future clone
            futures append(future)
            return future futureProxy)
        queue removeAt(0))
)

result := Object clone do(run := method(
    x := numbers get
    y := numbers get
    z := numbers get
    x .. " + " .. y .. " + " .. z .. " = " .. (x + y + z)
)) @run

numbers @put(2 * 10)
numbers @put(2 * 20)
numbers @put(30 + 40)

writeln(result)
