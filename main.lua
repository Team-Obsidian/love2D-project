io.stdout:setvbuf("no")



function love.load()
    --[[
   image = love.graphics.newImage("cake.jpg")
   love.graphics.setNewFont(12)
   love.graphics.setColor(0,0,0)
   love.graphics.setBackgroundColor(255,255,255)
   --]]
   player = {}
   player.x = 100
   player.y = 100
   player.width = 50
   player.height = 50
   print('hahaha')
   player.speed = 100


   wallObjects = {}
end

function makeWallRect(xPos, yPos, width, height)
    rect = {}
    rect.x = xPos or 0
    rect.y = yPos or 0
    rect.width = width or 200
    rect.height = height or 100
    table.insert(wallObjects, rect)
end

function love.update(dTime)
    --[[
   if love.keyboard.isDown("up") then
      num = num + 100 * dt -- this would increment num by 100 per second
   end
   --]]
   
    if love.keyboard.isDown('right') then
        player.x = player.x + player.speed * dTime
    end
    if love.keyboard.isDown('left') then
        player.x = player.x - player.speed * dTime
    end
    if love.keyboard.isDown('down') then
        player.y = player.y + player.speed * dTime
    end
    if love.keyboard.isDown('up') then
        player.y = player.y - player.speed * dTime
    end

end

function love.draw()
   --[[
   love.graphics.draw(image, imgx, imgy)
   love.graphics.print("Click and drag the cake around or use the arrow keys", 10, 10)
   --]]
    for i,v in ipairs(wallObjects) do
        love.graphics.rectangle('line',v.x,v.y,v.width,v.height)
    end
    love.graphics.rectangle("line", player.x, player.y, player.width, player.height)
end


function love.mousepressed(x, y, button, istouch)
  --[[if button == 1 then
      imgx = x -- move image to where mouse clicked
      imgy = y
   end
   --]]
   makeWallRect(x,y)
end

function love.mousereleased(x, y, button, istouch)
   --[[if button == 1 then
      imgx = x -- move image to where mouse clicked
      imgy = y
   end
   --]]
end

function love.keypressed(key)
    --[[
   if key == 'b' then
      text = "The B key was pressed."
   elseif key == 'a' then
      a_down = true
   end
   --]]


    --[[if key == 'right' then
        x = x + 5
    end--]]

end

function love.keyreleased(key)
    --[[
   if key == 'b' then
      text = "The B key was pressed."
   elseif key == 'a' then
      a_down = true
   end
   --]]
end

function love.focus(f)
  if not f then
    print("LOST FOCUS")
  else
    print("GAINED FOCUS")
  end
end

function love.quit()
  print("Thanks for playing gamers! See ya!")
end


