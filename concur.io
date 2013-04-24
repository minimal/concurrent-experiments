numbers := List clone

waitOnList := method(list, while(list size < 1, yield); list removeAt(0))

result := Object clone do(run := method(
    x := waitOnList(numbers)
    y := waitOnList(numbers)
    z := waitOnList(numbers)
    x .. " + " .. y .. " + " .. z .. " = " .. (x + y + z)
)) @run

# theres a weird bug with `numbers @append(2* 10)` / `numbers futureSend(append(2 * 10))`
# the value appended is 200 not 20!
# using coroDoLater with whole thing instead
coroDoLater(numbers append(2 * 10))
coroDoLater(numbers append(2 * 20))
coroDoLater(numbers append(30 + 40))

writeln(result)