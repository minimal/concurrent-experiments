local lanes = require "lanes".configure()
local linda = lanes.linda()

function proc()
    local k, x, y, z = linda:receive(nil, linda.batched, "num", 3, 3)
    return (x .. " + " .. y .. " + " .. z .. " = " .. (x + y + z))
end

a = lanes.gen("", proc)()
lanes.gen("", (function() linda:send("num", 2 * 10) end))()
lanes.gen("", (function() linda:send("num", 2 * 20) end))()
lanes.gen("", (function() linda:send("num", 30 + 40) end))()
print(a[1])
