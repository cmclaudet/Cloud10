
pickup = {}

function pickup:new(x,y,xdir,ydir,speed,number)
  pickupImage = love.graphics.newImage("assets/pickupspritesheet.png")
  fontPickup = love.graphics.newFont("assets/sitka-small-bold.ttf",65)
  collOffX = 30
  collOffY = 40
  collBoxW = 60

  animations = {
    idle = {
      love.graphics.newQuad(0, 0, 125, 125, pickupImage:getDimensions()),
      love.graphics.newQuad(125, 0, 125, 125, pickupImage:getDimensions()),
      love.graphics.newQuad(250, 0, 125, 125, pickupImage:getDimensions()),
      love.graphics.newQuad(375, 0, 125, 125, pickupImage:getDimensions()),
      love.graphics.newQuad(500, 0, 125, 125, pickupImage:getDimensions()),
      love.graphics.newQuad(375, 0, 125, 125, pickupImage:getDimensions()),
      love.graphics.newQuad(250, 0, 125, 125, pickupImage:getDimensions()),
      love.graphics.newQuad(125, 0, 125, 125, pickupImage:getDimensions())
    }
  }

  numPositions = {
    x = {-1,0,1,0,-1,0,1,0},
    y = {0,0,0,0,0,0,0,0}
  }

  o = {
    spriteSheet = pickupImage,
    animations = animations,
    currAnim = animations.idle,
    currFrame = 1,
    elapsedTime = 0,
    frameDuration = 0.1,
    font = fontPickup,

    x = x,
    y = y,
    w = 125,
    h = 125,
    xdir = xdir,
    ydir = ydir,
    speed = speed,
    number = number,
    numPositions = numPositions,
    collOffX = collOffX,
    collOffY = collOffY,
    collBoxW = collBoxW,

    collBox = {
      x = x + collOffX,
      y = y + collOffY,
      w = collBoxW,
      h = collBoxW
    }
  }

  setmetatable(o, self)
  self.__index = self
  return o
end

function pickup:update(dt)
  self.x = self.x + self.xdir*self.speed*dt
  self.y = self.y + self.ydir*self.speed*dt

  self.collBox.x = self.x + self.collOffX
  self.collBox.y = self.y + self.collOffY

  self.elapsedTime = self.elapsedTime + dt

  if self.elapsedTime >= self.frameDuration then
    if self.currFrame < #self.currAnim then
      self.currFrame = self.currFrame + 1
    else
      self.currFrame = 1
    end
    self.elapsedTime = 0
  end

end

function pickup:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(
  self.spriteSheet,
  self.currAnim[self.currFrame],
  self.x,
  self.y
  )

  love.graphics.setFont(self.font)
--  love.graphics.setColor(27,61,80)
  love.graphics.setColor(30,30,30)

  noWidth = self.font:getWidth(tostring(self.number))
  noHeight = self.font:getHeight(tostring(self.number))
  numX = self.x + self.w/2 - noWidth/2-3
  numY = self.y + self.h/2 - noHeight/2-5

  love.graphics.print(
  tostring(self.number),
  numX + self.numPositions.x[self.currFrame],
  numY + self.numPositions.y[self.currFrame]
  )
end

return pickup
