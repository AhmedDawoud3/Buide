-- Represents the state of the game in which we are actively playing;
-- player should control the bun, with his mouse cursor
PlayState = Class {
    __includes = BaseState
}

function PlayState:enter(params)
    player = {}
    edges = {}
    boxes = {}
    cBoxes = {}
    e = EffectManager()
    mouseHandler = MouseHandler()
    playing = true
    timer = 0

    -- new Box2D "world" which will run all of our physics calculations
    world = love.physics.newWorld(0, 1500)

    -- body that stores velocity and position and all fixtures
    player.body = love.physics.newBody(world, Window.width - 100, 25, 'dynamic')

    -- shape that we will attach using a fixture to our body for collision detection
    player.shape = love.physics.newCircleShape(20)

    -- fixture that attaches a shape to our body
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setRestitution(1.05)

    CreateFullEdge('left')
    CreateFullEdge('right')
    CreateFullEdge('upper')

    CreateEdge(0, 0, Window.width - 200, 0)

    CreateRectangle(Window.width - 90, Window.height - 100, 120, 10, -35)
    CreateRectangle(800, 400, 260, 10, 12.25)
    CreateRectangle(10, 580, 280, 10, 45)
    CreateDownOpening(Window.width / 2, 100)
end

function PlayState:update(dt)
    -- update world, calculating collisions
    if dt < 0.04 then
        world:update(dt)
        e:update(dt)
        mouseHandler:update(dt)
    end

    if love.keyboard.wasPressed('c') then
        ClearAllCustomBoxes()
    elseif love.keyboard.wasPressed('r') then
        Restart()
    elseif love.keyboard.isDown('lctrl') and love.keyboard.wasPressed('z') then
        CleareLastCustomBox()
    end

    player.x, player.y = player.body:getPosition()
    local vX, vY = player.body:getLinearVelocity()
    player.velocity = math.sqrt(vY ^ 2 + vY ^ 2)
    if playing then
        timer = timer + dt
    end
    if player.y > Window.height then
        playing = false
    end
end

function PlayState:render()
    love.graphics.clear(0.16, 0.19, 0.2, 1)
    e:draw()
    local endX, endY = player.body:getLinearVelocity()
    love.graphics.setColor(0.99, 0.85, 0, 1)
    love.graphics.circle("fill", player.x, player.y, 20)
    if gStateMachine.DEBUG then
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.line(player.x, player.y, player.x + endX / 15, player.y + endY / 15)
    end
    love.graphics.setLineWidth(4)
    love.graphics.setColor(0.51, 0.51, 0.51, 1)
    for i, v in ipairs(edges) do
        love.graphics.line(v[1]:getWorldPoints(v[2]:getPoints()))
    end
    for i, v in ipairs(boxes) do
        love.graphics.polygon('fill', v[1]:getWorldPoints(v[2]:getPoints()))
    end
    for i, v in ipairs(cBoxes) do
        love.graphics.polygon('fill', v[1]:getWorldPoints(v[2]:getPoints()))
    end
    mouseHandler:render()
    love.graphics.setFont(fonts['Bold16'])
    if playing then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('Time: ' .. string.sub(tostring(timer), 1, 4), 0, 30, Window.width, 'center')
    else
        love.graphics.setColor(0, 0, 0, 0.3)
        love.graphics.rectangle('fill', 0, 0, Window.width, Window.height)
        love.graphics.setFont(fonts['Bold32'])
        love.graphics.setColor(1, 0.1, 0.1, 1)
        love.graphics.printf('Time: ' .. string.sub(tostring(timer), 1, 8), 0, Window.height / 2 - 30, Window.width,
            'center')
    end

end

function Restart()
    player.fixture:destroy()
    -- body that stores velocity and position and all fixtures
    player.body = love.physics.newBody(world, Window.width - 100, 25, 'dynamic')
    -- fixture that attaches a shape to our body
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setRestitution(1.1)
    timer = 0
    playing = true
end

function ClearAllCustomBoxes()
    for i, v in ipairs(cBoxes) do
        v[3]:destroy()
    end
    cBoxes = {}
end

