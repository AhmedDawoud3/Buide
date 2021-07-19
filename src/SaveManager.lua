local Serialize = require 'lib/knife/serialize'

function LoadSaveFile()
    local dateExists = love.filesystem.getInfo("options.tbl")
    local saveData = love.filesystem.read("options.tbl")
    if dateExists then
        local data = setfenv(loadstring(saveData), {})()
        if data.BallColor == nil then
            data.BallColor = DefaultDate.BallColor
        end
        if data.BallTrail == nil then
            data.BallTrail = DefaultDate.BallTrail
        end
        if data.FullScreen == nil then
            data.FullScreen = DefaultDate.FullScreen
        end
        return data
    end
    return DefaultDate
end

function SaveGame()
    love.filesystem.write("options.tbl", Serialize(options))
end

function LoadScores()
    local scoresExists = love.filesystem.getInfo("scores.tbl")
    local scoresData = love.filesystem.read("scores.tbl")
    if scoresExists then
        local scores = setfenv(loadstring(scoresData), {})()
        return scores
    end
end

function LoadScore(level)
    local scores = LoadScores()
    if scores == nil or scores[level] == nil then
        return 99.9999
    end
    return scores[level]
end

function SaveScore(info)
    local level = info.level
    local score = info.score

    local scores = LoadScores()
    if scores == nil then
        scores = {}
    end
    scores[level] = score

    SaveScores(scores)
end

function SaveScores(scores)
    love.filesystem.write("scores.tbl", Serialize(scores))
end
