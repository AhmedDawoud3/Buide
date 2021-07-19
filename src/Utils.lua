---@param time string|integer
---@param n integer
---@return string
function TimeGSUB(time, n)
    time = tonumber(time)
    seconds = math.floor(time)
    miliseconds = time - seconds
    timeFormated = tostring(seconds) .. string.sub(tostring(miliseconds), 2, n + 2)
    return timeFormated
end

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function rgb(r, g, b)
    love.graphics.setColor(r / 255, g / 255, b / 255)
end
