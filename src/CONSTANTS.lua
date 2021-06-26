Window = {
    width = 1280,
    height = 720
}
love.window.setMode(0, 0)
Screen = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

BallColors ={
    {0.99, 0.85, 0},
    {0.65, 0.23, 0.22},
    {0.59, 0.75, 0.2},
    {0.29, 0.7, 0.3},
    {0.29, 0.3, 0.7},
    {0.29, 0.6, 0.7, 1},
    {0.57, 0.38, 0.6, 1}
}
DefaultDate = {
    BallTrail = true,
    BallColor = BallColors[1]
}