--objects
local player = require("player")
local Pickup = require("pickup")
local Storm = require("storm")
local Gold = require("gold")
local Bckcloud = require("bckcloud")
local Clicktoplay = require("clicktoPlay")

--assets
local background = love.graphics.newImage("assets/sky.png")
local splash = love.graphics.newImage("assets/Splash.png")
local wintext = love.graphics.newImage("assets/youwinfont.png")
local toohightext = love.graphics.newImage("assets/toohighfont.png")
local toolowtext = love.graphics.newImage("assets/toolowfont.png")
local playagaintext = love.graphics.newImage("assets/playagainfont.png")

local font = love.graphics.newFont("assets/sitka-small-bold.ttf",60)

--gamestate
local gamestate = "title"

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

--variables
local timePickup = 0
local timeStorm = 0
local timeGold = 0
local spawnStormTimer = 0
local canSpawnStorm = true

function Restart(player,pickups,storms,goldclouds)
  player.x = winWidth/2
  player.y = winHeight/2
  player.ux = 0
  player.uy = 0
  player.number = 0
  player.control = true

  for k in pairs(pickups) do
    pickups[k] = nil end

  for k in pairs(storms) do
    storms[k] = nil end

  for k in pairs(goldclouds) do
    goldclouds[k] = nil end

  timePickup = 0
  timeStorm = 0
  timeGold = 0
  spawnStormTimer = 0
  canSpawnStorm = true
end

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

function timePassedGold(dt,time)
  timeGold = timeGold + dt
  if timeGold > time then
    timeGold = 0
    return true
  else
    return false
  end
end

function goldStormTimer(dt,time)
  spawnStormTimer = spawnStormTimer + dt
  if spawnStormTimer > time then
    spawnStormTimer = 0
    return true
  else
    return false
  end
end

function newSpawn()
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

  return x, y, dirx, diry
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

function checkGoldSpawn()
  roll = math.random(5)
  if roll == 1 then
    return true
  else
    return false
  end
end

function goldCollide(storms, goldclouds, player)
  if player.control then
    for i,Gold in ipairs(goldclouds) do
      if checkCollision(player.collBox, Gold.collBox) then
        canSpawnStorm = false
        for k in pairs(storms) do
          storms[k] = nil
        end
        table.remove(goldclouds, i)
      end
    end
  end
end

function love.load()
  player = player:new(playerX, playerY, playerW, playerH, playerSpeedX, playerSpeedY, push, drag, 0)
  math.randomseed(os.time())
  pickups = {}
  storms = {}
  goldclouds = {}
  bckclouds = {Bckcloud:new(300,50,0.75,4),Bckcloud:new(750,55,0.8,10),Bckcloud:new(75,60,0.85,2),
               Bckcloud:new(150,200,0.9,8), Bckcloud:new(700,300,1,5),Bckcloud:new(-100,375,1.1,12),
               Bckcloud:new(400,400,1.15,3), Bckcloud:new(750,520,1.2,15), Bckcloud:new(65, 625, 1.25,6)}
  clicktoplay = Clicktoplay:new()
end

function love.mousepressed( x, y, button, istouch )
   if button == 1 then
     if gamestate == "won" or gamestate == "lost" then
       gamestate = "play"
       Restart(player,pickups,storms,goldclouds)
     end
   end
end

function love.update(dt)
  for i,BckCloud in ipairs(bckclouds) do
    BckCloud:update(dt)
  end

  if gamestate == "title" then
    if love.mouse.isDown(1) then
      gamestate = "play"
    end
    clicktoplay:update(dt)
  end

  if gamestate == "play" or gamestate == "won" or gamestate == "lost" then
  player:update(dt)

  if timePassedPickup(dt,2) then
    x, y, dirx, diry = newSpawn()
    newPickup = Pickup:new(x, y, dirx, diry, genPickupNum(player))
    table.insert(pickups, newPickup)
  end
  if timePassedStorm(dt,0.5) and canSpawnStorm then
    x, y, dirx, diry = newSpawn()
    newStorm = Storm:new(x, y, dirx, diry, genStormNum(player))
    table.insert(storms, newStorm)
  end
  if timePassedGold(dt,5) and canSpawnStorm then
    if checkGoldSpawn() then
      x, y, dirx, diry = newSpawn()
      newGold = Gold:new(x, y, dirx, diry)
      table.insert(goldclouds, newGold)
    end
  end

  if canSpawnStorm == false then
    if goldStormTimer(dt,10) then
      canSpawnStorm = true
    end
  end


  for i,PickUp in ipairs(pickups) do
    PickUp:update(dt)
  end
  for i,Storm in ipairs(storms) do
    Storm:update(dt)
    --ensures that storm clouds automatically change to be disadvantageous to the player
    if player.number > 10 then
      if Storm.number < 0 then
        Storm.number = -Storm.number
      end
    else
      if Storm.number > 0 then
        Storm.number = -Storm.number
      end
    end
  end
  for i,Gold in ipairs(goldclouds) do
    Gold:update(dt)
  end

  if #pickups > 50 then
    table.remove(pickups, 1)
  end
  if #storms > 50 then
    table.remove(storms, 1)
  end
  if #goldclouds > 50 then
    table.remove(goldclouds, 1)
  end

  checkSpawn(pickups,player)
  checkSpawn(storms,player)
  goldCollide(storms,goldclouds,player)

  if player.number == 10 then
    gamestate = "won"
    player.control = false
  elseif player.number <= -20 or player.number >= 30 then
    gamestate = "lost"
    player.control = false
  end

  end

  if love.keyboard.isDown("escape") then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(background)
  for i,BckCloud in ipairs(bckclouds) do
    BckCloud:draw()
  end
  love.graphics.setColor(255,255,255)
  if gamestate == "title" then
    love.graphics.draw(splash, 20, 0, 0, 0.65, 0.65)
    clicktoplay:draw()
  end

  if gamestate == "play" or gamestate == "won" or gamestate == "lost" then
  for i,PickUp in ipairs(pickups) do
    PickUp:draw()
  end
  for i,Storm in ipairs(storms) do
    Storm:draw()
  end
  for i,Gold in ipairs(goldclouds) do
    Gold:draw()
  end

  player:draw()
  end
  love.graphics.setColor(255,255,255)
  if gamestate == "won" then
    love.graphics.draw(wintext, 200, 200)
    love.graphics.draw(playagaintext, 200, 450)
  end
  if gamestate == "lost" then
    if player.number < 0 then
      love.graphics.draw(toolowtext, 200, 200)
    else
      love.graphics.draw(toohightext, 200, 200)
    end
    love.graphics.draw(playagaintext, 200, 450)
  end

end
