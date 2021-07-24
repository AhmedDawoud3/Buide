local Timer = require "lib.knife.timer"
local Easing = require 'lib.easing'
WelcomeState = Class {
    __includes = BaseState
}
local xx, xo, yy, yo, ww, hh, rr = 0, 0, 0, 0, 0, 0, 0

local Opacities = {
    Buide = 0,
    AhmedDawoud = 0,
    version = 0,
    love = 0
}
local loveLogo = love.graphics.newImage('assets/images/love-logo.png')

function WelcomeState:enter()
    Timer.tween(0.5, {
        [Opacities] = {
            Buide = 0
        }
    }):ease(Easing.outCubic):finish(function()
        Timer.tween(1, {
            [Opacities] = {
                Buide = 1
            }
        }):ease(Easing.outCubic):finish(function()
            Timer.tween(1, {
                [Opacities] = {
                    AhmedDawoud = 1
                }
            }):ease(Easing.outCubic):finish(function()
                Timer.tween(0.5, {
                    [Opacities] = {
                        version = 1
                    }
                }):ease(Easing.inQuart):finish(function()
                    Timer.tween(0.3, {
                        [Opacities] = {
                            love = 1
                        }
                    }):ease(Easing.inSine):finish(function()
                        Timer.tween(1, {
                            [Opacities] = {
                                Buide = 0,
                                AhmedDawoud = 0,
                                version = 0,
                                love = 0
                            }
                        }):ease(Easing.outCubic):finish(function()
                            gStateMachine:change('start')
                        end)
                    end)
                end)
            end)
        end)
    end)
end

function WelcomeState:update(dt)
    Timer.update(dt)
end

function WelcomeState:render()
    love.graphics.clear(0.1, 0.12, 0.15)
    love.graphics.setFont(fonts['ExtraBold150'])
    love.graphics.setColor(1, 1, 1, Opacities.Buide)
    love.graphics.printf("Buide", 0, 125, Window.width, 'center')

    love.graphics.setFont(fonts['Semibold40'])
    love.graphics.setColor(1, 1, 1, Opacities.AhmedDawoud)
    love.graphics.printf("© Ahmed Dawoud", 0, 575, Window.width, 'center')

    love.graphics.setColor(1, 1, 1, Opacities.love)
    love.graphics.draw(loveLogo, 1069, 612, 0, 0.155, 0.155)

    love.graphics.setColor(1, 1, 1, Opacities.version)
    love.graphics.print("Version " .. Game.Version, 35, 625)
    -- IMGUI
    -- love.graphics.setColor(1, 1, 1, 1)
    xx = imgui.SliderFloat("X", xx, 0, 100);
    -- xo = imgui.SliderFloat("X O", xo, 0.0, 50);
    -- yy = imgui.SliderFloat("Y", yy, 0, 1);
    -- yo = imgui.SliderFloat("Y O", yo, 0, 500);
    -- ww = imgui.SliderFloat("Width", ww, 0, 1);
    -- hh = imgui.SliderFloat("Height", hh, 0.0, 50);
    -- rr = imgui.SliderFloat("Round Edge", rr, 0.0, 100);
    -- imgui.Render();
end

function WelcomeState:exit()
    -- play our music outside of all states and set it to looping
    sounds['main']:play()
end
