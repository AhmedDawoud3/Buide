LevelSelect = Class {
    __includes = BaseState
}

local pages = {{
    active = true,
    levels = {{
        highScore = 99.99,
        selected = false
    }, {
        highScore = 99.99,
        selected = false
    }, false, false, false, false}
}}

local xx, yy, ww, hh, rr, xO, yO = 0, 0, 0, 0, 0, 0, 0

demoImage = love.graphics.newImage('assets/images/Levels/Demo.png')

function LevelSelect:enter()
    self.suit = Suit.new()
    self.pageIndex = 1
    self.selectedLevel = nil
    for i, v in ipairs(pages) do
        if v.active then
            self.activePage = v
            self.pageIndex = i
            break
        end
    end
end

function LevelSelect:update(dt)
    if self.suit:Button('Back', {
        font = fonts['Semibold40']
    }, 50, 600, 240, 60).hit or love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')
    end
    if self.suit:Button('Start', {
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
        gStateMachine:change('play', {
            level = ('Level' .. self.selectedLevel)
        })
    end

    if self.suit:Button('<', {
        font = fonts['Semibold40']
    }, Window.width / 2 - 134 - 48 / 2, 608, 48, 48).hit or love.keyboard.wasPressed('escape') then
        -- TODO: Change PAGE
    end
    if self.suit:Button('>', {
        font = fonts['Semibold40'],
        cornerRadius = 30
    }, Window.width / 2 + 134 - 48 / 2, 608, 48, 48).hit or love.keyboard.wasPressed('escape') then
        -- TODO: Change PAGE
    end
end

function LevelSelect:render()
    love.graphics.clear(0.1, 0.12, 0.15)

    -- Check if the number of pages is odd or even (For allignments)
    local OddPage = #pages % 2 ~= 0

    -- Draw Current Page
    for i, v in ipairs(pages) do
        if v.active then
            love.graphics.setColor(0.45, 0.45, 0.45, 1)
        else
            love.graphics.setColor(0.25, 0.27, 0.3, 1)
        end
        if OddPage then
            love.graphics.circle('fill', Window.width / 2 + (math.floor(#pages / 2) + 1 - i) * 27, 633, 8.764)
        else
            -- TODO: Allignments for even page count 
        end
    end

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
            love.graphics.printf("Best Time: " .. "99:99", 0, 168, 239, 'center')
            if v and self.suit:Button(i, {
                font = fonts['Semibold40'],
                cornerRadius = 30,
                draw = function()
                    love.graphics.setColor(1, 1, 1, 1)
                    love.graphics.draw(demoImage, (i - 1) % 3 * 412 + 110 + 22,
                        math.floor(i / 4) * (245 + 21) + 15 + 105 + 37, 0, 0.123, 0.123)
                end
            }, (i - 1) % 3 * 412 + 110, math.floor(i / 4) * (245 + 21) + 15 + 105, 239, 200).hovered then
                love.graphics.setColor(1, 1, 1, 0.5)
                love.graphics.rectangle('fill', 0, 0, 239, 200, 42, 42)
                love.graphics.setColor(1, 1, 1, 1)
                if love.mouse.wasReleased(1) then
                    print("Entering Level " .. i)
                    self.selectedLevel = i
                    self:SelectLevel(v)
                end
            end
        end
        love.graphics.translate(-((i - 1) % 3 * 412 + 110), -(math.floor(i / 4) * (245 + 21) + 15 + 105))
    end
    self.suit:draw()

    love.graphics.setColor(1, 1, 1, 1)
    xx = imgui.SliderFloat("X", xx, 0.0, 200);
    xO = imgui.SliderFloat("X Offset", xO, 0.0, 200);
    yy = imgui.SliderFloat("Y", yy, -50, 200);
    yO = imgui.SliderFloat("Y Offset", yO, 0, 200);
    ww = imgui.SliderFloat("Width", ww, 0.0, 500);
    hh = imgui.SliderFloat("Height", hh, 0.0, 500);
    rr = imgui.SliderFloat("Round Edge", rr, 0, 0.183);
    -- imgui.Render();
end

function LevelSelect:exit()
    for i, v in ipairs(self.activePage.levels) do
        if v then
            v.selected = false
        end
    end
end

function LevelSelect:SelectLevel(level)
    for i, v in ipairs(self.activePage.levels) do
        if v then
            v.selected = false
        end
    end
    level.selected = true
end

function bitand(a, b)
    local result = 0
    local bitval = 1
    while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
            result = result + bitval -- set the current bit
        end
        bitval = bitval * 2 -- shift left
        a = math.floor(a / 2) -- shift right
        b = math.floor(b / 2)
    end
    return result
end

OR, XOR, AND = 1, 3, 4

function bitoper(a, b, oper)
    local r, m, s = 0, 2 ^ 31
    repeat
        s, a, b = a + b + m, a % m, b % m
        r, m = r + m * oper % (s - a - b), m / 2
    until m < 1
    return r
end
