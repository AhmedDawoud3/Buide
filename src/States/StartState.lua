StartState = Class {
    __includes = BaseState
}

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
end

function StartState:update(dt)
    if self.suit:Button('Play', {
        font = fonts['Semibold40']
    }, Window.width / 2 - 120, Window.height / 2 + 30, 240, 60).hit then
        gStateMachine:change('play')
    end
    if self.suit:Button('Exit', {
        font = fonts['Semibold40']
    }, Window.width / 2 - 120, Window.height / 2 + 150, 240, 60).hit then
        love.event.quit()
    end
    if self.suit:Button('Options', {
        font = fonts['Semibold40']
    }, 20, Window.height - 100, 240, 60).hit then
        print("Options (TODO)")
    end
    if self.suit:Button('About', {
        font = fonts['Semibold40']
    }, Window.width - 240 - 20, Window.height - 100, 240, 60).hit then
        print("About (TODO)")
    end
end

function StartState:render()
    love.graphics.clear(0.1, 0.12, 0.15)
    love.graphics.setFont(fonts['ExtraBold100'])
    love.graphics.printf("Buide", 0, 125, Window.width, 'center')
    self.suit:draw()

end
