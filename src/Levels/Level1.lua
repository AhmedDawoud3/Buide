Level2 = Class {
    __includes = BaseLevel
}

-- Local value for [IMGUI] debugging
local xx, yy, ww, hh, rr, xO, yO = 0, 0, 0, 0, 0, 0, 0

--[[
    We initialize what's in Level 1 via this function that is called once we enter tha level
]]
function Level2:enter()
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

    --[[
        Level Disign
    ]]

    -- Desired player x and y position
    self.originalPlayerX, self.originalPlayerY = 1138, 82

    -- Set the player position to Desired position
    self.player.body:setPosition(self.originalPlayerX, self.originalPlayerY)

    self:CreateRectangle(667, 0, 488, 15)

    self:CreateRectangle(901, 223, 186, 107, 12)

    self:CreateCircle(360, 150, 72)

    self:CreatePoly({888, 370, 930, 330, 995, 388, 892, 462})

    self:CreateRectangle(1170, 32, 217, 11)

    self:CreatePoly({1160, 161, 1261, 40, 1280, 40, 1280, 157})

    self:CreatePoly({1160, 161, 1261, 40, 1280, 40, 1280, 161})

    self:CreatePoly({1160, 161, 1280, 161, 1280, 347})

    -- Create The Complex Shape
    self:CreatePoly({1199.5, 601, 1218.5, 648, 1195, 647.5, 1176.5, 627})
    self:CreatePoly({1218.5, 648, 1278, 690.5, 1211, 690.5})
    self:CreatePoly({1169.5, 505, 1230.5, 444, 1205.5, 576, 1172, 564.5})
    self:CreatePoly({1185.5, 383, 1233, 376.5, 1187, 396.5})
    self:CreatePoly({1146.5, 334, 1146.5, 332, 1188, 292.5, 1279.5, 337, 1233, 376.5, 1185.5, 383})
    self:CreatePoly({1199.5, 601, 1205.5, 576, 1278, 690.5, 1218.5, 648})
    self:CreatePoly({1230.5, 444, 1278, 690.5, 1205.5, 576})
    self:CreatePoly({1194.5, 227, 1188, 292.5, 1190.5, 223, 1194.5, 226})
    self:CreatePoly({1279.5, 337, 1188, 292.5, 1194.5, 227})
    self:CreatePoly({1234.5, 377, 1279.5, 337, 1279.5, 690, 1278, 690.5, 1230.5, 444})
    self:CreatePoly({1279.5, 337, 1234.5, 377, 1233, 376.5})
    self:CreatePoly({266.5, 535, 405.5, 504, 318, 559.5, 252, 551.5})

    -- Create The Complex Shape 
    self:CreatePoly({374, 388.5, 256, 480.5, 198, 463.5, 195.5, 461, 263, 395.5})
    self:CreatePoly({405.5, 504, 266.5, 535, 265.5, 534, 294.5, 480, 407, 471.5})
    self:CreatePoly({294.5, 480, 259, 482.5, 374, 388.5, 375, 388.5, 381, 389.5})
    self:CreatePoly({179, 499.5, 259, 482.5, 294.5, 480, 265.5, 534, 177, 501.5})
    self:CreatePoly({374, 388.5, 259, 482.5, 256, 480.5})

    -- Create The Complex Shape 
    self:CreatePoly({222.5, 302, 218.5, 295, 272, 245.5, 275, 244.5, 276, 244.5, 345.5, 280, 303, 317.5, 246, 330.5})
    self:CreatePoly({343.5, 275, 345.5, 280, 276, 244.5, 326, 251.5})

    -- Create The Complex Shape 
    self:CreatePoly({71.5, 233, 100.5, 193, 93.5, 251, 90, 252.5, 72, 253.5})
    self:CreatePoly({72.5, 369, 37, 346.5, 77, 315.5, 94.5, 341})
    self:CreatePoly({47.5, 157, 21.5, 105, 47, 105.5})
    self:CreatePoly({21.5, 105, 2, -0.5, 26, -0.5})
    self:CreatePoly({2, -0.5, 35.5, 346, 0, 556.5, -0.5, 555, -0.5, 0, 1, -0.5})
    self:CreatePoly({39, 259.5, 50.5, 192, 100, 191.5, 100.5, 193, 71.5, 233})
    self:CreatePoly({100.5, 379, 62.5, 458, 72.5, 369, 98, 376.5})
    self:CreatePoly({62.5, 458, 59.5, 467, 0, 556.5, 35.5, 346, 37, 346.5, 72.5, 369})
    self:CreatePoly({72.5, 164, 50.5, 192, 47.5, 157, 72, 162.5})
    self:CreatePoly({50.5, 192, 39, 259.5, 21.5, 105, 47.5, 157})
    self:CreatePoly({35.5, 346, 2, -0.5, 21.5, 105, 39, 259.5})
    self:CreatePoly({104, 557.5, 0, 556.5, 59.5, 467, 105.5, 556})

    self:CreateCircle(9, 787, 250)

    -- Create The Complex Shape 
    self:CreatePoly({623, 441.5, 551.5, 357, 551.5, 355, 566, 349.5, 567, 349.5, 646.5, 426})
    self:CreatePoly({566, 349.5, 551.5, 355, 564, 347.5})
    self:CreatePoly({565, 719.5, 564.5, 712, 633, 601.5, 679.5, 719})
    self:CreatePoly({564.5, 712, 565, 719.5, 563, 716.5})
    self:CreatePoly({633, 601.5, 625.5, 613, 625.5, 612})
    self:CreatePoly({565, 719.5, 565.5, 716, 633, 602.5, 679.5, 719})
    self:CreatePoly({564.5, 713, 611.5, 637, 565.5, 716, 563.5, 716})
    self:CreatePoly({633, 602.5, 611.5, 637, 611.5, 636, 629.5, 606})

    -- Create The Complex Shape 
    self:CreatePoly({623, 441.5, 551.5, 357, 551.5, 355, 566, 349.5, 567, 349.5, 646.5, 426})
    self:CreatePoly({566, 349.5, 551.5, 355, 564, 347.5})
    self:CreatePoly({565, 719.5, 564.5, 712, 633, 601.5, 679.5, 719})
    self:CreatePoly({564.5, 712, 565, 719.5, 563, 716.5})
    self:CreatePoly({633, 601.5, 625.5, 613, 625.5, 612})
    self:CreatePoly({565, 719.5, 565.5, 716, 633, 602.5, 679.5, 719})
    self:CreatePoly({564.5, 713, 611.5, 637, 565.5, 716, 563.5, 716})
    self:CreatePoly({633, 602.5, 611.5, 637, 611.5, 636, 629.5, 606})

    self:CreateDownOpening(388, 90)

