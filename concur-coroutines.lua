waiters = {}
queue = {}
runnable = {}

function get()
    if # queue > 0 then
        res = queue[1]
        table.remove(queue, 1)
        return res
    end
    table.insert(waiters, coroutine.running())
    return coroutine.yield()
end

function put(item)
    if # waiters > 0 then
        co = waiters[1]
        table.remove(waiters, 1)
        table.insert(runnable, {co, item})
        return
    end
    table.insert(queue, item)
end

loop = coroutine.create(function()
    while # runnable > 0 do
        co, val = runnable[1][1], runnable[1][2]
        table.remove(runnable, 1)
        if coroutine.status(co) ~= "dead" then
            coroutine.resume(co, val)
        end
    end
end)

function yield()
    co = coroutine.running()
    table.insert(runnable, {co, nil})
    coroutine.resume(loop)
end

proc = coroutine.create(function()
    x = get()
    y = get()
    z = get()
    put(x .. " + " .. y .. " + " .. z .. " = " .. (x + y + z))
end)
table.insert(runnable, {proc, nil})
table.insert(runnable, {coroutine.create(put), 2 * 10})
table.insert(runnable, {coroutine.create(put), 2 * 20})
table.insert(runnable, {coroutine.create(put), 30 + 40})

coroutine.resume(loop)
print(get())
