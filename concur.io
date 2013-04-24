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

# theres a weird bug with `numbers @append(2* 10)` / `numbers futureSend(append(2 * 10))`
# the value append is 200 not 20!
# using coroDoLater with whole thing instead
coroDoLater(numbers put(2 * 10))
coroDoLater(numbers put(2 * 20))
coroDoLater(numbers put(30 + 40))

writeln(result)