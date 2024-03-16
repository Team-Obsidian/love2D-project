io.stdout:setvbuf("no")



function love.load()
    --[[
   image = love.graphics.newImage("cake.jpg")
   love.graphics.setNewFont(12)
   love.graphics.setColor(0,0,0)
   love.graphics.setBackgroundColor(255,255,255)
   --]]
   --testVarNum = 0

   player = {}
   player.xPos = 100
   player.deltaX = 0
   player.yPos = 100
   player.deltaY = 0
   player.width = 50
   player.height = 50
   player.onGround = true

   wallBuffer = 5
   print('hahaha')

   --going to depricate once testing is over
   player.speed = 100


   enemy = {}
   enemy.xPos = 0
   enemy.deltaX = 0
   enemy.yPos = 400
   enemy.deltaY = 0
   enemy.width = 600
   enemy.height = 50
   enemy.onGround = false
   enemy.speed = 100


   wallObjects = {}
end

function makeWallRect(xPos, yPos, width, height)
    local rect = {}
    rect.xPos = xPos or 0
    rect.yPos = yPos or 0
    rect.width = width or 200
    rect.height = height or 100
    table.insert(wallObjects, rect)
end

function setWallProp(properties)
    local wall = {}
    --set xPos or default to 0
    if properties.xPos ~= nil then
        wall.xPos = properties.xPos
    else
        wall.xPos = 0
        print('no xPos set, default')
    end
    --set yPos or default to 0
    if properties.yPos ~= nil then
        wall.yPos = properties.yPos
    else
        wall.yPos = 0
        print('no yPos set, default')
    end
    --set width or default to 200
    if properties.width ~= nil then
        wall.width = properties.width
    else
        wall.width = 200
        print('no width set, default')
    end
    --set height or default to 300
        if properties.height ~= nil then
        wall.height = properties.height
    else
        wall.height = 300
        print('no height set, default')
    end
    return wall
end

function doesCollideRect(object1, object2)
    local collides = 0
        --print('start of doesCollideRect: '.. testVarNum)
        --testVarNum = testVarNum + 1
    --if x values intersect
    if (object1.xPos + object1.width) > object2.xPos and (object1.xPos < object2.xPos + object2.width) then
        --print('object1 xCollide with object2')
        collides = collides + 1
    end

    --if y values intersect
    if (object1.yPos + object1.height) > object2.yPos and (object1.yPos < object2.yPos + object2.height) then
        --print('object1 yCollide with object2')
        collides = collides + 1
    end

    --if both collided
    if collides == 2 then
       -- print('end of doesCollideRect, TRUE')
        return true
    else
        --print('end of doesCollideRect, FALSE')
        return false
    end

end


function willCollide(object1, object2)
    local collides = {}
        --print('start of doesCollideRect: '.. testVarNum)
        --testVarNum = testVarNum + 1

    --check if object1 is at a vertical position to hit horizontally
    if (object1.yPos + object1.height) > object2.yPos and (object1.yPos < object2.yPos + object2.height) then


        --if object1 left passes object2 right and object1 right is still right of object2 right
        if (object1.xPos + player.deltaX < object2.xPos + object2.width) and object1.xPos + object1.width > object2.xPos + object2.width - wallBuffer then
            collides.left = true
        else
            collides.left = false
        end

        --if object1 right passes object2 left and object1 left is still left of object2 right
        if (object1.xPos + object1.width + player.deltaX) > object2.xPos and object1.xPos < object2.xPos + wallBuffer then
            collides.right = true
        else
            collides.right = false
        end

    else
            collides.left = false
            collides.right = false
    end

    --check if object1 is at a horizontal position to hit vertically
    if (object1.xPos + object1.width) > object2.xPos and (object1.xPos < object2.xPos + object2.width) then
       
        --if object1 top hits object2 bottom
        if (object1.yPos + object1.deltaY) < object2.yPos + object2.height and object1.yPos + object1.height > object2.yPos + object2.height - wallBuffer then
            collides.top = true
        else
            collides.top = false
        end

        --if object1 bottom hits object2 top
        if object1.yPos + object1.height + object1.deltaY > object2.yPos and object1.yPos < object2.yPos + wallBuffer  then
            collides.bottom = true
        else
            collides.bottom = false
        end

    else
            collides.top = false
            collides.bottom = false
    end

    --collides should be {['left']=true,['right']=true,['top']=true,['bottom']=true} when inside of object 2
    return collides
end



function love.update(dTime)

    if player.deltaX ~= 0 then
        player.deltaX = player.deltaX*0.80
   end



    if player.onGround == false then
        if willCollide(player, enemy).bottom and player.yPos + player.height < (enemy.yPos + wallBuffer) then
            player.deltaY = 0
            player.yPos = enemy.yPos - player.height
            player.onGround = true
        else
            player.deltaY = player.deltaY + 50*dTime
        end
    end




    if player.deltaY ~= 0 then
        player.deltaY = player.deltaY*0.80
   end



