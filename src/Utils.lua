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
