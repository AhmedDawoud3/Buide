Window = {
    width = 1280,
    height = 720
}
love.window.setMode(0, 0)
Screen = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

sounds = {
    ['main'] = love.audio.newSource('assets/sounds/main.wav', 'static'),
    ['play'] = love.audio.newSource('assets/sounds/play.wav', 'static')
}
sounds['main']:setLooping(true)
sounds['play']:setLooping(true)

fixedDT = 0.016666666666666

BallColors ={
    {0.99, 0.85, 0},
    {0.65, 0.23, 0.22},
    {0.59, 0.75, 0.2},
    {0.29, 0.7, 0.3},
    {0.29, 0.3, 0.7},
    {0.29, 0.6, 0.7},
    {0.57, 0.38, 0.6},
    {24/255, 139/255, 133/255},
    {113/255, 170/255, 153/255},
    {255/255, 231/255, 175/255},
    {255/255, 181/255, 142/255},
    {242/255, 139/255, 96/255},
    {254/255, 116/255, 75/255},
    {219/255, 87/255, 33/255}
}
DefaultDate = {
    BallTrail = true,
    BallColor = BallColors[1],
    FullScreen = false
}