--[[
    if doesCollideRect(player, enemy) == true then
        --print("player is on ground")
        player.onGround = true
    else
    end
--]]


--extra syntax after the willCollide stuff is because willCollide only checks for if it's past the edge, not whether it's still within the object
    if love.keyboard.isDown('right') and math.abs(player.deltaX) < 150 then
        player.deltaX = player.deltaX + 50*dTime
    --else
    --    player.deltaX = player.deltaX - 10
        if willCollide(player, enemy).right then
            player.deltaX = 0
            player.xPos = enemy.xPos - player.width
        end
    end
    if love.keyboard.isDown('left') and math.abs(player.deltaX) < 150 then
        player.deltaX = player.deltaX - 50*dTime
   --else
   --     player.deltaX = player.deltaX - 10

        --if player is just right of the wall's right side and player is no more than 5 pixels into the object (which means boundary breaking can happen?) 
        if willCollide(player, enemy).left then
            --player stops moving horizontally
            player.deltaX = 0
            --player snaps to wall
            player.xPos = enemy.xPos + enemy.width
        end
    end




    --will reconfigure to jump thing later, acts like top-down for now
    if love.keyboard.isDown('down') then
        if math.abs(player.deltaY) < 100 then
            player.deltaY = player.deltaY + 50*dTime
        end

        if willCollide(player, enemy).bottom then
            player.deltaY = 0
            player.yPos = enemy.yPos - player.height
        end
    end
    if love.keyboard.isDown('up') then
        if math.abs(player.deltaY) < 100 then
        player.deltaY = player.deltaY - 50*dTime
        end

        if willCollide(player, enemy).top then
            player.deltaY = 0
            player.yPos = enemy.yPos + enemy.height
        end
    end

    if love.keyboard.isDown('space') and player.onGround then
        player.deltaY = player.deltaY - 1500*dTime
        player.onGround = false
    end
-- bad version of movement without momentum, test collision only

--[[
    local playerCollides = doesCollideRect(player, enemy)
    if not playerCollides then
        if love.keyboard.isDown('right') then
            if player.xPos + player.width + player.speed * dTime < enemy.xPos  then
                player.xPos = player.xPos + player.speed * dTime
            end
        end
        if love.keyboard.isDown('left') then
            player.xPos = player.xPos - player.speed * dTime
        end
        if love.keyboard.isDown('down') then
            player.yPos = player.yPos + player.speed * dTime
        end
        if love.keyboard.isDown('up') then
            player.yPos = player.yPos - player.speed * dTime
        end
    else
        print('can\'t move')
    end
--]]

    if love.keyboard.isDown('d') then
        enemy.xPos = enemy.xPos + enemy.speed * dTime
    end
    if love.keyboard.isDown('a') then
        enemy.xPos = enemy.xPos - enemy.speed * dTime
    end
    if love.keyboard.isDown('s') then
        enemy.yPos = enemy.yPos + enemy.speed * dTime
    end
    if love.keyboard.isDown('w') then
        enemy.yPos = enemy.yPos - enemy.speed * dTime
    end





    player.xPos = player.xPos + player.deltaX

    --if player.onGround == false then
    player.yPos = player.yPos + player.deltaY
    --else
     --   player.deltaY = 0
    --end

end

function love.draw()
   --[[
   love.graphics.draw(image, imgx, imgy)
   love.graphics.print("Click and drag the cake around or use the arrow keys", 10, 10)
   --]]
   --makeWallRect(0,400,400,200)
    for i,v in ipairs(wallObjects) do
        love.graphics.rectangle('line',v.xPos,v.yPos,v.width,v.height)
    end

    love.graphics.setColor(0.8, 0.1, 0, 0.5)
    love.graphics.rectangle("fill", player.xPos, player.yPos, player.width, player.height)

    love.graphics.setColor(0.1, 0, 0.8, 0.5)
    love.graphics.rectangle("fill", enemy.xPos, enemy.yPos, enemy.width, enemy.height)
end


function love.mousepressed(x, y, button, istouch)
  --[[if button == 1 then
      imgx = x -- move image to where mouse clicked
      imgy = y
   end
   --]]
    table.insert(wallObjects, setWallProp{xPos=x,yPos=y,width=130})
    print('x is ' .. x .. ', y is ' .. y)
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

    if key=='t' then
        print('left is: '..tostring(willCollide(player,enemy).left).. ' right is: '..tostring(willCollide(player, enemy).right))
        --table.insert(wallObjects, setWallProp{xPos=400,yPos=0,width=130,height=100})
    end

    if key=='p' then
        print('player.onGround is: '.. tostring(player.onGround))
    end

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


