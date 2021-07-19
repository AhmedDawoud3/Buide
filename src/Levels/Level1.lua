Level1 = Class {
    __includes = BaseLevel
}

function Level1:enter()
    --[[
        We're written "self." before the variable to make them local to the level so can't be used in other levels
    ]]

    -- Create a new world with "Y" component gravity of 15000
    self.world = love.physics.newWorld(0, 1500)

    -- Make a table to keep track of the player's {body, shape and fixture}
    self.player = {}
    -- Make the shape as a ball with a radius of "20"
    self.player.shape = love.physics.newCircleShape(20)
    -- Make the body and center it in the middle of the world "as an initial position" and make it dynamic.
    self.player.body = love.physics.newBody(self.world, Window.width / 2, Window.height / 2, 'dynamic')
    -- Make the fixture to link the body with the shape
    self.player.fixture = love.physics.newFixture(self.player.body, self.player.shape)

    -- Make its restitution so that it's 105% of its initial force when colliding with anything
    self.player.fixture:setRestitution(1.05)

    -- A table to keep track of the edges of the level
    self.edges = {}

    -- A table to keep track of the "Disigner-made" boxes
    self.boxes = {}

    -- A table to keep track of the "player-made" boxes (we'll call it custom boxes (cBoxes))
    self.cBoxes = {}

    -- A table to keep track of the "Disigner-made" circles
    self.Circles = {}

    -- A table to keep track of the "Disigner-made" polygons
    self.Polygons = {}

    -- Initialize the effects manager (Makes tha trail behind the ball)
    self.e = EffectManager()

    -- Initialize the mouse manager (to handle placing and removing "custom boxes")
    self.mouseHandler = MouseHandler()

    -- Initialize tha playing state as true to start the game immediately
    self.playing = true

    -- Make a timer and set it to 0
    self.timer = 0

    self.originalPlayerX, self.originalPlayerY = Window.width - 100, 100

    self.player.body:setPosition(self.originalPlayerX, self.originalPlayerY)

    highScored = false

    self:CreateFullEdge('left')
    self:CreateFullEdge('upper')
    self:CreateFullEdge('right')

    -- self:CreateRectangle(Window.width - 90, Window.height - 100, 120, 10, -35)
    -- self:CreateRectangle(800, 400, 260, 10, 12.25)
    -- self:CreateRectangle(10, 580, 280, 10, 45)
    self:CreateDownOpening(Window.width / 2, 100)

end

function Level1:update(dt)
    self.player.x, self.player.y = self.player.body:getPosition()
    if self.playing then
        if self.player.y > Window.height then
            self.playing = false
            if self.timer < LoadScore(1) then
                highScored = true
                SaveScore({
                    level = 1,
                    score = self.timer
                })
            end
        end
        self.timer = self.timer + fixedDT
    end
    self.world:update(fixedDT)
    if options.BallTrail then
        self.e:update(fixedDT, self)
    end
    self.mouseHandler:update(fixedDT, self)

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

function Level1:render()
    love.graphics.clear(0.16, 0.19, 0.2, 1)
    if options.BallTrail then
        self.e:draw()
    end
    love.graphics.setColor(options.BallColor[1], options.BallColor[2], options.BallColor[3], 1)
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
    self.mouseHandler:render(self)

    love.graphics.setFont(fonts['Bold16'])
    -- Print cuurent time
    if self.playing then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('Time: ' .. TimeGSUB(self.timer, 2), 0, 30, Window.width, 'center')
    else
        -- Draw a rectangle to cover the whole screen with 0.3 alpha
        love.graphics.setColor(0, 0, 0, 0.3)
        love.graphics.rectangle('fill', 0, 0, Window.width, Window.height)
        love.graphics.setFont(fonts['Bold32'])
        love.graphics.setColor(1, 102 / 255, 90 / 255)
        love.graphics.printf('Time: ' .. TimeGSUB(self.timer, 4), 0, Window.height / 2 - 30, Window.width, 'center')
        if highScored then
            love.graphics.setFont(fonts['ExtraBold60'])
            rgb(0, 132, 169)
            love.graphics.printf('A New Highscore !', 0, Window.height / 2 - 120, Window.width, 'center')
        end
    end

end

function Level1:exit()
    self.world:destroy()
end

function Level1:Restart()
    self.player.fixture:destroy()
    self.player.body = love.physics.newBody(self.world, self.originalPlayerX, self.originalPlayery, 'dynamic')
    self.player.fixture = love.physics.newFixture(self.player.body, self.player.shape)
    self.player.fixture:setRestitution(1.1)
    self.timer = 0
    self.playing = true
    highScored = false
end

function Level1:ClearAllCustomBoxes()
    for i, v in ipairs(self.cBoxes) do
        v[3]:destroy()
    end
    self.cBoxes = {}
end

function Level1:CleareLastCustomBox()
    if #self.cBoxes > 0 then
        self.cBoxes[#self.cBoxes][3]:destroy()
        self.cBoxes[#self.cBoxes] = nil
    end
end

function Level1:CreateEdge(x, y, width, height)
    local b = {}
    --  static ground body
    table.insert(b, love.physics.newBody(self.world, x, y, 'static'))

    -- edge shape Box2D provides, perfect for ground
    table.insert(b, love.physics.newEdgeShape(x, y, width, height))

    -- affix edge shape to our body
    table.insert(b, love.physics.newFixture(b[1], b[2]))
    table.insert(self.edges, b)
end

function Level1:CreateFullEdge(place)
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

function Level1:CreateBox(x, y, size, rotation)
    local Box = {}
    table.insert(Box, love.physics.newBody(self.world, x, y, 'static'))
    table.insert(Box, love.physics.newRectangleShape(size or 100, size or 100))
    table.insert(Box, love.physics.newFixture(Box[1], Box[2]))
    if rotation then
        Box[1]:setAngle(rotation * (3.14159265 / 180))
    end
    table.insert(self.boxes, Box)
end

function Level1:CreateRectangle(x, y, width, height, rotation, xOffset, yOffset)
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

function Level1:CreateCustomRectangle(x, y, width, height, rotation, xOffset, yOffset)
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

function Level1:CreateDownOpening(x, size)
    self:CreateRectangle(0, Window.height - 5, Window.width, 5, 0, -Window.width / 2 + x - size / 2, 0)
    self:CreateRectangle(Window.width, Window.height - 5, Window.width, 5, 0, -Window.width / 2 + x + size / 2, 0)
end
