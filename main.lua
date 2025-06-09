love = require "love"

world = {}

function nextLevel()
    level = level + 1
    genMap(level)
end

function genMap(lvl)
    world:destroy()

    world = wf.newWorld(0, 512)
    world:addCollisionClass("spikes")
    world:addCollisionClass("end")

    Player = player()

    map = sti("tilemaps/level"..lvl..".lua")
    walls = mapColliders()
    spikes = {}
    if map.layers["Entities"] then
        for i, obj in ipairs(map.layers['Entities'].objects) do
            if obj.type == "spike" then
                local spike = Spike(vec2(obj.x, obj.y), obj.properties["spikeDir"])
                table.insert(spikes, spike)
            elseif obj.name == "start" then
                Player.collider:setPosition(obj.x, obj.y)
                Player.startPos = vec2(obj.x, obj.y)
            elseif obj.name == "end" then
                print(obj.x, obj.y)
                print(Player.pos.x, Player.pos.y)
                local endPos = world:newRectangleCollider(obj.x, obj.y - 32, obj.width, obj.height)
                endPos:setCollisionClass("end")
                endPos:setType("static")
            end
        end
    end
end

function mapColliders()
    local walls = {}
    if map.layers["Collision"] then
        for i, obj in ipairs(map.layers["Collision"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType("static")
            table.insert(walls, wall)
        end
    end
    return walls
end

function love.load()
    Object = require "libraries.classic"
    Flux = require "libraries.flux"
    sti = require "libraries.sti"
    camera = require "libraries.hump.camera"
    vec2 = require "libraries.hump.vector"
    timer = require "libraries.hump.timer"
    wf = require "libraries.windfield"

    world = wf.newWorld(0, 512)
    world:addCollisionClass("spikes")
    world:addCollisionClass("end")

    player = require "scripts.player"
    Cursor = require "scripts.cursor"
    Spike = require "scripts.spike"

    require "scripts.scenes"

    level = 1
    levelGenned = false
    genMap(level)

    cam = camera()

    love.mouse.setVisible(false)
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.update(dt)
    Player:update(dt)
    Cursor:update()

    timer.update(dt)
    Flux.update(dt)
    world:update(dt)
end

function love.draw()
    cam:attach()
        love.graphics.print(love.timer.getFPS(), cam:position())
        Player:draw()
        Cursor:draw()
        world:draw()

        --love.graphics.setColor(1, 0, 0)
        map:drawLayer(map.layers["Layer"])
        map:drawLayer(map.layers["Entities"])
    cam:detach()
end

