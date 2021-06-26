local Serialize = require 'lib/knife/serialize'

function LoadSaveFile()
    local dateExists = love.filesystem.getInfo("SaveGame.tbl")
    local saveData = love.filesystem.read("SaveGame.tbl")
    if dateExists then
        local data = setfenv(loadstring(saveData), {})()
        if data.BallColor == nil then
            data.BallColor = DefaultDate.BallColor
        end
        if data.BallTrail == nil then
            data.BallTrail = DefaultDate.BallTrail
        end
        return data
    end
    return DefaultDate
end

function SaveGame()
    love.filesystem.write("SaveGame.tbl", Serialize(options))
end
