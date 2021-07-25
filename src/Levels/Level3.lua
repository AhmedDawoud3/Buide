Level3 = Class {
    __includes = BaseLevel
}

-- Local value for [IMGUI] debugging
local xx, yy, ww, hh, rr, xO, yO = 0, 0, 0, 0, 0, 0, 0

--[[
    We initialize what's in Level 1 via this function that is called once we enter tha level
]]
function Level3:enter()
    --[[
        We're written "self." before the variable to make them local to the level so can't be used in other levels
    ]]
    self.index = 3

    -- Create a new world with "Y" component gravity of 15000
    self.world = love.physics.newWorld(0, 1500)
    self.world:setCallbacks(function()
        sounds["clack"]:stop()
        sounds["clack"]:play()
    end)

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

    highScored = false

    --[[
        Level Disign
    ]]

    -- Desired player x and y position
    self.originalPlayerX, self.originalPlayerY = 1138, 52

    -- Set the player position to Desired position
    self.player.body:setPosition(self.originalPlayerX, self.originalPlayerY)

    self:CreatePoly({173, 155, 173, 220, 1280, 220, 1280, 155})

    self:CreatePoly({373, 355, 373, 320, 0, 320, 0, 355})

    self:CreatePoly({600, 350, 600, 400, 0, 400, 0, 350})

    self:CreatePoly({1280, 480, 1280, 500, 300, 500, 300, 480})

    self:CreateCircle(200, 590, 50)

    self:CreateDownOpening(388, 90)

end

function Level3:update(dt)
    -- keep track of the player's (X and Y) values
    self.player.x, self.player.y = self.player.body:getPosition()

    -- If playing then increment the timer with the fixed delta time
    if self.playing then
        self.timer = self.timer + fixedDT
        -- The winning state
        -- Set the winning state when the player's body passes the window height completely (the +20 refers to the player's radius')
        if self.player.y > Window.height + 20 then
            self.playing = false
            if self.timer < LoadScore(self.index) then
                highScored = true
                SaveScore({
                    level = self.index,
                    score = self.timer
                })
            end
        end
        -- The losing state
        -- When the ball goes out of the bound, Reset
        if self.player.y < -20 or self.player.x < -20 or self.player.x > 1300 then
            self:Restart()
        end
    end

    self.world:update(fixedDT)
    -- Only update the ball trail if the option is enabled (to save memory)
    if options.BallTrail then
        self.e:update(fixedDT, self)
    end
    self.mouseHandler:update(fixedDT, self)

    --[[
        Handle keyboard
    ]]
    if love.keyboard.wasPressed('c') then
        self:ClearAllCustomBoxes()
    elseif love.keyboard.wasPressed('r') then
        self:Restart()
    elseif love.keyboard.wasPressed('f12') then
        -- Take screenshot with F12
        love.graphics.captureScreenshot(os.time() .. '.png')
    elseif love.keyboard.isDown('lctrl') and love.keyboard.wasPressed('z') then
        self:CleareLastCustomBox()
    end
end

function Level3:render()
    love.graphics.clear(0.16, 0.19, 0.2, 1)

    -- Only draw the ball trail if the option is enabled
    if options.BallTrail then
        self.e:draw()
    end

    -- Set the ball color to options.Ball
    love.graphics.setColor(options.BallColor[1], options.BallColor[2], options.BallColor[3], 1)

    -- only draw the ball if player.x and player.y are not nill
    if self.player.x and self.player.y then
        love.graphics.circle("fill", self.player.x, self.player.y, 20)
    end

    -- change color to draw all the obstacles
    love.graphics.setColor(0.51, 0.51, 0.51, 1)
    -- Draw all the edges
    for _, v in ipairs(self.edges) do
        love.graphics.line(v[1]:getWorldPoints(v[2]:getPoints()))
    end
    -- Draw all the "Disigner-made" boxes
    for _, v in ipairs(self.boxes) do
        love.graphics.polygon('fill', v[1]:getWorldPoints(v[2]:getPoints()))
    end
    -- Draw all the cBoxes
    for _, v in ipairs(self.cBoxes) do
        love.graphics.polygon('fill', v[1]:getWorldPoints(v[2]:getPoints()))
    end
    -- Draw all the "Disigner-made" circles
    for _, v in ipairs(self.Circles) do
        local Xx, Yy = v.body:getPosition()
        love.graphics.circle('fill', Xx, Yy, v.shape:getRadius())
    end
    -- Draw all the "Disigner-made" polygons
    for _, v in ipairs(self.Polygons) do
        love.graphics.polygon('fill', v.vertices)
    end

    -- Call the mouse handler render function
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
            love.graphics.setColor(options.BallColor[1], options.BallColor[2], options.BallColor[3], 1)
            love.graphics.printf('A New Highscore !', 0, Window.height / 2 - 120, Window.width, 'center')
        end
    end

    --[[
        IMGUI debugging
    ]]
    -- xx = imgui.SliderFloat("X", xx, -500, 200);
    -- yy = imgui.SliderFloat("Y", yy, 500, 1200);
    -- yO = imgui.SliderFloat("Y Offset", yO, 0, 200);
    -- ww = imgui.SliderFloat("Width", ww, 0.0, 500);
    -- hh = imgui.SliderFloat("Height", hh, 0.0, 500);
    -- rr = imgui.SliderFloat("Round Edge", rr, 0, 0.183);
    -- imgui.Render();

