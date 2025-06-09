local sceneManager = Object:extend()

function sceneManager:new()
    self.scenes = {}
    self.scene = 1
end

function sceneManager:update()
    self.scene[self.scene]:draw()
end

function sceneManager:draw()
    self.scenes[self.scene]:draw()
end

return sceneManager()