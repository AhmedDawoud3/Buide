AboutState = Class {
    __includes = BaseState
}

local aboutText = [[Thanks for downloading my game!

Auther: Ahmed Dawoud

The source code is at https://github.com/AhmedDawoud3/Buide]]

function AboutState:enter()
    self.suit = Suit.new()
end

function AboutState:update(dt)
    if self.suit:Button('Back', {font = fonts['Semibold40']}, 50, 600, 240, 60).hit or love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')
    end
end

function AboutState:render()
    love.graphics.clear(0.1, 0.12, 0.15)
    love.graphics.setFont(fonts['ExtraBoldItalic60'])
    love.graphics.print("About", 50, 25)
    love.graphics.setFont(fonts['Bold32'])
    love.graphics.printf(aboutText, 50, 150, Window.width - 100, 'left')
    self.suit:draw()
end
