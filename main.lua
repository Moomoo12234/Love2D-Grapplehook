love = require "love"

function mapColliders()
    local walls = {}
    if map.layers["Collision"] then
        for i, obj in ipairs(map.layers["Collision"].objects) do
            print(obj.x, obj.y, obj.width, obj.height)
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType("static")
            table.insert(walls, wall)
        end
    end
    return walls
end

function love.load()
    Object = require "libraries.classic"
    HC = require "libraries.HC"
    Flux = require "libraries.flux"
    sti = require "libraries.sti"
    camera = require "libraries.hump.camera"
    vec2 = require "libraries.hump.vector"
    wf = require "libraries.windfield"

    world = wf.newWorld(0, 512)

    Player = require "scripts.player"
    Cursor = require "scripts.cursor"

    map = sti("tilemap.lua")
    walls = mapColliders()
    cam = camera()

    love.mouse.setVisible(false)
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.update(dt)
    Player:update(dt)
    Cursor:update()

    Flux.update(dt)
    world:update(dt)
end

function love.draw()
    cam:attach()
        love.graphics.print(love.timer.getFPS())
        Player:draw()
        Cursor:draw()
        world:draw()

        map:drawLayer(map.layers["Layer"])
    cam:detach()
end

