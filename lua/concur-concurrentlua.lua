concurrent = require 'concurrent'

r = concurrent.spawn(function() print(concurrent.receive()) end)
p = concurrent.spawn(function(resp)
  local x = concurrent.receive()
  local y = concurrent.receive()
  local z = concurrent.receive()
  concurrent.send(resp,(x .. " + " .. y .. " + " .. z .. " = " .. (x + y + z)))
end, r)
concurrent.spawn(function() concurrent.send(p, (2 * 10)) end)
concurrent.spawn(function() concurrent.send(p, (2 * 20)) end)
concurrent.spawn(function() concurrent.send(p, (30 + 40)) end)
concurrent.loop()
