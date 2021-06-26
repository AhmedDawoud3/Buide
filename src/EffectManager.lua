EffectManager = Class {}

function EffectManager:init()
    self.trail = {}
    self.trailLength = 20
end

function EffectManager:update(dt)
    local trail, trailLength = self.trail, self.trailLength
    if #trail < trailLength then
        local x, y = player.body:getPosition()

        trail[#trail + 1] = {
            x = x,
            y = y
        }

    elseif #trail == trailLength then
        for i = 1, trailLength - 1 do
            trail[i] = trail[i + 1]
        end

        local x, y = player.body:getPosition()
        trail[trailLength] = {
            x = x,
            y = y
        }

    end
end

function EffectManager:draw()

    for i = 1, #self.trail do
        local pos = self.trail[i]
        love.graphics.circle('fill', pos.x, pos.y, i / 5)

        if i ~= 1 then
            local previousPos = self.trail[i - 1]
            local posDelta = {
                x = pos.x - previousPos.x,
                y = pos.y - previousPos.y
            }

            local d = 25
            for j = 1, d - 1 do
                love.graphics.setColor(options.BallColor[1], options.BallColor[2], options.BallColor[3], 0.02)
                love.graphics.circle('fill', pos.x - posDelta.x / d * j, pos.y - posDelta.y / d * j, i)
            end
        end
    end

    love.graphics.setColor(1, 1, 1)
end
