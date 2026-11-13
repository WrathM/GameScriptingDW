--game where cabal fall from top player clicks
--before hit the bottom
--game ends when cabal hits bottom
if arg[2] == "debug" then
    require("lldebugger").start()
end
function love.load()
  chickenFace = love.graphics.newImage("chicken.png")
  powerupImage = love.graphics.newImage("powerup.png")
  backgroundImage = love.graphics.newImage("bg.png")
  powerupActive = false
  powerupTimer = 0
  powerupVisible = false
  powerupX = 0
  powerupY = 0
  spawnTimer = 0

  math.randomseed(os.time())
  math.random(); math.random(); math.random()
  
  startx = {
    math.random(0, love.graphics.getWidth() - chickenFace:getWidth()), 
    math.random(0, love.graphics.getWidth() - chickenFace:getWidth()),  
    math.random(0, love.graphics.getWidth() - chickenFace:getWidth()),  
    math.random(0, love.graphics.getWidth() - chickenFace:getWidth()), 
    math.random(0, love.graphics.getWidth() - chickenFace:getWidth())
  }
  starty = {
    0 - math.random(chickenFace:getHeight(), chickenFace:getHeight() * 2),
    0 - math.random(chickenFace:getHeight(), chickenFace:getHeight() * 2),
    0 - math.random(chickenFace:getHeight(), chickenFace:getHeight() * 2),
    0 - math.random(chickenFace:getHeight(), chickenFace:getHeight() * 2),
    0 - math.random(chickenFace:getHeight(), chickenFace:getHeight() * 2)
  }
end
-------------------------------------------------
--MOUSE PRESS
--1 = left, 2 = right, 3 = middle wheel
-------------------------------------------------
function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    -- Check if a chicken was clicked
    for i, v in ipairs(startx) do
      if x >= startx[i] and x <= startx[i] + chickenFace:getWidth() and y >= starty[i] and y <= starty[i] + chickenFace:getHeight() then
        -- Reset both X and Y values
        startx[i] = math.random(0, love.graphics.getWidth() - chickenFace:getWidth())
        starty[i] = math.random(chickenFace:getHeight(), chickenFace:getHeight() * 2) * -1
      end
    end
    if powerupVisible then
      if x >= powerupX and x <= powerupX + powerupImage:getWidth() and y >= powerupY and y <= powerupY + powerupImage:getHeight() then
        powerupVisible = false -- Hide it until the next 10-second spawn
        powerupActive = true   -- Start the 3-second freeze
        powerupTimer = 3
      end
    end
  end
end
-------------------------------------------------
--UPDATE
-------------------------------------------------
function love.update(dt)
  if not powerupVisible and not powerupActive then
    spawnTimer = spawnTimer + dt
    if spawnTimer >= 10 then
      spawnTimer = 0
      powerupVisible = true
      local maxX = love.graphics.getWidth() - powerupImage:getWidth()
      local maxY = love.graphics.getHeight() - powerupImage:getHeight()
      powerupX = math.random(0, maxX)
      powerupY = math.random(0, maxY)
    end
  end
  -- Update the powerup timer
  if powerupActive then
    powerupTimer = powerupTimer - dt
    if powerupTimer <= 0 then
      powerupActive = false
      powerupTimer = 0
    end
  end

  for i, v in ipairs(starty) do
    -- If chicken hits the bottom of the screen, lua quits (we lose)
    if starty[i] + chickenFace:getHeight() >= love.graphics.getHeight() then
      love.event.quit()
    end
    if not powerupActive then
      -- Chickens move down
      starty[i] = starty[i] + 80 * dt
    end
  end
end
-------------------------------------------------
--DRAW
-------------------------------------------------
function love.draw()
  love.graphics.draw(backgroundImage, 0, 0)
  -- Draw each chicken at their respective x and y
  for i, v in ipairs(startx) do
    love.graphics.draw(chickenFace, startx[i], starty[i])
  end
  if powerupVisible then
    love.graphics.draw(powerupImage, powerupX, powerupY)
  end
end