end

--[[
    This function will be called when we exit the level
]]
function Level3:exit()
    -- Destroy the world when leaving the game
    self.world:destroy()
end

--[[
    a function to restart the game and reset the player's position
]]
function Level3:Restart()
    -- Destroy the current player fixture
    self.player.fixture:destroy()

    -- Create new player body with original position
    self.player.body = love.physics.newBody(self.world, self.originalPlayerX, self.originalPlayerY, 'dynamic')

    -- Make the fixture 
    self.player.fixture = love.physics.newFixture(self.player.body, self.player.shape)

    -- Change the restitution so that it adds 5% force to its original force [So it never stops bouncing]
    self.player.fixture:setRestitution(1.05)

    -- Reset The timer
    self.timer = 0

    -- Set Playing to true
    self.playing = true

    highScored = false
end

--[[
    function to clear all custom created boxes
]]
function Level3:ClearAllCustomBoxes()
    -- Loop Thought all custom created boxes and destroy them
    for _, v in ipairs(self.cBoxes) do
        v[3]:destroy()
    end

    -- Reset the custom boxes table
    self.cBoxes = {}
end

--[[
    function to clear last custom created boxes
]]
function Level3:CleareLastCustomBox()
    if #self.cBoxes > 0 then
        self.cBoxes[#self.cBoxes][3]:destroy()
        self.cBoxes[#self.cBoxes] = nil
    end
end

--[[
    function to create an edge
    {x and y are the center of the edge not its top left}
]]
function Level3:CreateEdge(x, y, width, height)
    -- Create a temp table contaioning the body, shape and fixture

    local b = {}
    --  static ground body
    table.insert(b, love.physics.newBody(self.world, x, y, 'static'))

    -- edge shape Box2D provides, perfect for ground
    table.insert(b, love.physics.newEdgeShape(x, y, width, height))

    -- affix edge shape to our body
    table.insert(b, love.physics.newFixture(b[1], b[2]))
    table.insert(self.edges, b)
end

--[[
    function to create a full edge blocking all the side (left, right, up or down)
]]
function Level3:CreateFullEdge(place)
    if place == 'left' then
        -- Create a temp table contaioning the body, shape and fixture
        local b = {}

        --  static ground body
        table.insert(b, love.physics.newBody(self.world, 0, 0, 'static'))

        -- edge shape Box2D provides, perfect for ground
        table.insert(b, love.physics.newEdgeShape(0, 0, 0, Window.height))

        -- affix edge shape to our body
        table.insert(b, love.physics.newFixture(b[1], b[2]))

        table.insert(self.edges, b)
    elseif place == 'right' then
        -- Create a temp table contaioning the body, shape and fixture
        local b = {}

        --  static ground body
        table.insert(b, love.physics.newBody(self.world, Window.width, 0, 'static'))

        -- edge shape Box2D provides, perfect for ground
        table.insert(b, love.physics.newEdgeShape(0, 0, 0, Window.height))

        -- affix edge shape to our body
        table.insert(b, love.physics.newFixture(b[1], b[2]))

        table.insert(self.edges, b)
    elseif place == 'down' then
        -- Create a temp table contaioning the body, shape and fixture
        local b = {}

        --  static ground body
        table.insert(b, love.physics.newBody(self.world, 0, Window.height, 'static'))

        -- edge shape Box2D provides, perfect for ground
        table.insert(b, love.physics.newEdgeShape(0, 0, Window.width, 0))

        -- affix edge shape to our body
        table.insert(b, love.physics.newFixture(b[1], b[2]))

        table.insert(self.edges, b)
    elseif place == 'upper' then
        -- Create a temp table contaioning the body, shape and fixture
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

--[[
    function to create a box
    {x and y are the center of the edge not its top left}
    rotation value is in degrees
]]
function Level3:CreateBox(x, y, size, rotation)
    -- Create a temp table contaioning the body, shape and fixture
    local Box = {}

    table.insert(Box, love.physics.newBody(self.world, x, y, 'static'))

    -- Create the shape so that it has side length of parameter "size" or 100 by default
    table.insert(Box, love.physics.newRectangleShape(size or 100, size or 100))
    table.insert(Box, love.physics.newFixture(Box[1], Box[2]))

    -- If given a rotation value then applies it
    if rotation then
        Box[1]:setAngle(rotation * (3.14159265 / 180))
    end
    table.insert(self.boxes, Box)
end

--[[
    function to create a rectangle
    {x and y are the center of the edge not its top left}
    rotation value is in degrees
]]
function Level3:CreateRectangle(x, y, width, height, rotation, xOffset, yOffset)
    -- Create a temp table contaioning the body, shape and fixture
    local Box = {}

    table.insert(Box, love.physics.newBody(self.world, x, y, 'static'))

    -- Create the shape so that it has width and height length of parameters "width" and "height" or 100 by default
    table.insert(Box, love.physics.newRectangleShape(width or 100, height or 100))
    table.insert(Box, love.physics.newFixture(Box[1], Box[2]))

    -- If given offset value for x and y then applies it
    Box[1]:setPosition(x + (xOffset or 0), y + (yOffset or 0))

    -- If given a rotation value then applies it
    if rotation then
        Box[1]:setAngle(rotation * (3.14159265 / 180))
    end
    table.insert(self.boxes, Box)
end

--[[
    function to create a Rrectangle made by player
    {x and y are the center of the edge not its top left}
    rotation value is in degrees
]]
function Level3:CreateCustomRectangle(x, y, width, height, rotation, xOffset, yOffset)
    -- Create a temp table contaioning the body, shape and fixture
    local Box = {}

    table.insert(Box, love.physics.newBody(self.world, x, y, 'static'))
    table.insert(Box, love.physics.newRectangleShape(width, height))
    table.insert(Box, love.physics.newFixture(Box[1], Box[2]))

    -- If given offset value for x and y then applies it
    Box[1]:setPosition(x + (xOffset or 0), y + (yOffset or 0))

    -- If given a rotation value then applies it
    if rotation then
        Box[1]:setAngle(rotation * (3.14159265 / 180))
    end
    table.insert(self.cBoxes, Box)
end

--[[
    function to create a two "down" edges and leave "size" piexels between them
]]
function Level3:CreateDownOpening(x, size)
    self:CreateRectangle(0, Window.height - 5, Window.width, 5, 0, -Window.width / 2 + x - size / 2, 0)
    self:CreateRectangle(Window.width, Window.height - 5, Window.width, 5, 0, -Window.width / 2 + x + size / 2, 0)
end

--[[
    function to create circle obstacles
]]
function Level3:CreateCircle(x, y, radius)
    -- Create a temp table contaioning the body, shape and fixture
    local c = {}

    c.body = love.physics.newBody(self.world, x, y, 'static')
    -- Make the radius 50 if not given `and still notify the designer`
    if not radius then
        -- Get Current file name
        local str = debug.getinfo(2, "S").source:sub(2)
        fileName = str:match("^.*/(.*).lua$") or str

        -- Print the error message in the consle
        print("No radius given in CreateCircle at line " .. debug.getinfo(1).currentline .. " in " .. fileName ..
                  " radius is 50 by default")
        c.shape = love.physics.newCircleShape(50)
    else
        c.shape = love.physics.newCircleShape(radius)
    end
    c.fixture = love.physics.newFixture(c.body, c.shape)

    table.insert(self.Circles, c)
end

--[[
    function to create a polygon with parameter "v" for vertices 
]]
function Level3:CreatePoly(v)
    -- Create a temp table contaioning the body, shape and fixture
    local p = {}

    p.body = love.physics.newBody(self.world, 0, 0, 'static')
    p.shape = love.physics.newPolygonShape(v)
    p.fixture = love.physics.newFixture(p.body, p.shape)

    -- keep track of the vertices table
    p.vertices = v

    table.insert(self.Polygons, p)
end
