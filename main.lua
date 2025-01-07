_G.debug = false

local v

function love.load(arg, _unfilteredArg)
  Vec2 = require("vec2")

  for _, v in pairs(arg) do
    if v == '--debug' or v == '--d' then
      _G.debug = true
    end
  end

  v = Vec2:new(0, 1)
end

function love.update(dt)
end

function love.draw()
end
