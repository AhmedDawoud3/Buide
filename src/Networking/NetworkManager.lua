local http = require("socket.http")
local Codes = {{
    privateCode = 'dciprxTJD0CYPpWusm8KFwXTghLDeWI0GD4ZxYlhy1Cw',
    publicCode = '60f5817d8f40bb8ea03a4f83'
},
{
    privateCode = 'YKJG2D8YiEmnEceIpO__JQ9AcIkDaZV0CRpDcZZvEwnA',
    publicCode = '60fd2e7c8f40bb8ea0452a9a'
}}
local webURL = 'http://dreamlo.com/lb/'
function DownloadHighScores(level)
    if not Codes[level] then
        return false
    end
    local body, code, headers, status = http.request(webURL .. Codes[level].publicCode .. "/pipe-seconds-asc/")
    if not body then
        return false
    end
    return body
end

function UploadNewHighScore(name, level, score)
    score = tonumber(TimeGSUB(score, 4))
    if not Codes[level] then
        error("Error from the programmer while loading data from the internet")
    end
    http.request(webURL .. Codes[level].privateCode .. "/delete/" .. EscapeURL(string.sub(name, 1, 9)))
    local body, code, headers, status = http.request(webURL .. Codes[level].privateCode .. "/add/" ..
                                                         EscapeURL(string.sub(name, 1, 9)) .. '/' ..
                                                         tostring(score * NetworkSmoother) .. '/')
    return body
end

char_to_hex = function(c)
    return string.format("%%%02X", string.byte(c))
end

function EscapeURL(url)
    if url == nil then
        return ""
    end
    url = url:gsub("\n", "\r\n")
    url = url:gsub("([^%w ])", char_to_hex)
    url = url:gsub(" ", "+")
    return url
end

hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end

urldecode = function(url)
    if url == nil then
        return
    end
    url = url:gsub("+", " ")
    url = url:gsub("%%(%x%x)", hex_to_char)
    return url
end
