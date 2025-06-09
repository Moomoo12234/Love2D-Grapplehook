local love = require "love"

local Cursor = Object:extend()

function Cursor:new()
    self.image = love.graphics.newImage("/sprites/cursor.png")
    self.pos = vec2(0, 0)
    self.size = vec2(self.image:getWidth(), self.image:getHeight())
end

function Cursor:update()
    local mx, my = cam:mousePosition()
    Flux.to(self.pos, 0.05, vec2(mx, my))
end

function Cursor:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.image, self.pos.x - self.size.x / 2, self.pos.y - self.size.y / 2)
end

return Cursor()