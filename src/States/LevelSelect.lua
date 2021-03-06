LevelSelect = Class {
    __includes = BaseState
}
local Timer = require "lib.knife.timer"
local Easing = require 'lib.easing'

demoImage = love.graphics.newImage('assets/images/Levels/Demo.png')

local levelsOffset = {
    value = 0,
    dx = 0
}

function LevelSelect:enter()
    self.suit = Suit.new()
    self.pageIndex = 1
    self.selectedLevel = nil

    self.pages = {{
        active = true,
        levels = {{
            highScore = LoadScore(1),
            selected = false
        }, {
            highScore = LoadScore(2),
            selected = false
        }, {
            highScore = LoadScore(3),
            selected = false
        }, false, false, false}
    }, {
        active = false,
        levels = {false, false, false, false, false, false}
    }, {
        active = false,
        levels = {false, false, false, false, false, false}
    }}
    for i, v in ipairs(self.pages) do
        if v.active then
            self.activePage = v
            self.pageIndex = i
            break
        end
    end
end

function LevelSelect:update(dt)
    levelsOffset.value = levelsOffset.value + levelsOffset.dx
    Timer.update(dt)

    if self.suit:Button('Back', {
        font = fonts['Semibold40']
    }, 50, 600, 240, 60).hit or love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')
    end
    if self.suit:Button('Play', {
        font = fonts['Semibold40'],
        color = self.selectedLevel and {
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
        } or {
            normal = {
                bg = {0.15, 0.17, 0.2},
                fg = {0.72, 0.72, 0.77}
            },
            hovered = {
                bg = {0.15, 0.17, 0.2},
                fg = {0.72, 0.72, 0.77}
            },
            active = {
                bg = {0.15, 0.17, 0.2},
                fg = {0.72, 0.72, 0.77}
            }
        }

    }, Window.width - 240 - 50, 600, 240, 60).hit and self.selectedLevel then
        gStateMachine:change('LevelConfirm', {
            level = self.selectedLevel
        })
    end

    if self.suit:Button('>', {
        font = fonts['Semibold40'],
        cornerRadius = 30,
        active = false
    }, Window.width / 2 + 134 - 48 / 2, 608, 48, 48).hit or love.keyboard.wasPressed('escape') then
        self:NextPage()
    end
    if self.suit:Button('<', {
        font = fonts['Semibold40'],
        cornerRadius = 30
    }, Window.width / 2 - 134 - 48 / 2, 608, 48, 48).hit or love.keyboard.wasPressed('escape') then
        self:PreviousPage()
    end
end

function LevelSelect:render()
    love.graphics.clear(0.1, 0.12, 0.15)

    -- Draw Current Page
    for i, v in ipairs(self.pages) do
        if v.active then
            love.graphics.setColor(0.45, 0.45, 0.45, 1)
        else
            love.graphics.setColor(0.25, 0.27, 0.3, 1)
        end
        love.graphics.circle('fill', Window.width / 2 - (math.floor(#self.pages / 2) + 1 - i) * 27, 633, 8.764)
    end

    love.graphics.translate(levelsOffset.value, 0)

    for i, v in ipairs(self.activePage.levels) do
        love.graphics.setLineWidth(5)

        if v and v.selected then
            love.graphics.setColor(0.75, 0.85, 0.45, 1)
        else
            love.graphics.setColor(0.72, 0.72, 0.77, 1)
        end
        love.graphics.translate((i - 1) % 3 * 412 + 110, math.floor(i / 4) * (245 + 21) + 15 + 105)
        love.graphics.rectangle('line', 0, 0, 239, 200, 42, 42)
        love.graphics.setFont(fonts['Medium40'])
        if v == false then
            love.graphics.printf("Coming Soon", 0, 50, 239, 'center')
        else
            love.graphics.printf("Level " .. i + 6 * (self.pageIndex - 1), 0, -50, 239, 'center')
            love.graphics.setFont(fonts['Medium20'])
            love.graphics.printf("Best Time: " .. TimeGSUB(v.highScore, 2), 0, 168, 239, 'center')
            if v and self.suit:Button(i, {
                font = fonts['Semibold40'],
                cornerRadius = 30,
                draw = function()
                    love.graphics.setColor(1, 1, 1, 1)
                    love.graphics.draw(levelsImages[i] or demoImage, levelsOffset.value + (i - 1) % 3 * 412 + 110 + 16,
                        math.floor(i / 4) * 261 + 147, 0, 0.101599, 0.101599)
                end
            }, levelsOffset.value + (i - 1) % 3 * 412 + 110, math.floor(i / 4) * (245 + 21) + 15 + 105, 239, 200)
                .hovered then
                love.graphics.setColor(1, 1, 1, 0.5)
                love.graphics.rectangle('fill', 0, 0, 239, 200, 42, 42)
                love.graphics.setColor(1, 1, 1, 1)
                if love.mouse.wasReleased(1) then
                    self.selectedLevel = i * self.pageIndex
                    self:SelectLevel(v)
                end
            end
        end
        love.graphics.translate(-((i - 1) % 3 * 412 + 110), -(math.floor(i / 4) * (245 + 21) + 15 + 105))
    end
    love.graphics.translate(-levelsOffset.value, 0)
    self.suit:draw()

    love.graphics.setColor(1, 1, 1, 1)
end

function LevelSelect:exit()
    Timer.clear()
    levelsOffset.value = 0
    for i, v in ipairs(self.activePage.levels) do
        if v then
            v.selected = false
        end
    end
    self.pageIndex = 1
    self.selectedLevel = nil
    for i, v in ipairs(self.pages) do
        v.active = false
    end
    self.pages[1].active = true
end

function LevelSelect:SelectLevel(level)
    for i, v in ipairs(self.activePage.levels) do
        if v then
            v.selected = false
        end
    end
    level.selected = true
end

function LevelSelect:NextPage()
    -- Timer.clear()
    if levelsOffset.value == 0 and self.pageIndex ~= #self.pages then
        Timer.tween(0.5, {
            [levelsOffset] = {
                value = -1180
            }
        }):ease(Easing.inCubic):finish(function()
            levelsOffset.value = 1180
            self.pages[self.pageIndex].active = false
            if self.pageIndex ~= #self.pages then
                self.pageIndex = self.pageIndex + 1
                self.activePage = self.pages[self.pageIndex]
                self.pages[self.pageIndex].active = true
            end
            Timer.tween(0.5, {
                [levelsOffset] = {
                    value = 0
                }
            }):ease(Easing.outCubic)
        end)
    end
end

function LevelSelect:PreviousPage()
    -- Timer.clear()
    if levelsOffset.value == 0 and self.pageIndex ~= 1 then
        Timer.tween(0.5, {
            [levelsOffset] = {
                value = 1180
            }
        }):ease(Easing.inCubic):finish(function()
            levelsOffset.value = -1180
            self.pages[self.pageIndex].active = false
            if self.pageIndex ~= 1 then
                self.pageIndex = self.pageIndex - 1
                self.activePage = self.pages[self.pageIndex]
                self.pages[self.pageIndex].active = true
            end
            Timer.tween(0.5, {
                [levelsOffset] = {
                    value = 0
                }
            }):ease(Easing.outCubic)
        end)
    end
end

