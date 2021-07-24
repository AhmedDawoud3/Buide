local Timer = require "lib.knife.timer"
local Easing = require 'lib.easing'

StartState = Class {
    __includes = BaseState
}
local RectOpacity = {1}
function StartState:enter(params)
    self.suit = Suit.new()
    self.suit.theme.color = {
        normal = {
            bg = {0.25, 0.27, 0.3},
            fg = {0.72, 0.72, 0.77}
        },
        hovered = {
            bg = {0.2, 0.42, 0.75},
            fg = {1, 1, 1}
        },
        active = {
            bg = {0.75, 0.42, 0.2},
            fg = {1, 1, 1}
        }
    }
    Timer.tween(3, {
        [RectOpacity] = {0}
    }):ease(Easing.outCubic)
end

function StartState:update(dt)
    if self.suit:Button('Play', {
        font = fonts['Semibold40']
    }, Window.width / 2 - 120, Window.height / 2 + 30, 240, 60).hit and RectOpacity[1] <0.5 then
        gStateMachine:change('levelSelect')
    end

    if self.suit:Button('Exit', {
        font = fonts['Semibold40']
    }, Window.width / 2 - 120, Window.height / 2 + 150, 240, 60).hit and RectOpacity[1] <0.5 then
        love.event.quit()
    end

    if self.suit:Button('Options', {
        font = fonts['Semibold40']
    }, 50, 600, 240, 60).hit and RectOpacity[1] <0.5 then
        gStateMachine:change('options')
    end

    if self.suit:Button('About', {
        font = fonts['Semibold40']
    }, Window.width - 240 - 50, 600, 240, 60).hit and RectOpacity[1] <0.5 then
        gStateMachine:change('about')
    end
    Timer.update(dt)
end

function StartState:render()
    love.graphics.clear(0.1, 0.12, 0.15)
    love.graphics.setFont(fonts['ExtraBold100'])
    love.graphics.printf("Buide", 0, 125, Window.width, 'center')
    love.graphics.setFont(fonts['Semibold40'])
    love.graphics.print("Version " .. Game.Version, 35, 35)
    self.suit:draw()
    love.graphics.setColor(0.1, 0.12, 0.15, RectOpacity[1])
    love.graphics.rectangle('fill', 0, 0, Window.width, Window.height)

end
