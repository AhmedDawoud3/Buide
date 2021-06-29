LevelManager = Class{}

function LevelManager:init(levels)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.levels = levels or {} -- [name] -> [function that returns levels]
	self.current = self.empty
	self.timer = 0
end

function LevelManager:change(levelName, enterParams)
	assert(self.levels[levelName]) -- state must exist!
	self.current:exit()
	self.current = self.levels[levelName]()
	self.current:enter(enterParams)
end

function LevelManager:update(dt)
	self.current:update(dt)
end

function LevelManager:render()
	self.current:render()
end
