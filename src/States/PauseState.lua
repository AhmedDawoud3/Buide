PauseState = Class {
    __includes = BaseState
}

function PauseState:enter(params)
    -- We get the play state to know the time and to pass it back to itself
    self.playState = params.PlayState

    self.suit = Suit.new()

    -- Stop the main menu sound when coming from play state
    sounds['main']:stop()
end

function PauseState:update(dt)
    -- Main Menu Button
    if self.suit:Button('Main Menu', {
        font = fonts['Bold16']
    }, 20, 646, 110, 50).hit then
        gStateMachine:change('start')
        sounds['main']:play()
    end

    -- Continue Button
    if self.suit:Button('Continue', {
        font = fonts['Bold16']
    }, Window.width - 20 - 110, 646, 110, 50).hit then
        gStateMachine:change('play', {
            fromPause = true,
            playState = self.playState
        })
    end
end

function PauseState:render()
    -- We draw the playState with low opacity to show the current game behind
    self.playState:render()
    -- Draw rectangle with the same color as the background to make to seem to be transparent
    love.graphics.setColor(0.16, 0.19, 0.2, 0.9)
    love.graphics.rectangle('fill', 0, 0, Window.width, Window.height)

    love.graphics.setColor(1, 1, 0.9, 1)
    love.graphics.setFont(fonts['ExtraBold100'])
    love.graphics.printf("Game Paused", 0, 80, Window.width, 'center')

    love.graphics.setColor(1, 102 / 255, 90 / 255)
    love.graphics.setFont(fonts['Bold32'])
    love.graphics.printf("Current Time: " .. math.floor(math.floor(self.playState.LevelManager.current.timer)) ..
                             string.sub(tostring(self.playState.LevelManager.current.timer - math.floor(self.playState.LevelManager.current.timer)), 2, 5), 0, 220,
        Window.width, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    self.suit:draw()
end
