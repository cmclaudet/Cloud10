clicktoPlay = {}

function clicktoPlay:new()
  clickimage = love.graphics.newImage("assets/clicktoplay.png")
  o = {
    image = clickimage,
    frames = {
      love.graphics.newQuad(0, 0, 500, 175, clickimage:getDimensions()),
      love.graphics.newQuad(500, 0, 500, 175, clickimage:getDimensions()),
      love.graphics.newQuad(1000, 0, 500, 175, clickimage:getDimensions()),
      love.graphics.newQuad(0, 175, 500, 175, clickimage:getDimensions()),
      love.graphics.newQuad(500, 175, 500, 175, clickimage:getDimensions()),
      love.graphics.newQuad(0, 175, 500, 175, clickimage:getDimensions()),
      love.graphics.newQuad(1000, 0, 500, 175, clickimage:getDimensions()),
      love.graphics.newQuad(500, 0, 500, 175, clickimage:getDimensions())
    },

    x = 250,
    y = 450,

    currFrame = 1,
    elapsedTime = 0,
    frameDuration = 0.09
  }

  setmetatable(o, self)
  self.__index = self
  return o
end

function clicktoPlay:update(dt)
  self.elapsedTime = self.elapsedTime + dt
  if self.elapsedTime >= self.frameDuration then
    if self.currFrame < #self.frames then
      self.currFrame = self.currFrame + 1
    else
      self.currFrame = 1
    end
    self.elapsedTime = 0
  end
end

function clicktoPlay:draw()
  love.graphics.draw(
  self.image,
  self.frames[self.currFrame],
  self.x,
  self.y
  )
end

return clicktoPlay
