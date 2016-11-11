--objects
local player = require("player")
local Pickup = require("pickup")
local Storm = require("storm")

--assets
local background = love.graphics.newImage("assets/sky.png")
local font = love.graphics.newFont("assets/sitka-small-bold.ttf",76)

--gamestate
local gamestate = "play"

--constants
local winWidth = love.graphics.getWidth()
local winHeight = love.graphics.getHeight()
local playerW = 150
local playerH = 150
local playerX = winWidth/2
local playerY = winHeight/2
local playerSpeedX = 0
local playerSpeedY = 0
local spawnW = 125
local spawnH = 125
local push = 500
local drag = 100
local timePickup = 0
local timeStorm = 0

function genPickupNum(player)
  diff = 10 - player.number

  if diff > 0 then
    number = math.random(5)
  else
    number = math.random(-5,-1)
  end

  return number
end

function genStormNum(player)
  diff = 10 - player.number
  if diff > 0 then
    number = math.random(-5,-1)
  else
    number = math.random(5)
  end
  return number
end

function timePassedPickup(dt,time)
  timePickup = timePickup + dt
  if timePickup > time then
    timePickup = 0
    return true
  else
    return false
  end
end

function timePassedStorm(dt,time)
  timeStorm = timeStorm + dt
  if timeStorm > time then
    timeStorm = 0
    return true
  else
    return false
  end
end

function newSpawn(player)
  sides = {
    {x = -spawnW, y = math.random(winHeight)}, --left
    {x = winWidth, y = math.random(winHeight)}, --right
    {x = math.random(winWidth), y = -spawnH},  --top
    {x = math.random(winWidth), y = winHeight}  --bottom
  }

  side = math.random(1,4)

  x = sides[side].x
  y = sides[side].y

  firstbound = {
    -90*y/winHeight,
    90 + 90*y/winHeight,
    270 + 90*x/winWidth,
    90 + 90*x/winWidth
  }

  bound1 = firstbound[side]
  bound2 = bound1 + 90

  angDeg = math.random(bound1,bound2)
  ang = angDeg*math.pi/180

  operation = {
    {x = math.cos(ang), y = math.sin(ang)},
    {x = math.cos(ang), y = math.sin(ang)},
    {x = math.sin(ang), y = math.cos(ang)},
    {x = math.sin(ang), y = math.cos(ang)}
  }

  dirx = operation[side].x
  diry = operation[side].y

  spawnspeed = math.random(100,200)

  return x, y, dirx, diry, spawnspeed
end

--checks for any overlap between two boxes. Returns true if there is
function checkCollision(box1, box2)
  return box1.x < box2.x + box2.w and
         box2.x < box1.x + box1.w and
         box1.y < box2.y + box2.h and
         box2.y < box1.y + box1.h
end

function checkSpawn(spawn,player)
  if player.control then
  for i,Spawn in ipairs(spawn) do
    if checkCollision(player.collBox,Spawn.collBox) then
      player.number = player.number + Spawn.number
      table.remove(spawn, i)
    end
  end
  end
end

function love.load()
  player = player:new(playerX, playerY, playerW, playerH, playerSpeedX, playerSpeedY, push, drag, 0)
  math.randomseed(os.time())
  pickups = {}
  storms = {}
end

function love.update(dt)
  player:update(dt)

  if timePassedPickup(dt,2) then
    x, y, dirx, diry, spawnspeed = newSpawn(player)
    newPickup = Pickup:new(x, y, dirx, diry, spawnspeed, genPickupNum(player))
    table.insert(pickups, newPickup)
  end
  if timePassedStorm(dt,1) then
    x, y, dirx, diry, spawnspeed = newSpawn(player)
    newStorm = Storm:new(x, y, dirx, diry, spawnspeed, genStormNum(player))
    table.insert(storms, newStorm)
  end

  for i,PickUp in ipairs(pickups) do
    PickUp:update(dt)
  end
  for i,Storm in ipairs(storms) do
    Storm:update(dt)
  end

  if #pickups > 50 then
    table.remove(pickups, 1)
  end
  checkSpawn(pickups,player)
  checkSpawn(storms,player)

  if player.number == 10 then
    gamestate = "won"
    player.control = false
  end

  if love.keyboard.isDown("escape") then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(background)

  for i,PickUp in ipairs(pickups) do
    PickUp:draw()
  end
  for i,Storm in ipairs(storms) do
    Storm:draw()
  end

  player:draw()

  if gamestate == "won" then
    victory = "You got to 10!"
    txtHeight = font:getHeight(victory)

    love.graphics.setFont(font)
    love.graphics.printf( victory, winWidth/2-400, winHeight/2-txtHeight/2, 800, "center")
  end
end
