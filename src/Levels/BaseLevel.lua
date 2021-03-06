BaseLevel = Class {}

function BaseLevel:init()
end

function BaseLevel:enter()
    self.world = love.physics.newWorld(0, 1500)
    self.player = {
        shape = love.physics.newCircleShape(20),
        body = love.physics.newBody(self.world, Window.width / 2, Window.height / 2, 'dynamic'),
        fixture = love.physics.newFixture(self.player.body, self.player.shape)
    }
    self.player.fixture:setRestitution(1.05)
    self.player = {}
    self.edges = {}
    self.boxes = {}
    self.cBoxes = {}
    self.e = EffectManager()
    self.mouseHandler = MouseHandler()
    self.playing = false
    self.timer = 0
end

function BaseLevel:exit()
    self.world:destroy()
end

function BaseLevel:update(dt)
    self.player.x, self.player.y = self.player.body:getPosition()
    if self.playing then
        self.timer = self.timer + dt
    end
    if dt < 0.04 then
        self.world:update(dt)
        if self.ballTrail then
            self.e:update(dt, self)
        end
        self.mouseHandler:update(dt)
    end

    if love.keyboard.wasPressed('c') then
        self:ClearAllCustomBoxes()
    elseif love.keyboard.wasPressed('r') then
        self:Restart()
    elseif love.keyboard.wasPressed('f12') then
        love.graphics.captureScreenshot(os.time() .. '.png')
    elseif love.keyboard.isDown('lctrl') and love.keyboard.wasPressed('z') then
        self:CleareLastCustomBox()
    end

end

function BaseLevel:render()
    love.graphics.clear(0.16, 0.19, 0.2, 1)
    if options.BallTrail then
        self.e:draw()
    end
    love.graphics.setColor(options.ballColor[1], options.ballColor[2], options.ballColor[3], 1)
    if self.player.x and self.player.y then
        love.graphics.circle("fill", self.player.x, self.player.y, 20)
    end
    love.graphics.setColor(0.51, 0.51, 0.51, 1)
    for i, v in ipairs(self.edges) do
        love.graphics.line(v[1]:getWorldPoints(v[2]:getPoints()))
    end
    for i, v in ipairs(self.boxes) do
        love.graphics.polygon('fill', v[1]:getWorldPoints(v[2]:getPoints()))
    end
    for i, v in ipairs(self.cBoxes) do
        love.graphics.polygon('fill', v[1]:getWorldPoints(v[2]:getPoints()))
    end
    self.mouseHandler:render()

    love.graphics.setFont(fonts['Bold16'])
    if self.playing then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('Time: ' .. string.sub(tostring(self.timer), 1, 4), 0, 30, Window.width, 'center')
    else
        love.graphics.setColor(0, 0, 0, 0.3)
        love.graphics.rectangle('fill', 0, 0, Window.width, Window.height)
        love.graphics.setFont(fonts['Bold32'])
        love.graphics.setColor(1, 0.1, 0.1, 1)
        love.graphics.printf('Time: ' .. string.sub(tostring(self.timer), 1, 8), 0, Window.height / 2 - 30, Window.width,
            'center')
    end
end

function BaseLevel:Restart()
    self.player.fixture:destroy()
    self.player.body = love.physics.newBody(world, self.originalPlayerX, self.originalPlayery, 'dynamic')
    self.fixture = love.physics.newFixture(self.player.body, self.player.shape)
    self.player.fixture:setRestitution(1.1)
    self.timer = 0
    self.playing = true
end

function BaseLevel:ClearAllCustomBoxes()
    for i, v in ipairs(self.cBoxes) do
        v[3]:destroy()
    end
    self.cBoxes = {}
end

