MouseHandler = Class {x, y}

local sin = math.sin
local cos = math.cos
local adderAngle = 0
local oldAngle = 0

function MouseHandler:init()
    self.isDown = false
    self.tempRect = {}
end

function MouseHandler:update(dt, level)
    self.pos = Vector(push:toGame(love.mouse.getPosition()))
    if not level.playing then
        self:Cancel()
    end
    if love.mouse.wasPressed(1) and level.playing then
        self.tempRect.st = self.pos
        self.tempRect.en = Vector(10, 10)
        self.isDown = true
    end
    if love.mouse.wasPressed(2) and self.isDown then
        self:Cancel()
    end
    if self.isDown and level.playing then
        local angleA
        self.tempRect.en = self.pos
        angleA = getAngle(self.tempRect.st.x, self.tempRect.st.y, self.tempRect.en.x, self.tempRect.en.y) +
                     3.14159265359
        angleA = angleA * 180 / 3.14159265359
        if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
            local mag = GetDistance(self.tempRect.st.x, self.tempRect.st.y, self.tempRect.en.x, self.tempRect.en.y)
            if angleA < 45 or angleA > 315 then
                angleA = 0
            elseif angleA < 135 then
                angleA = 90
            elseif angleA < 245 then
                angleA = 180
            elseif angleA < 315 then
                angleA = 270
            end
            if love.mouse.scrolled == -1 then
                adderAngle = adderAngle + 5.625
            elseif love.mouse.scrolled == 1 then
                adderAngle = adderAngle - 5.625
            end
            if oldAngle ~= angleA then
                oldAngle = angleA
                adderAngle = 0
            end
            angleA = angleA + adderAngle
            self.tempRect.en = Vector(self.tempRect.st.x + mag * cos(-3.14159265359 + angleA / (180 / 3.14159265359)),
                self.tempRect.st.y + mag * sin(-3.14159265359 + angleA / (180 / 3.14159265359)))
        else
            adderAngle = 0
        end
    else
        adderAngle = 0
    end
    if love.mouse.wasReleased(1) and self.isDown then
        self:AddToGame(level)
    end

    if love.mouse.wasReleased(2) and not self.isDown then
        self:CheckCollisionWithCBoxes(level)
    end

end

function MouseHandler:render(level)
    love.graphics.setColor(1, 1, 1, 1)
    if love.mouse.isDown(1) and level.playing then
        if math.sqrt((self.tempRect.st.x - self.tempRect.en.x) ^ 2 + (self.tempRect.st.y - self.tempRect.en.y) ^ 2) > 20 then
            love.graphics.setColor(0.92, 0.92, 0.92, 1)
        else
            love.graphics.setColor(1, 0, 0, 1)
        end
        local start = self.tempRect.st
        local en = self.tempRect.en
        love.graphics.setLineWidth(10)
        love.graphics.line(start.x, start.y, en.x, en.y)
        love.graphics.setLineWidth(1)
    end
    if love.mouse.isDown(2) and not self.isDown then
        for i, v in ipairs(level.cBoxes) do
            if CheckMouseCollisionWithRectangle(self.pos, v[1], v[2], true) then
                break
            end
        end
    end
end

function MouseHandler:Cancel()
    self.isDown = false
    self.tempRect.en = self.tempRect.st
end

function MouseHandler:CheckCollisionWithCBoxes(level)
    if #level.cBoxes > 0 then
        for i = #level.cBoxes, 1, -1 do
            local v = level.cBoxes[i]
            local x, y = v[1]:getPosition()
            if CheckMouseCollisionWithRectangle(self.pos, v[1], v[2]) then
                v[3]:destroy()
                table.remove(level.cBoxes, i)
                break
            end
        end
    end
end

function CheckMouseCollisionWithRectangle(mousePos, body, shape, DRAW)
    local x1, y1, x2, y2, x3, y3, x4, y4 = body:getWorldPoints(shape:getPoints())
    local trX, trY = x1, y1
    -- TODO Check Bound cBoxes
    --     if y3 - y1 > 0 then
    --      love.graphics.rectangle('line', x1, y1 - 10, x3 - x1, y3 - y1 + 20)
    --     else
    --      love.graphics.rectangle('line', x1, y1 + 10, x3 - x1, y3 - y1 - 20)
    --     end
    love.graphics.translate(trX, trY)
    mousePos = Vector(mousePos.x - x1, mousePos.y - y1)
    x1, y1, x2, y2, x3, y3, x4, y4 = x1 - x1, y1 - y1, x2 - x1, y2 - y1, x3 - x1, y3 - y1, x4 - x1, y4 - y1

    local angle = getAngle(0, 0, x2, y2)
    local mouseAng = getAngle(0, 0, mousePos.x, mousePos.y)
    local mouseDist = math.sqrt(mousePos.x ^ 2 + mousePos.y ^ 2)
    love.graphics.rotate(angle)
    mousePos = Vector(mouseDist * cos(mouseAng - angle), mouseDist * sin(mouseAng - angle))

    local rect = {
        x = 0,
        y = 0,
        width = math.sqrt((x2) ^ 2 + (y2) ^ 2),
        height = 10
    }

    if mousePos.x > rect.x and mousePos.x < rect.x + rect.width and mousePos.y > rect.y and mousePos.y < rect.y +
        rect.height then
        if DRAW then
            love.graphics.setColor(0.95, 0.45, 0.3, 1)
            love.graphics.rectangle('fill', rect.x, rect.y, rect.width, rect.height)
        end
        love.graphics.rotate(-angle)
        love.graphics.translate(-trX, -trY)
        return true
    end

    love.graphics.rotate(-angle)
    love.graphics.translate(-trX, -trY)
    return false
end

function MouseHandler:AddToGame(level)
    local x = (self.tempRect.st.x + self.tempRect.en.x) / 2
    local y = (self.tempRect.st.y + self.tempRect.en.y) / 2
    local height = 10
    local size =
        math.sqrt((self.tempRect.st.x - self.tempRect.en.x) ^ 2 + (self.tempRect.st.y - self.tempRect.en.y) ^ 2)
    local rotation = getAngle(self.tempRect.st.x, self.tempRect.st.y, self.tempRect.en.x, self.tempRect.en.y)

    if size > 20 then
        level:CreateCustomRectangle(x, y, size, height, rotation * (180 / 3.14159265))
    end
    self.isDown = false
end
