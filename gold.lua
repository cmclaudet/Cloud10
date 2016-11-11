gold = {}

function gold:new(x, y, xdir, ydir)
  goldImage = love.graphics.newImage("assets/goldcloudspritesheet.png")
  fontGold = love.graphics.newFont("assets/sitka-small-bold.ttf",47)
  collOffX = 25
  collOffY = 30
  collBoxW = 40
  speed = math.random(250,300)

  animations = {
    idle = {
      love.graphics.newQuad(0, 0, 125, 125, goldImage:getDimensions()),
      love.graphics.newQuad(125, 0, 125, 125, goldImage:getDimensions()),
      love.graphics.newQuad(250, 0, 125, 125, goldImage:getDimensions()),
      love.graphics.newQuad(375, 0, 125, 125, goldImage:getDimensions()),
      love.graphics.newQuad(500, 0, 125, 125, goldImage:getDimensions()),
      love.graphics.newQuad(375, 0, 125, 125, goldImage:getDimensions()),
      love.graphics.newQuad(250, 0, 125, 125, goldImage:getDimensions()),
      love.graphics.newQuad(125, 0, 125, 125, goldImage:getDimensions())
    }
  }

  o = {
    spriteSheet = goldImage,
    animations = animations,
    currAnim = animations.idle,
    currFrame = 1,
    elapsedTime = 0,
    frameDuration = 0.1,
    font = fontGold,

    x = x,
    y = y,
    w = 125,
    h = 125,
    xdir = xdir,
    ydir = ydir,
    speed = speed,
    number = number,
    numOffx = numOffx,
    numOffy = numOffy,
    numPositions = numPositions,
    collOffX = collOffX,
    collOffY = collOffY,
    collBoxW = collBoxW,

    collBox = {
      x = x + collOffX,
      y = y + collOffY,
      w = collBoxW,
      h = collBoxW
    },

    rot = 0,
    scalex = 0.75,
    scaley = 0.75,
    offsetx = 0,
    offsety = 0
  }

  setmetatable(o, self)
  self.__index = self
  return o
end

function gold:update(dt)
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

function gold:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(
  self.spriteSheet,
  self.currAnim[self.currFrame],
  self.x,
  self.y,
  self.rot,
  self.scalex,
  self.scaley,
  self.offsetx,
  self.offsety
  )
end


return gold
