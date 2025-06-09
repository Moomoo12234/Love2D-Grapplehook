local love = require "love"

local Spike = Object:extend()

function Spike:new(pos, dir)
    self.image = love.graphics.newImage("sprites/spike.png")
    self.pos = vec2(pos.x, pos.y)
    self.size = vec2(self.image:getWidth(), self.image:getHeight())
    
    self.collider = world:newPolygonCollider({0, 0, 16, -32, 32, 0})
    self.collider:setPosition(pos.x, pos.y)
    self.collider:setType("static")
    self.collider:setCollisionClass("spikes")

    self.angle = 0

    --if dir == "spikesLeft" then
    --    self.angle = math.rad(-90)
    --elseif dir == "spikesDown" then
    --    self.angle = math.rad(180)
    --elseif dir == "spikesRight" then
    --    self.angle = math.rad(90)
    --end
end

return Spike