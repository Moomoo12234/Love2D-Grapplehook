local Player = Object:extend()

function Player:new()
    self.image = love.graphics.newImage("sprites/face.png")
    self.pos = vec2(100, 100)
    self.size = vec2(self.image:getWidth(), self.image:getHeight())
    self.angle = 0
    self.vel = vec2()

    self.collider = world:newRectangleCollider(self.pos.x, self.pos.y, self.size.x, self.size.y)
    --self.collider:setType("kinematic")

    self.friction = 1

    self.pullForce = 3060
    self.mousePressed = false
    self.grapplePos = vec2()
    self.grappleDir = vec2()

    self.linePos = vec2()

    self.ray = {
        startPos = vec2(),
        endPos = vec2(),
        hitlist = {},
        update = function ()
            self.ray.hitlist = {}
            self.ray.startPos.x, self.ray.startPos.y = self.collider:getPosition()
            self.ray.endPos.x, self.ray.endPos.y = cam:mousePosition()
        end,
        rayCallback = function (fixture, x, y, xn, yn, fraction)
            local hit = {}
            hit.fixture = fixture
            hit.x, hit.y = x, y
            hit.xn, hit.yn = xn, yn
            hit.fraction = fraction
            local lowestDist = 1
            for i, v in ipairs(self.ray.hitlist) do
                if v.fraction < lowestDist then
                    lowestDist = v.fraction
                end
            end
            if hit.fraction <= lowestDist then
                table.insert(self.ray.hitlist, 1, hit)
            end
            return 1
        end
    }
    self.rayLen = 3000
end

function Player:updateRay(mx, my)
    local rayAngle = self.pos:angleTo(vec2(mx, my))
    rayDir = vec2(math.cos(rayAngle), math.sin(rayAngle)):normalizeInplace()

    self.ray.update()
    cx, cy = cam:position()
    world:rayCast(self.ray.startPos.x, self.ray.startPos.y, rayDir.x * self.rayLen + cx, rayDir.y * self.rayLen+ cy, self.ray.rayCallback)
end

function Player:drawLine()
    self.lineTween = Flux.to(self.linePos, 0.05, self.grapplePos)

    if self.mousePressed then
        love.graphics.setLineWidth(4)
        love.graphics.line(self.pos.x, self.pos.y, self.linePos.x, self.linePos.y)
    end
end

function Player:controls(dt)
    local mx, my = cam:mousePosition()

    self:updateRay(mx, my)

    if love.mouse.isDown(1) and self.mousePressed == false and self.ray.hitlist[1] then
        self.mousePressed = true

        self.grapplePos = vec2(mx, my)
        self.linePos = vec2(self.pos.x, self.pos.y)

        if self.ray.hitlist[1] then
            self.grapplePos = vec2(self.ray.hitlist[1].x, self.ray.hitlist[1].y)
        end

    elseif love.mouse.isDown(1) == false and self.mousePressed then
        self.mousePressed = false
    end

    if self.mousePressed then
        local grappleAngle = self.pos:angleTo(self.grapplePos)
        --self.collider:setAngle(grappleAngle)
        self.grappleDir = vec2(
            math.cos(grappleAngle),
            math.sin(grappleAngle)
        )


        self.grappleDir = self.grappleDir:normalizeInplace()

        --self.vel.x = self.vel.x + self.grappleDir.x * self.pullForce * dt
        --self.vel = self.vel + self.grappleDir * self.pullForce * dt
        self.collider:applyLinearImpulse(
            self.vel.x + self.grappleDir.x * self.pullForce * dt,
            self.vel.y + self.grappleDir.y * self.pullForce * dt
        )

        --self.hookAngle = self.grapplePos:lookAt(self.pos)
    end
end

function Player:update(dt)
    --self.vel.y = self.vel.y + self.gravity * dt

    self:controls(dt)
    --self:addFriction(dt)

    --self.pos.x = self.pos.x + self.vel.x
    --self.pos.y = self.pos.y + self.vel.y

    self.pos.x = self.collider:getX()
    self.pos.y = self.collider:getY()

    self.angle = self.collider:getAngle()

    cam:lookAt(self.pos.x, self.pos.y)
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.image, self.pos.x, self.pos.y, self.angle, 1, 1, self.size.x /2, self.size.y / 2)

    self:drawLine()

    love.graphics.setColor(0.25, 0.25, 0.25)
    if self.ray.hitlist[1] then
        love.graphics.line(self.ray.startPos.x, self.ray.startPos.y, self.ray.hitlist[1].x, self.ray.hitlist[1].y)
        love.graphics.circle("fill", self.ray.hitlist[1].x, self.ray.hitlist[1].y, 10)
    end
    --love.graphics.draw(self.hookImage, self.grapplePos.x, self.grapplePos.y, self.hookAngle - math.pi / 2, 1, 1, self.hookSize.x / 2, self.hookSize.y / 2)
end

return Player()