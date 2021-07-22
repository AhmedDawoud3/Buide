local Timer = require "lib.knife.timer"
local Easing = require 'lib.easing'
SubmitScore = Class {
    __includes = BaseState
}
local xx, yy, ww, hh, rr, xO, yO = 0, 0, 0, 0, 0, 0, 0
local rr, gg, bb = 0, 0, 0
local submitted = false
local textInput = {
    text = "",
    x = 577,
    y = 145,
    w = 300,
    h = 61
}

local Opacities = {
    cursor = 0,
    screenFill = 0,
    outroRect = 0
}
local submitted = false

function SubmitScore:enter(params)
    self.level = params.level
    self.score = params.score
    self.suit = Suit.new()
    Timer.every(1, function()
        Timer.tween(0.5, {
            [Opacities] = {
                cursor = 1
            }
        }):ease(Easing.inOutQuad):finish(function()
            Timer.tween(0.5, {
                [Opacities] = {
                    cursor = 0
                }
            }):ease(Easing.inOutQuad)
        end)
    end)
end

function SubmitScore:update(dt)
    if self.suit:Button('Cancel', {
        font = fonts['Semibold40']
    }, 50, 600, 240, 60).hit or love.keyboard.wasPressed('escape') and not submitted then
        gStateMachine:change('levelSelect')
    end
    if not submitted and textInput.text ~= "" and textInput.text ~= " " and self.suit:Button('Upload', {
        font = fonts['Semibold40']
    }, Window.width - 240 - 50, 600, 240, 60).hit and not submitted then
        submitted = UploadNewHighScore(textInput.text, self.level, self.score)
        Timer.tween(2, {
            [Opacities] = {
                screenFill = 1
            }
        }):ease(Easing.outCubic):finish(function()
            Timer.tween(3, {}):ease(Easing.outCubic):finish(function()
                Timer.tween(1, {
                    [Opacities] = {
                        outroRect = 1
                    }
                }):ease(Easing.outCubic):finish(function()
                    gStateMachine:change('levelSelect')
                end)
            end)
        end)
    end
    Timer.update(dt)
    self:UpdateText()
end

function SubmitScore:render()
    love.graphics.clear(0.1, 0.12, 0.15)

    love.graphics.setColor(1, 1, 0.9, 1)
    love.graphics.setFont(fonts['ExtraBold60'])
    love.graphics.printf("Submit A New Highscore", 0, 40, Window.width, 'center')

    love.graphics.setFont(fonts['Medium40'])
    love.graphics.print("Name :", 410, 150)
    love.graphics.setFont(fonts['Medium40'])
    love.graphics.print("Name :", 410, 150)
    love.graphics.setFont(fonts['Bold16'])
    love.graphics.print('Maximum 9 Letters, No Numbers', 888, 166)
    --[[
        Text Input
    ]]
    rgb(137, 137, 137)
    love.graphics.rectangle("fill", textInput.x, textInput.y, textInput.w, textInput.h, 20, 20)
    rgb(70, 70, 70)
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", textInput.x, textInput.y, textInput.w, textInput.h, 20, 20)
    love.graphics.setLineWidth(2)
    rgb(20, 20, 20)
    love.graphics.setFont(fonts['Semibold40'])
    love.graphics.print(textInput.text, textInput.x + 5, textInput.y + 5)
    rgb(255, 255, 255)
    love.graphics.print(textInput.text, textInput.x + 4, textInput.y + 6)

    --[[
        Blanking cursor
    ]]
    rgb(255, 255, 255, #textInput.text == 9 and 0 or Opacities.cursor)
    textWidth = fonts['Semibold40']:getWidth(textInput.text)
    love.graphics.rectangle('fill', textInput.x + 4 + textWidth + 6.045, textInput.y + 6 + 1.866, 7.09, 44.03)
    rgb(255, 255, 255)

    --[[
        Score
    ]]
    love.graphics.setFont(fonts['Medium40'])
    love.graphics.print({{1, 1, 1}, "Score : ", {255 / 255, 109 / 255, 90 / 255}, TimeGSUB(tostring(self.score), 4)},
        410, 250)

    --[[
        Date
    ]]
    love.graphics.setFont(fonts['Medium40'])
    love.graphics.print({{1, 1, 1}, "Time : ", {255 / 255, 109 / 255, 90 / 255}, os.date("%c", os.time())}, 410, 350)

    --[[
        Suit (UI)
    ]]
    self.suit:draw()

    --[[
        Rectangle to fill the screen when leaving
    ]]
    love.graphics.setColor(0.1, 0.12, 0.15, Opacities.screenFill)
    love.graphics.rectangle("fill", 0, 0, Window.width, Window.height)
    love.graphics.setColor(1, 1, 0.9, Opacities.screenFill)
    love.graphics.setFont(fonts['ExtraBold60'])
    love.graphics.printf(submitted and "Score Successfully Submited" or "Score Submission Failed", 0,
        Window.height / 2 - fonts['ExtraBold60']:getHeight("Submit A New Highscore") / 2, Window.width, 'center')
    love.graphics.setColor(0.1, 0.12, 0.15, Opacities.outroRect)
    love.graphics.rectangle("fill", 0, 0, Window.width, Window.height)

    rgb(255, 255, 255)
    xx = imgui.SliderFloat("X", xx, 0, 1280);
    yy = imgui.SliderFloat("Y", yy, 0, 720);
    xO = imgui.SliderFloat("X Offset", xO, -10, 10);
    yO = imgui.SliderFloat("Y Offset", yO, -10, 10);
    ww = imgui.SliderFloat("Width", ww, 0.0, 500);
    hh = imgui.SliderFloat("Height", hh, 0.0, 500);
    rr = imgui.SliderFloat("Round Edge", rr, 0, 100);
    rr = imgui.SliderFloat("R", rr, 0, 255);
    gg = imgui.SliderFloat("G", gg, 0, 255);
    bb = imgui.SliderFloat("B", bb, 0, 255);
    imgui.Render();
end

function SubmitScore:UpdateText()
    if love.keyboard.wasPressed('backspace') then
        if love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl') then
            textInput.text = ''
        else
            textInput.text = string.sub(textInput.text, 1, #textInput.text - 1)
        end
    end
    if love.keyboard.wasPressed('space') then
        textInput.text = textInput.text .. ' '
    end
    for _, letter in ipairs(ALPHABET) do
        if love.keyboard.wasPressed(letter) then
            if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
                textInput.text = textInput.text .. string.upper(letter)
            else
                textInput.text = textInput.text .. letter
            end
        end
    end
    textInput.text = string.sub(textInput.text, 1, 9)
end
