MouseHandler = Class {x, y}

function MouseHandler:init()
    self.isDown = false
    self.tempRect = {}
end

function MouseHandler:update(dt)
    self.x, self.y = push:toGame(love.mouse.getPosition())
    if love.mouse.wasPressed(1) then
        self.tempRect.x = self.x
        self.tempRect.y = self.y
        self.tempRect.x2 = 10
        self.tempRect.y2 = 10
        self.isDown = true
    end
    if self.isDown then
        self.tempRect.x2 = self.x
        self.tempRect.y2 = self.y
    end
    if love.mouse.wasReleased(1) then
        self:AddToGame()
    end
    print(Screen.width, Screen.height)
end

function MouseHandler:render()
    if love.mouse.isDown(1) then
        local startX = self.tempRect.x
        local startY = self.tempRect.y
        local endX = self.tempRect.x2
        local endY = self.tempRect.y2
        love.graphics.setLineWidth(10)
        love.graphics.line(startX, startY, endX, endY)
        love.graphics.setLineWidth(1)
    end
end

function MouseHandler:AddToGame()
    local x = (self.tempRect.x + self.tempRect.x2) / 2
    local y = (self.tempRect.y + self.tempRect.y2) / 2
    local height = 10
    local size = math.sqrt((self.tempRect.x - self.tempRect.x2) ^ 2 + (self.tempRect.y - self.tempRect.y2) ^ 2)
    local rotation = getAngle(self.tempRect.x, self.tempRect.y, self.tempRect.x2, self.tempRect.y2)

    CreateCustomRectangle(x, y, size, height, rotation * (180 / 3.14159265))
end

function getAngle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end
