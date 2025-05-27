---@diagnostic disable: deprecated


--====================================================================================================

vec2 = Object:extend()

function vec2:new(x, y)
    self.x = x or 0
    self.y = y or 0
end

function vec2:normalise()
    local length = math.sqrt(self.x*self.x + self.y*self.y)
    if self.x/length ~= self.x/length then
        self.x = 0
    else
        self.x = (self.x/length)
    end

    if self.y/length ~= self.y/length then
        self.y = 0
    else
        self.y = (self.y/length)
    end
end

function vec2:lookAt(target)
    local angle = math.atan2((target.y - self.y), (target.x - self.x))

    if angle ~= angle then
        angle = 0
    end
    return angle
end

--====================================================================================================