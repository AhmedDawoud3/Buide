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
    if self.suit:Button('Back', {
        font = fonts['Semibold40']
    }, 50, 600, 240, 60).hit or love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')
    end
    if self.suit:Button('Report an Issue', {
        font = fonts['Semibold40']
    }, Window.width - 350 - 50, 600, 350, 60).hit then
        love.system.openURL("mailto:adawoud1000@hotmail.com")
    end

    mouse = Vector(push:toGame(love.mouse.getPosition()))

    -- Check for twitter hitbox
    if mouse.x > 71 and mouse.x < 71 + 642 and mouse.y > 462 and mouse.y < 462 + 40 then
        love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
        if love.mouse.wasPressed(1) then
            love.system.openURL("http://twitter.com/AhmedDawoud314")
        end
        -- Check for github hitbox
    elseif mouse.x > 71 and mouse.x < 71 + 620 and mouse.y > 544 and mouse.y < 544 + 40 then
        love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
        if love.mouse.wasPressed(1) then
            love.system.openURL("https://github.com/AhmedDawoud3")
        end
    else
        love.mouse.setCursor()
    end
end

function AboutState:render()
    love.graphics.clear(0.1, 0.12, 0.15)
    love.graphics.setFont(fonts['ExtraBoldItalic60'])
    love.graphics.print("About", 50, 25)
    love.graphics.setFont(fonts['Bold32'])
    love.graphics.printf(aboutText, 50, 150, Window.width - 100, 'left')
    love.graphics.print({{1, 1, 1}, "Find Me at\n\n", {0, 0.376, 1},
                         "   http://twitter.com/AhmedDawoud314\n\n   https://github.com/AhmedDawoud3"}, 46, 386)
    love.graphics.setColor(0, 0.376, 1, 1)
    love.graphics.line(71, 462 + 40, 71 + 642, 462 + 40)

    love.graphics.line(71, 544 + 40, 71 + 620, 544 + 40)
    self.suit:draw()
end
