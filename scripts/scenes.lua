Scene = Object:extend()

SceneManager = Object:extend()

function SceneManager:new(scenes)
    self.scenes = scenes
    self.scene = 1
end

function SceneManager:update()
    self.scenes[self.scene]:update()
end

function SceneManager:draw()
    self.scenes[self.scene]:draw()
end