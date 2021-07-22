LevelConfirm = Class {
    __includes = BaseState
}
local xx, yy, ww, hh, rr, xO, yO = 0, 0, 0, 0, 0, 0, 0
local rr, gg, bb = 0, 0, 0
local fontSize = 1
function LevelConfirm:enter(params)
    self.level = params.level
    self.suit = Suit.new()
    self.image = {
        draw = levelsImages[self.level] or demoImage,
        width = 2048,
        height = 1152
    }

    self.internetData = DownloadHighScores(self.level)
    if self.internetData then
        self.fetchedData = FetchData(self.internetData)
    end
end

function LevelConfirm:update(dt)
    if self.suit:Button('Back', {
        font = fonts['Semibold40']
    }, 50, 600, 240, 60).hit or love.keyboard.wasPressed('escape') then
        gStateMachine:change('levelSelect')
    end

    if self.suit:Button('Start', {
        font = fonts['Semibold40']
    }, Window.width - 240 - 50, 600, 240, 60).hit then
        gStateMachine:change('play', {
            level = 'Level' .. tostring(self.level)
        })
    end
end

function LevelConfirm:render()
    love.graphics.clear(0.1, 0.12, 0.15)

    love.graphics.setColor(1, 1, 0.9, 1)
    love.graphics.setFont(fonts['ExtraBold60'])
    love.graphics.print("Level " .. self.level, 40, 50)

    --[[
        Render The level's Image
    ]]
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.image.draw, 834, 51, 0, 0.17, 0.17)

    --[[
        BEST TIME
    ]]
    love.graphics.setFont(fonts['Bold32'])
    rgb(219, 87, 33)
    love.graphics.print("Best Time: " .. tostring(TimeGSUB(LoadScore(1), 2)), 67, 134)

    --[[
        Leaderboard via internet
    ]]
    love.graphics.setColor(1, 1, 0.9, 1)
    love.graphics.setFont(fonts['Medium40'])
    love.graphics.print("Leaderboard:", 40, 187)
    if not self.internetData then
        love.graphics.setFont(fonts['Bold32'])
        love.graphics.print("Error: Could load data from the internet\nPlease make sure you have internet connection",
            60, 276)
    else
        for i = 1, 10 do
            local name
            local score
            if self.fetchedData[i] then
                name = self.fetchedData[i].name or "N/A"
                score = self.fetchedData[i].score or "99.99"
            else
                name = "N/A"
                score = "99.99"
            end
            -- We do "math.floor(i / 6)" to make a new line each 5 iterations
            love.graphics.setFont(fonts['Light40'])
            love.graphics.setColor(1, 1, 0.9, 1)
            love.graphics.print(tostring(i) .. '. ' .. tostring(name), 85 + math.floor(i / 6) * 400,
                (i - 1) % 5 * 68 + 242)
            rgb(255, 109, 90)
            love.graphics.setFont(fonts['Semibold40'])
            love.graphics.print(tostring(TimeGSUB(score, 2)), 365 + math.floor(i / 6) * 400, (i - 1) % 5 * 68 + 242)

        end
    end

    rgb(255, 255, 255)
    -- rgb(rr, gg, bb)
    self.suit:draw()
    -- xx = imgui.SliderFloat("X", xx, 0.0, 500);
    -- fontSize = math.floor(imgui.SliderFloat("Font Size", fontSize, 1, 100))
    -- yy = imgui.SliderFloat("Y", yy, 0.0, 400);
    -- yO = imgui.SliderFloat("Y Offset", yO, 0, 400);
    -- rr = imgui.SliderFloat("R", rr, 0, 255);
    -- gg = imgui.SliderFloat("G", gg, 0, 255);
    -- bb = imgui.SliderFloat("B", bb, 0, 255);
    imgui.Render();
end

function FetchData(data)
    local people = {}
    local players = {}

    for s in data:gmatch("[^\r\n]+") do
        table.insert(people, s)
    end
    for i, person in ipairs(people) do
        people[i] = Split(person, "|")
    end
    for _, person in ipairs(people) do
        table.insert(players, {
            name = person[1],
            score = tonumber(person[2]) / NetworkSmoother,
            date = person[4]
        })
    end

    table.sort(players, function(a, b)
        return a.score < b.score
    end)

    return (players)
end
