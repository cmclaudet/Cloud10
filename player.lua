player = {}

function player:new(x,y,w,h,ux,uy,push,drag,number)
  playerImage = love.graphics.newImage("assets/playerspritesheet.png")
  fontPlayer = love.graphics.newFont("assets/sitka-small-bold.ttf",45)

  collOffX = -33
  collOffY = -25
  collBoxW = 60
  collBoxH = 40

  animations = {
    idle = {
      love.graphics.newQuad(0, 0, 150, 150, playerImage:getDimensions()),
      love.graphics.newQuad(150, 0, 150, 150, playerImage:getDimensions()),
      love.graphics.newQuad(300, 0, 150, 150, playerImage:getDimensions()),
      love.graphics.newQuad(450, 0, 150, 150, playerImage:getDimensions()),
      love.graphics.newQuad(600, 0, 150, 150, playerImage:getDimensions()),
      love.graphics.newQuad(450, 0, 150, 150, playerImage:getDimensions()),
      love.graphics.newQuad(300, 0, 150, 150, playerImage:getDimensions()),
      love.graphics.newQuad(150, 0, 150, 150, playerImage:getDimensions())
    }
  }

  numPositions = {
    x = {-1,0,1,0,-1,0,1,0},
    y = {0,0,0,0,0,0,0,0}
  }

  o = {
    spriteSheet = playerImage,
    animations = animations,
    currAnim = animations.idle,
    currFrame = 1,
    elapsedTime = 0,
    frameDuration = 0.1,
    font = fontPlayer,

    x = x,
    y = y,
    w = w,
    h = h,
    ux = ux,
    uy = uy,
    push = push,
    drag = drag,
    number = number,
    numPositions = numPositions,

    collOffX = collOffX,
    collOffY = collOffY,
    collBoxW = collBoxW,
    collBoxH = collBoxH,

    collBox = {
      x = x + collOffX,
      y = y + collOffY,
      w = collBoxW,
      h = collBoxH
    },

    rot = 0,
    scalex = 0.75,
    scaley = 0.75,
    offsetx = 75,
    offsety = 75,

    control = true
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function player:update(dt)
  winWidth = love.graphics.getWidth()
  winHeight = love.graphics.getHeight()

  self.elapsedTime = self.elapsedTime + dt

  if self.elapsedTime >= self.frameDuration then
    if self.currFrame < #self.currAnim then
      self.currFrame = self.currFrame + 1
    else
      self.currFrame = 1
    end
    self.elapsedTime = 0
  end

  if love.mouse.isDown(1) then
    mouseX, mouseY = love.mouse.getPosition()
    xdiff = mouseX - self.x --direction of force must be toward mouse position
    ydiff = mouseY - self.y
    accX = self.push*xdiff/((xdiff^2+ydiff^2)^0.5)  --normalising acceleration
    accY = self.push*ydiff/((xdiff^2+ydiff^2)^0.5)
  else
    accX = 0
    accY = 0
  end

  --magnitude of the velocity
  magu = (self.ux^2 + self.uy^2)^0.5
  --if velocity hits zero drag force should be zero
  if magu <= 0 then
    drag = 0
    dragAccX = 0
    dragAccY = 0
  --otherwise add drag in player's current motion
  else
    drag = self.drag  --less than mouse click force so player still goes forwards
    dragAccX = drag*self.ux/magu  --must be normalised
    dragAccY = drag*self.uy/magu
  end

  if self.x - 75 < -20 or self.x + 75 > winWidth + 20 then
    self.ux = -self.ux
  end
  if self.y - 75 < -20 or self.y + 75 > winHeight + 20 then
    self.uy = -self.uy
  end

  --using mechanics eqns find change of distance in both directions due to mouse force and drag
  dx = self.ux*dt + 0.5*(accX - dragAccX)*(dt^2)
  dy = self.uy*dt + 0.5*(accY - dragAccY)*(dt^2)

  --find change in velocity in both directions
  vx = self.ux + (accX - dragAccX)*dt
  vy = self.uy + (accY - dragAccY)*dt

  if self.control then
  --update both position and veolcity
  self.x = self.x + dx
  self.y = self.y + dy
  self.ux = vx
  self.uy = vy

  --update collision box coordinates
  self.collBox.x = self.x + self.collOffX
  self.collBox.y = self.y + self.collOffY
  end
end

function player:draw()
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

  love.graphics.setFont(self.font)
  love.graphics.setColor(27,61,80)
--  love.graphics.setColor(30,30,30)

  noWidth = self.font:getWidth(tostring(self.number))
  noHeight = self.font:getHeight(tostring(self.number))
  numX = self.x-noWidth/2-3
  numY = self.y-noHeight/2-12

  love.graphics.print(
  tostring(self.number),
  numX + self.numPositions.x[self.currFrame],
  numY + self.numPositions.y[self.currFrame]
  )
end

return player
