--[[
    Buide

    Author: Ahmed Dawoud
    adawoud1000@hotmail.com

    Credit for music:
    https://freesound.org/people/Erokia/sounds/183881/
]] --
require 'src.Dependencies'
require "imgui"

function love.load()

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- set the application title bar
    love.window.setTitle("Buide")

    options = LoadSaveFile()

    -- initialize our fonts
    fonts = {
        ['Regular'] = love.graphics.newFont('fonts/MontserratRegular.ttf'),
        ['Regular13'] = love.graphics.newFont('fonts/MontserratRegular.ttf', 13),
        ['Bold16'] = love.graphics.newFont('fonts/MontserratBold.ttf', 16),
        ['Bold32'] = love.graphics.newFont('fonts/MontserratBold.ttf', 32),
        ['Medium40'] = love.graphics.newFont('fonts/MontserratMedium.ttf', 40),
        ['Medium20'] = love.graphics.newFont('fonts/MontserratMedium.ttf', 20),
        ['Semibold40'] = love.graphics.newFont('fonts/MontserratSemibold.ttf', 40),
        ['ExtraBold60'] = love.graphics.newFont('fonts/MontserratExtrabold.ttf', 60),
        ['ExtraBold100'] = love.graphics.newFont('fonts/MontserratExtrabold.ttf', 100),
        ['ExtraBoldItalic100'] = love.graphics.newFont('fonts/MontserratExtraboldItalic.ttf', 100),
        ['ExtraBoldItalic60'] = love.graphics.newFont('fonts/MontserratExtraboldItalic.ttf', 60),
        ['symbol'] = love.graphics.newFont('fonts/symbola.ttf', 30)
    }
    love.graphics.setFont(fonts['Regular'])

    -- initialize our resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(Window.width, Window.height, Window.width, Window.height, {
        fullscreen = options.FullScreen,
        resizable = true
    })

    -- the state machine we'll be using to transition between various states
    -- in our game instead of clumping them together in our update and draw
    -- methods
    gStateMachine = StateMachine {
        ['start'] = function()
            return StartState()
        end,
        ['play'] = function()
            return PlayState()
        end,
        ['about'] = function()
            return AboutState()
        end,
        ['options'] = function()
            return OptionsState()
        end,
        ['levelSelect'] = function()
            return LevelSelect()
        end

    }
    gStateMachine:change('start')

    sounds = {
        ['main'] = love.audio.newSource('assets/sounds/main.wav', 'static')
    }

    -- Load The Levels thumbnail for level select screen
    levelsImages = {love.graphics.newImage('assets/images/Levels/1.png'),
                    love.graphics.newImage('assets/images/Levels/2.png')}

    -- a table we'll use to keep track of which keys have been pressed this
    -- frame, to get around the fact that Love's default callback won't let us
    -- test for input from within other functions
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

    -- play our music outside of all states and set it to looping
    sounds['main']:play()
    sounds['main']:setLooping(true)
end

function love.update(dt)
    -- we pass in dt to the state object we're currently using
    gStateMachine:update(dt)

    --[[
        IMGUI debugging
    ]]
    imgui.NewFrame()
end

function love.draw()
    -- Starting push to scale all the renders according to the window dimensions
    push:apply('start')
    gStateMachine:render()
    DisplayFPS()
    push:apply('end')

    -- reset keys pressed
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

-- HANDLING KEY PRESSING 
--[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
    imgui.KeyPressed(key)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

--[[
    A custom function that will let us test for individual keystrokes outside
    of the default `love.keypressed` callback, since we can't call that logic
    elsewhere by default.
]]

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
    imgui.MousePressed(key)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true
    imgui.MouseReleased(key)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end

function love.quit()
    imgui.ShutDown();
end

function love.textinput(t)
    imgui.TextInput(t)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.keyreleased(key)
    imgui.KeyReleased(key)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.mousemoved(x, y)
    imgui.MouseMoved(x, y)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.wheelmoved(x, y)
    imgui.WheelMoved(y)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function DisplayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(fonts['Regular13'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
end
