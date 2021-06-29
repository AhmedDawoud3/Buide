OptionsState = Class {
    __includes = BaseState
}

local xx, yy, ww, hh, rr = 0, 0, 0, 0, 0

local noTrailImage = love.graphics.newImage('assets/images/noTrail.png')
local TrailImage = love.graphics.newImage('assets/images/trail.png')

function OptionsState:enter(params)
    self.suit = Suit.new()
    settingsOption = {
        BallTrail = {
            checked = options.BallTrail
        },
        FullScreen = {
            checked = options.FullScreen
        }
    }
end
function OptionsState:update(dt)
    if self.suit:Button('Back', {
        font = fonts['Semibold40']
    }, 50, 600, 240, 60).hit or love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')
    end

    if self.suit:Checkbox(settingsOption.BallTrail, 215, 130, 50, 39).hit then
        options.BallTrail = settingsOption.BallTrail.checked
    end

    if self.suit:Button('<', {
        font = fonts['Semibold40']
    }, Window.width / 2 - 69.42 - 25, 295, 50, 50).hit then
        PreviousBallColor()
    end

    if self.suit:Button('>', {
        font = fonts['Semibold40']
    }, Window.width / 2 + 69.42 - 25, 295, 50, 50).hit then
        NextBallColor()
    end

    if self.suit:Checkbox(settingsOption.FullScreen, 1038, 130, 50, 39).hit then
        options.FullScreen = settingsOption.FullScreen.checked
        if options.FullScreen then
            push:setupScreen(Window.width, Window.height, Window.width, Window.height, {
                fullscreen = true,
                resizable = false,
                vsync = true
            })
        else
            push:setupScreen(Window.width, Window.height, Window.width, Window.height, {
                fullscreen = false,
                resizable = true,
                vsync = true
            })
        end
    end

end

function OptionsState:render()
    love.graphics.clear(0.1, 0.12, 0.15)

    love.graphics.setFont(fonts['ExtraBold60'])
    love.graphics.printf("Options", 0, 20, Window.width, 'center')

    --[[
        Ball Trail
    ]]

    -- Big Rectangle
    love.graphics.rectangle('line', 38, 113, 221, 260, 30, 30)

    -- The Word "Ball Trail"
    love.graphics.setFont(fonts['Bold32'])
    love.graphics.print("Ball Trail", 50, 130)

    -- Description
    love.graphics.setFont(fonts['Regular13'])
    love.graphics.print("The Path That Follows The Ball\n(Better Visualization)", 50, 170)

    -- Photo Representation
    love.graphics.draw(options.BallTrail and TrailImage or noTrailImage, 75, 200)
    self.suit:draw()

    --[[
        Ball Color
    ]]
    -- Big Rectangle
    love.graphics.rectangle('line', Window.width / 2 - 266 / 2, 113, 266, 260, 30, 30)

    -- The Word "Ball Color" 
    love.graphics.setFont(fonts['Bold32'])
    love.graphics.printf("Ball Colour", 0, 130, Window.width, 'center')

    -- Description
    love.graphics.setColor(options.BallColor[1], options.BallColor[2], options.BallColor[3])
    love.graphics.setFont(fonts['Regular13'])
    love.graphics.printf("Change The Colour of the ball", 0, 170, Window.width, 'center')

    -- Colour Representation
    love.graphics.circle('fill', Window.width / 2, 245, 40)
    love.graphics.setColor(1, 1, 1, 1)

    --[[
        Full Screen
    ]]
    -- Big Rectangle
    love.graphics.rectangle('line', 817, 113, 287, 71, 13, 13)

    -- The Word "Full Screen" 
    love.graphics.setFont(fonts['Bold32'])
    love.graphics.print("Full Screen", 833, 130)

    -- Description
    love.graphics.setFont(fonts['Regular13'])
    love.graphics.printf("Change The Colour of the ball", 0, 170, Window.width, 'center')

    -- IMGUI
    love.graphics.setColor(1, 1, 1, 1)
    xx = imgui.SliderFloat("X", xx, 0.0, 1280);
    yy = imgui.SliderFloat("Y", yy, 0.0, 500);
    ww = imgui.SliderFloat("Width", ww, 0.0, 500);
    hh = imgui.SliderFloat("Height", hh, 0.0, 500);
    rr = imgui.SliderFloat("Round Edge", rr, 0.0, 100);
    -- imgui.Render();
end

function OptionsState:exit()
    SaveGame()
end

function NextBallColor()
    local cuurentColor = options.BallColor
    for i, v in ipairs(BallColors) do
        if cuurentColor[1] == v[1] and cuurentColor[2] == v[2] and cuurentColor[3] == v[3] then
            if i == #BallColors then
                options.BallColor = BallColors[1]
            else
                options.BallColor = BallColors[i + 1]
            end
            break
        end
    end
end

function PreviousBallColor()
    local cuurentColor = options.BallColor
    for i, v in ipairs(BallColors) do
        if cuurentColor[1] == v[1] and cuurentColor[2] == v[2] and cuurentColor[3] == v[3] then
            if i == 1 then
                options.BallColor = BallColors[#BallColors]
            else
                options.BallColor = BallColors[i - 1]
            end
            break
        end
    end
end
