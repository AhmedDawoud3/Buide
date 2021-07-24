OptionsState = Class {
    __includes = BaseState
}

local xx, xo, yy, yo, ww, hh, rr = 0, 0, 0, 0, 0, 0, 0

local noTrailImage = love.graphics.newImage('assets/images/noTrail.png')
local TrailImage = love.graphics.newImage('assets/images/trail.png')
local musicSlider
local SFXValue
function OptionsState:enter(params)
    self.suit = Suit.new()
    settingsOption = {
        BallTrail = {
            checked = options.BallTrail
        },
        FullScreen = {
            checked = options.FullScreen
        },
        music = {
            checked = options.music
        },
        SFX = {
            checked = options.SFX
        }
    }
    musicSlider = {
        value = options.musicValue,
        min = 0,
        max = 1,
        step = 0.1
    }
    SFXValue = {
        value = options.SFXValue,
        min = 0,
        max = 1,
        step = 0.1
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

    if self.suit:Button('Report an Issue', {font = fonts['Semibold40']}, Window.width - 350 - 50, 600, 350, 60).hit then
        love.system.openURL("mailto:adawoud1000@hotmail.com")
    end
    
    --[[
        Full Screen
    ]]
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

    --[[
        Music
    ]]
    if self.suit:Checkbox(settingsOption.music, 1038, 230, 50, 39).hit then
        options.music = settingsOption.music.checked
        if options.music then
            sounds['main']:setVolume(musicSlider.value)
            sounds['play']:setVolume(musicSlider.value)
        else
            sounds['main']:setVolume(0)
            sounds['play']:setVolume(0)
        end
    end

    --[[
        SFX
    ]]
    if self.suit:Checkbox(settingsOption.SFX, 1038, 330, 50, 39).hit then
        options.SFX = settingsOption.SFX.checked
        if options.SFX then
            sounds['clack']:setVolume(musicSlider.value)
        else
            sounds['clack']:setVolume(0)
        end
    end

    --[[
        Music Slider
    ]]
    if self.suit:Slider(musicSlider, 55, 454, 185, 50).changed then
        options.musicValue = musicSlider.value
        if options.music then
            sounds['main']:setVolume(musicSlider.value)
            sounds['play']:setVolume(musicSlider.value)
        end
    end

    --[[
        VFX Slider
    ]]
    if self.suit:Slider(SFXValue, 315, 454, 185, 50).changed then
        options.SFXValue = SFXValue.value
        if options.SFX then
            sounds['clack']:setVolume(SFXValue.value)
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

    --[[
        Music
    ]]
    love.graphics.rectangle('line', 817, 213, 287, 71, 13, 13)
    -- The Word "Full Screen" 
    love.graphics.setFont(fonts['Bold32'])
    love.graphics.print("Music", 833, 230)

    --[[
        Music Toggle
    ]]
    love.graphics.rectangle('line', 817, 313, 287, 71, 13, 13)
    -- The Word "Full Screen" 
    love.graphics.setFont(fonts['Bold32'])
    love.graphics.print("SFX", 833, 330)

    --[[
        Music Slider
    ]]
    love.graphics.rectangle('line', 38, 402, 221, 108, 13, 13)
    love.graphics.setFont(fonts['Bold32'])
    love.graphics.print("Music: " .. math.floor(musicSlider.value * 100) .. "%", 38 + 11, 402 + 18)

    --[[
        SFX Slider
    ]]
    love.graphics.rectangle('line',298, 402, 221, 108, 13, 13)
    love.graphics.setFont(fonts['Bold32'])
    love.graphics.print("SFX: " .. math.floor(SFXValue.value * 100) .. "%", 298 + 11, 402 + 18)

    -- IMGUI
    love.graphics.setColor(1, 1, 1, 1)
    xx = imgui.SliderFloat("X", xx, 38, 700);
    -- xo = imgui.SliderFloat("X O", xo, 0.0, 50);
    yy = imgui.SliderFloat("Y", yy, 420, 480);
    -- yo = imgui.SliderFloat("Y O", yo, 0, 500);
    ww = imgui.SliderFloat("Width", ww, 150, 250);
    hh = imgui.SliderFloat("Height", hh, 0.0, 50);
    -- rr = imgui.SliderFloat("Round Edge", rr, 0.0, 100);
    imgui.Render();
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