end

function Level2:update(dt)
    -- keep track of the player's (X and Y) values
    self.player.x, self.player.y = self.player.body:getPosition()

    -- The winning state
    -- Set the winning state when the player's body passes the window height completely (the +20 refers to the player's radius')
    if self.player.y > Window.height + 20 then
        self.playing = false
    end

    -- The losing state
    -- When the ball goes out of the bound, Reset
    if self.player.y < -20 or self.player.x < -20 or self.player.x > 1300 then
        self:Restart()
    end

    -- If playing then increment the timer with delta time
    if self.playing then
        self.timer = self.timer + dt
    end

    --  we add "if dt < 0.04" to handle window moving as the window moves the screen doesn't update
    if dt < 0.04 and self.playing then
        self.world:update(dt)
        -- Only update the ball trail if the option is enabled (to save memory)
        if options.BallTrail then
            self.e:update(dt, self)
        end
        self.mouseHandler:update(dt, self)
    end

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

function Level2:render()
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
        love.graphics.printf('Time: ' .. string.sub(tostring(self.timer), 1, 4), 0, 30, Window.width, 'center')
    else
        -- Draw a rectangle to cover the whole screen with 0.3 alpha
        love.graphics.setColor(0, 0, 0, 0.3)
        love.graphics.rectangle('fill', 0, 0, Window.width, Window.height)
        love.graphics.setFont(fonts['Bold32'])
        love.graphics.setColor(1, 0.1, 0.1, 1)
        love.graphics.printf('Time: ' .. string.sub(tostring(self.timer), 1, 8), 0, Window.height / 2 - 30,
            Window.width, 'center')
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
function Level2:exit()
    -- Destroy the world when leaving the game
    self.world:destroy()
end

--[[
    a function to restart the game and reset the player's position
]]
function Level2:Restart()
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
end

--[[
    function to clear all custom created boxes
]]
function Level2:ClearAllCustomBoxes()
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
function Level2:CleareLastCustomBox()
    if #self.cBoxes > 0 then
        self.cBoxes[#self.cBoxes][3]:destroy()
        self.cBoxes[#self.cBoxes] = nil
    end
end

--[[
    function to create an edge
    {x and y are the center of the edge not its top left}
]]
function Level2:CreateEdge(x, y, width, height)
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
function Level2:CreateFullEdge(place)
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
function Level2:CreateBox(x, y, size, rotation)
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
function Level2:CreateRectangle(x, y, width, height, rotation, xOffset, yOffset)
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
function Level2:CreateCustomRectangle(x, y, width, height, rotation, xOffset, yOffset)
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
function Level2:CreateDownOpening(x, size)
    self:CreateRectangle(0, Window.height - 5, Window.width, 5, 0, -Window.width / 2 + x - size / 2, 0)
    self:CreateRectangle(Window.width, Window.height - 5, Window.width, 5, 0, -Window.width / 2 + x + size / 2, 0)
end

--[[
    function to create circle obstacles
]]
function Level2:CreateCircle(x, y, radius)
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
function Level2:CreatePoly(v)
    -- Create a temp table contaioning the body, shape and fixture
    local p = {}

    p.body = love.physics.newBody(self.world, 0, 0, 'static')
    p.shape = love.physics.newPolygonShape(v)
    p.fixture = love.physics.newFixture(p.body, p.shape)

    -- keep track of the vertices table
    p.vertices = v

    table.insert(self.Polygons, p)
end
