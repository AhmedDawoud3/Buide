-- Represents the state of the game in which we are actively playing;
-- player should control the bun, with his mouse cursor
PlayState = Class {
    __includes = BaseState
}

function PlayState:enter(params)
    self.LevelManager = LevelManager {
        ['Level1'] = function()
            return Level1()
        end,
        ['Level2'] = function()
            return Level2()
        end
    }
    self.LevelManager:change(params.level)
end

function PlayState:update(dt)
   self.LevelManager:update(dt)
end

function PlayState:render()
    self.LevelManager:render()
end

