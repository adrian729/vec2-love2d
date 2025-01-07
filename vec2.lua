-- Vec2 module to practice metatables and Lua
-- Lua v5.1^
local Vec2 = {}

function Vec2:new(x, y)
  return setmetatable(
    {
      x = x or 0,
      y = y or 0,
    },
    self
  )
end

function Vec2:fromAngle(angle)
  return Vec2:new(math.cos(angle), math.sin(angle))
end

function Vec2:__index(key)
  if key == nil then
    return Vec2
  end

  if type(key) == 'number' then
    if key == 1 then
      return self.x
    elseif key == 2 then
      return self.y
    end
  end

  if type(key) ~= 'string' then
    return
  end
  if key == 'a' then
    return self.x
  elseif key == 'b' then
    return self.y
  elseif key == 'X' then
    return self.x
  elseif key == 'Y' then
    return self.y
  end

  return Vec2[key]
end

function Vec2:__tostring()
  return '(' .. self.x .. ', ' .. self.y .. ')'
end

-------------
-- arithmetic

-- non-trivial operations Hadamard style

function Vec2.__add(a, b)
  if type(a) == "number" then
    return Vec2:new(a + b.x, a + b.y)
  elseif type(b) == "number" then
    return Vec2:new(a.x + b, a.y + b)
  end
  return Vec2:new(a.x + b.x, a.y + b.y)
end

function Vec2.__sub(a, b)
  if type(a) == "number" then
    return Vec2:new(a - b.x, a - b.y)
  elseif type(b) == "number" then
    return Vec2:new(a.x - b, a.y - b)
  end
  return Vec2:new(a.x - b.x, a.y - b.y)
end

function Vec2.__mul(a, b)
  if type(a) == "number" then
    return Vec2:new(a * b.x, a * b.y)
  elseif type(b) == "number" then
    return Vec2:new(a.x * b, a.y * b)
  end
  -- Hadamard product
  return Vec2:new(a.x * b.x, a.y * b.y)
end

function Vec2.__div(a, b)
  if type(a) == "number" then
    return Vec2:new(a / b.x, a / b.y)
  elseif type(b) == "number" then
    return Vec2:new(a.x / b, a.y / b)
  end
  -- Hadamard product
  return Vec2:new(a.x / b.x, a.y / b.y)
end

function Vec2.__mod(a, b)
  if type(a) == "number" then
    return Vec2:new(a % b.x, a % b.y)
  elseif type(b) == "number" then
    return Vec2:new(a.x % b, a.y % b)
  end
  -- Hadamard product style mod
  return Vec2:new(a.x % b.x, a.y % b.y)
end

function Vec2.__pow(a, b)
  if type(a) == "number" then
    return Vec2:new(a ^ b.x, a ^ b.y)
  elseif type(b) == "number" then
    return Vec2:new(a.x ^ b, a.y ^ b)
  end
  -- Hadamard product style pow
  return Vec2:new(a.x ^ b.x, a.y ^ b.y)
end

function Vec2.__unm(a)
  return Vec2:new(-a.x, -a.y)
end

function Vec2.__idiv(a, b)
  -- floor division
  if type(a) == "number" then
    return Vec2:new(math.floor(a / b.x), math.floor(a / b.y))
  elseif type(b) == "number" then
    return Vec2:new(math.floor(a.x / b), math.floor(a.y / b))
  end
  -- Hadamard product style idiv
  return Vec2:new(math.floor(a.x / b.x), math.floor(a.y / b.y))
end

-------------
-- relational

-- relational operations by comparing each component.

function Vec2.__eq(a, b)
  return a.x == b.x and a.y == b.y
end

function Vec2.__lt(a, b)
  return a.x < b.x and a.y < b.y
end

function Vec2.__le(a, b)
  return a.x <= b.x and a.y <= b.y
end

-----------------
-- Vec2 functions

function Vec2:magnitude()
  return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

Vec2.mag = Vec2.magnitude

function Vec2:setMagnitude(m)
  -- modifies self, returns self
  local frac = m / self:magnitude()
  self.x = frac * self.x
  self.y = frac * self.y

  return self
end

Vec2.setMag = Vec2.setMagnitude

function Vec2:angle(v)
  -- angle value in rads.
  -- domain [-pi, pi]
  v = v or Vec2:new(1, 0)
  return math.atan2(Vec2.det(self, v), Vec2.dot(self, v))
end

Vec2.rotation = Vec2.angle
Vec2.heading = Vec2.angle

function Vec2.distance(a, b)
  return math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2)
end

function Vec2.dot(a, b) -- cos
  return a.x * b.x + a.y * b.y
end

Vec2.scalar = Vec2.dot

function Vec2.det(a, b) -- sin
  return a.x * b.y - a.y * b.x
end

Vec2.determinant = Vec2.det

function Vec2.toRad(a)
  return a * 180 / math.pi
end

Vec2.toRadians = Vec2.toRad

function Vec2.direction(val)
  -- if val is a num, we take it as the angle in rads
  if type(val) == 'number' then
    return Vec2:fromAngle(val)
  end
  -- else, we expect it to be a Vec2
  return val:setMagnitude(1)
end

return Vec2