function CleareLastCustomBox()
    if #cBoxes > 0 then
        cBoxes[#cBoxes][3]:destroy()
        cBoxes[#cBoxes] = nil
    end
end

function CreateEdge(x, y, width, height)
    --  static ground body
    table.insert(b, love.physics.newBody(world, x, y, 'static'))

    -- edge shape Box2D provides, perfect for ground
    table.insert(b, love.physics.newEdgeShape(x, y, width, height))

    -- affix edge shape to our body
    table.insert(b, love.physics.newFixture(b[1], b[2]))
    table.insert(edges, b)
end

function CreateFullEdge(place)
    if place == 'left' then
        b = {}
        --  static ground body
        table.insert(b, love.physics.newBody(world, 0, 0, 'static'))

        -- edge shape Box2D provides, perfect for ground
        table.insert(b, love.physics.newEdgeShape(0, 0, 0, Window.height))

        -- affix edge shape to our body
        table.insert(b, love.physics.newFixture(b[1], b[2]))

        table.insert(edges, b)
    elseif place == 'right' then
        b = {}
        --  static ground body
        table.insert(b, love.physics.newBody(world, Window.width, 0, 'static'))

        -- edge shape Box2D provides, perfect for ground
        table.insert(b, love.physics.newEdgeShape(0, 0, 0, Window.height))

        -- affix edge shape to our body
        table.insert(b, love.physics.newFixture(b[1], b[2]))

        table.insert(edges, b)
    elseif place == 'down' then
        b = {}
        --  static ground body
        table.insert(b, love.physics.newBody(world, 0, Window.height, 'static'))

        -- edge shape Box2D provides, perfect for ground
        table.insert(b, love.physics.newEdgeShape(0, 0, Window.width, 0))

        -- affix edge shape to our body
        table.insert(b, love.physics.newFixture(b[1], b[2]))

        table.insert(edges, b)
    elseif place == 'upper' then
        b = {}
        --  static ground body
        table.insert(b, love.physics.newBody(world, 0, 0, 'static'))

        -- edge shape Box2D provides, perfect for ground
        table.insert(b, love.physics.newEdgeShape(0, 0, Window.width, 0))

        -- affix edge shape to our body
        table.insert(b, love.physics.newFixture(b[1], b[2]))

        table.insert(edges, b)
    end
end

function CreateBox(x, y, size, rotation)
    local Box = {}
    table.insert(Box, love.physics.newBody(world, x, y, 'static'))
    table.insert(Box, love.physics.newRectangleShape(size or 100, size or 100))
    table.insert(Box, love.physics.newFixture(Box[1], Box[2]))
    if rotation then
        Box[1]:setAngle(rotation * (3.14159265 / 180))
    end
    table.insert(boxes, Box)
end

function CreateRectangle(x, y, width, height, rotation, xOffset, yOffset)
    local Box = {}
    table.insert(Box, love.physics.newBody(world, x, y, 'static'))
    table.insert(Box, love.physics.newRectangleShape(width or 100, height or 100))
    table.insert(Box, love.physics.newFixture(Box[1], Box[2]))
    Box[1]:setPosition(x + (xOffset or 0), y + (yOffset or 0))
    if rotation then
        Box[1]:setAngle(rotation * (3.14159265 / 180))
    end
    table.insert(boxes, Box)
end

function CreateCustomRectangle(x, y, width, height, rotation, xOffset, yOffset)
    local Box = {}
    table.insert(Box, love.physics.newBody(world, x, y, 'static'))
    table.insert(Box, love.physics.newRectangleShape(width or 100, height or 100))
    table.insert(Box, love.physics.newFixture(Box[1], Box[2]))
    Box[1]:setPosition(x + (xOffset or 0), y + (yOffset or 0))
    if rotation then
        Box[1]:setAngle(rotation * (3.14159265 / 180))
    end
    table.insert(cBoxes, Box)
end

function CreateDownOpening(x, size)
    CreateRectangle(0, Window.height - 5, Window.width, 5, 0, -Window.width / 2 + x - size / 2, 0)
    CreateRectangle(Window.width, Window.height - 5, Window.width, 5, 0, -Window.width / 2 + x + size / 2, 0)
end