function BaseLevel:CleareLastCustomBox()
    if #self.cBoxes > 0 then
        self.cBoxes[#self.cBoxes][3]:destroy()
        self.cBoxes[#self.cBoxes] = nil
    end
end

function BaseLevel:CreateEdge(x, y, width, height)
    local b = {}
    --  static ground body
    table.insert(b, love.physics.newBody(self.world, x, y, 'static'))

    -- edge shape Box2D provides, perfect for ground
    table.insert(b, love.physics.newEdgeShape(x, y, width, height))

    -- affix edge shape to our body
    table.insert(b, love.physics.newFixture(b[1], b[2]))
    table.insert(self.edges, b)
end

function BaseLevel:CreateFullEdge(place)
    if place == 'left' then
        local b = {}
        --  static ground body
        table.insert(b, love.physics.newBody(self.world, 0, 0, 'static'))

        -- edge shape Box2D provides, perfect for ground
        table.insert(b, love.physics.newEdgeShape(0, 0, 0, Window.height))

        -- affix edge shape to our body
        table.insert(b, love.physics.newFixture(b[1], b[2]))

        table.insert(self.edges, b)
    elseif place == 'right' then
        local b = {}
        --  static ground body
        table.insert(b, love.physics.newBody(self.world, Window.width, 0, 'static'))

        -- edge shape Box2D provides, perfect for ground
        table.insert(b, love.physics.newEdgeShape(0, 0, 0, Window.height))

        -- affix edge shape to our body
        table.insert(b, love.physics.newFixture(b[1], b[2]))

        table.insert(self.edges, b)
    elseif place == 'down' then
        local b = {}
        --  static ground body
        table.insert(b, love.physics.newBody(self.world, 0, Window.height, 'static'))

        -- edge shape Box2D provides, perfect for ground
        table.insert(b, love.physics.newEdgeShape(0, 0, Window.width, 0))

        -- affix edge shape to our body
        table.insert(b, love.physics.newFixture(b[1], b[2]))

        table.insert(self.edges, b)
    elseif place == 'upper' then
        local b = {}
        --  static ground body
        table.insert(b, love.physics.newBody(self.world, 0, 0, 'static'))

        -- edge shape Box2D provides, perfect for ground
        table.insert(b, love.physics.newEdgeShape(0, 0, Window.width, 0))

        -- affix edge shape to our body
        table.insert(b, love.physics.newFixture(b[1], b[2]))

        table.insert(self.edges, b)
    end
end

function BaseLevel:CreateBox(x, y, size, rotation)
    local Box = {}
    table.insert(Box, love.physics.newBody(self.world, x, y, 'static'))
    table.insert(Box, love.physics.newRectangleShape(size or 100, size or 100))
    table.insert(Box, love.physics.newFixture(Box[1], Box[2]))
    if rotation then
        Box[1]:setAngle(rotation * (3.14159265 / 180))
    end
    table.insert(self.boxes, Box)
end

function BaseLevel:CreateRectangle(x, y, width, height, rotation, xOffset, yOffset)
    local Box = {}
    table.insert(Box, love.physics.newBody(self.world, x, y, 'static'))
    table.insert(Box, love.physics.newRectangleShape(width or 100, height or 100))
    table.insert(Box, love.physics.newFixture(Box[1], Box[2]))
    Box[1]:setPosition(x + (xOffset or 0), y + (yOffset or 0))
    if rotation then
        Box[1]:setAngle(rotation * (3.14159265 / 180))
    end
    table.insert(self.boxes, Box)
end

function BaseLevel:CreateCustomRectangle(x, y, width, height, rotation, xOffset, yOffset)
    local Box = {}
    table.insert(Box, love.physics.newBody(self.world, x, y, 'static'))
    table.insert(Box, love.physics.newRectangleShape(width or 100, height or 100))
    table.insert(Box, love.physics.newFixture(Box[1], Box[2]))
    Box[1]:setPosition(x + (xOffset or 0), y + (yOffset or 0))
    if rotation then
        Box[1]:setAngle(rotation * (3.14159265 / 180))
    end
    table.insert(self.cBoxes, Box)
end

function BaseLevel:CreateDownOpening(x, size)
    self:CreateRectangle(0, Window.height - 5, Window.width, 5, 0, -Window.width / 2 + x - size / 2, 0)
    self:CreateRectangle(Window.width, Window.height - 5, Window.width, 5, 0, -Window.width / 2 + x + size / 2, 0)
end
