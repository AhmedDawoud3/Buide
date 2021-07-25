-- Represents the state of the game in which we are actively playing;
-- player should control the bun, with his mouse cursor
PlayState = Class {
    __includes = BaseState
}

--[[
    We initialize what's in our PlayState via function that is called when we enter play state
]]
function PlayState:enter(params)
    -- Stop the main menu sound when entering play state
    sounds['main']:stop()

    sounds['play']:play()

    -- Check if came from pause state then take its parameters from it
    if params.fromPause then
        self.LevelManager = params.playState.LevelManager
        self.suit = params.playState.suit
    else
        -- Link LevelManager with levels
        self.LevelManager = LevelManager {
            ['Level1'] = function()
                return Level1()
            end,
            ['Level2'] = function()
                return Level2()
            end,
            ['Level3'] = function()
                return Level3()
            end
        }

        -- Change the current level to the level given in the function parameters
        self.LevelManager:change(params.level)

        -- Create an instance of suit (For GUI)
        self.suit = Suit.new()
    end
end

function PlayState:update(dt)
    -- Call the update function of the current level
    self.LevelManager:update(dt)

    -- Chech if not playing to display the restart symbol
    if self.LevelManager.current ~= self.LevelManager.empty then
        if self.LevelManager.current.playing then
            if self.suit:Button('↺ ', {
                font = fonts['symbol']
            }, 72, 9.5, 43, 43).hit then
                -- If clicked then call the reset function of the current level
                self.LevelManager.current:Restart()
            end
            if self.suit:Button('II', {
                font = fonts['Bold32']
            }, 130, 9.5, 43, 43).hit then
                gStateMachine:change('PauseState', {
                    PlayState = self
                })
            end

        else
            if self.suit:Button('↺ ', {
                font = fonts['symbol']
            }, Window.width / 2 - 35, Window.height / 2 - 35 + 70, 70, 70).hit then
                -- If clicked then call the reset function of the current level
                self.LevelManager.current:Restart()
            end
            if self.suit:Button('Back ', {
                font = fonts['Bold32']
            }, 20, 646, 90, 50).hit then
                gStateMachine:change('levelSelect')
                -- Plays the main menu sound when leaving play state
                sounds['play']:stop()
                sounds['main']:play()
            end
            if highScored then
                if self.suit:Button('Upload Score', {
                    font = fonts['Bold32']
                }, Window.width / 2 - 126, 553, 253, 80).hit then
                    sounds['play']:stop()
                    sounds['main']:play()
                    gStateMachine:change('SubmitScore', {
                        level = self.LevelManager.current.index,
                        score = self.LevelManager.current.timer
                    })
                end
            end
        end
    end
end

function PlayState:render()
    -- Call the render function of the current level
    self.LevelManager:render()

    -- Draw SUIT (GUI stuff)
    self.suit:draw()

end

