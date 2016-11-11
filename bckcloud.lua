bckcloud = {}

function bckcloud:new(x, y, scale, currFrame)
  image = love.graphics.newImage("assets/cloudbkg.png")
  opacity = 150
  frames = {
    love.graphics.newQuad(0, 0, 200, 150, image:getDimensions()),
    love.graphics.newQuad(200, 0, 200, 150, image:getDimensions()),
    love.graphics.newQuad(400, 0, 200, 150, image:getDimensions()),
    love.graphics.newQuad(600, 0, 200, 150, image:getDimensions()),
    love.graphics.newQuad(0, 150, 200, 150, image:getDimensions()),
    love.graphics.newQuad(200, 150, 200, 150, image:getDimensions()),
    love.graphics.newQuad(400, 150, 200, 150, image:getDimensions()),
    love.graphics.newQuad(600, 150, 200, 150, image:getDimensions()),
    love.graphics.newQuad(800, 150, 200, 150, image:getDimensions()),
    love.graphics.newQuad(600, 150, 200, 150, image:getDimensions()),
    love.graphics.newQuad(400, 150, 200, 150, image:getDimensions()),
    love.graphics.newQuad(200, 150, 200, 150, image:getDimensions()),
    love.graphics.newQuad(0, 150, 200, 150, image:getDimensions()),
    love.graphics.newQuad(600, 0, 200, 150, image:getDimensions()),
    love.graphics.newQuad(400, 0, 200, 150, image:getDimensions()),
    love.graphics.newQuad(200, 0, 200, 150, image:getDimensions())
  }

  o = {
    image = image,
    x = x,
    y = y,
    scale = scale,
    opacity = opacity,
    frames = frames,
    elapsedTime = 0,
    frameDuration = 0.1,
    currFrame = currFrame
  }

  setmetatable(o, self)
  self.__index = self
  return o
end

function bckcloud:update(dt)
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

function bckcloud:draw()
  love.graphics.setColor(255,255,255,self.opacity)
  love.graphics.draw(
  self.image,
  self.frames[self.currFrame],
  self.x,
  self.y,
  self.rot,
  self.scale,
  self.scale
  )
end

return bckcloud
