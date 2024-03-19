io.stdout:setvbuf("no")



function love.load()
    --love.window.setMode(800, 600, {resizable=false, vsync=0})

    level = {x=1,y=1}
    --[[
   image = love.graphics.newImage("cake.jpg")
   love.graphics.setNewFont(12)
   love.graphics.setColor(0,0,0)
   love.graphics.setBackgroundColor(255,255,255)
   --]]
   --testVarNum = 0
   wallBuffer = 3
   maxVelocity = 300

   --gravity stuff (https://2dengine.com/doc/platformers.html)

   jumpHeight = 800
   --generic number, needs deltaTime to work properly
   timeToApex = 60

 
   player = {}
   player.xPos = 100
   player.deltaX = 0
   player.yPos = 100
   player.deltaY = 0
   player.width = 50
   player.height = 50
   player.onGround = true
   player.loop = false


   print('hahaha')

   --going to depricate once testing is over
   player.speed = 100

--[[ enemy is no longer needed
   enemy = {}
   enemy.xPos = 0
   enemy.deltaX = 0
   enemy.yPos = 400
   enemy.deltaY = 0
   enemy.width = 600
   enemy.height = 50
   enemy.onGround = false
   enemy.speed = 100
]]--

   wallObjects = {}

       function makeWallRect(param)
        local rect = {}
        rect.xPos = param.xPos or 0
        rect.yPos = param.yPos or 0
        rect.width = param.width or 200
        rect.height = param.height or 100
        rect.level = param.level or 1
        rect.returns = param.returns or false
        if param.returns then
            return rect
        else
            table.insert(wallObjects, rect)
        end
        --return rectangle instead of automatically inserting it into current level objects
        --return rect
    end

    function loadLevel(levelNum)
        wallObjects = {}
        if levelNum.y == 1 then
            if levelNum.x == 1 then
                makeWallRect{xPos=-50,yPos=400,width=900,height=300}
            elseif levelNum.x == 2 then
                makeWallRect{xPos=-50,yPos=400,width=200,height=300}
                makeWallRect{xPos=500,yPos=300,width=350,height= 100}
            end
        else
            level.x = 1
            level.y = 1
            loadLevel(level)
        end
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

    loadLevel(level)
end





function love.update(dTime)

--gravity is hard
--[[
    timeToApex = 6000*dTime
    gravity = (2*jumpHeight)/timeToApex^2
    initialJumpVelocity = -math.sqrt(2*gravity*jumpHeight)
--]]

    if player.deltaX ~= 0 then
        player.deltaX = player.deltaX*0.80
   end

    if player.deltaY ~= 0 then
        player.deltaY = player.deltaY*0.970
   end

       -- ~~~falling~~~
    if player.onGround == false then
            player.deltaY = player.deltaY + 20*dTime
    end

--[[
    if doesCollideRect(player, enemy) == true then
        --print("player is on ground")
        player.onGround = true
    else
    end
--]]


--extra syntax after the willCollide stuff is because willCollide only checks for if it's past the edge, not whether it's still within the object
    local canLand = false
    
    for key, value in pairs(wallObjects) do    
        if willCollide(player, value).right then
            player.deltaX = 0
            player.xPos = value.xPos - player.width
        end

        if willCollide(player, value).left then
            --player stops moving horizontally
            player.deltaX = 0
            --player snaps to wall
            player.xPos = value.xPos + value.width
        end

        if willCollide(player, value).bottom then
            player.deltaY = 0
            player.yPos = value.yPos - player.height
            canLand = true
        end

        if willCollide(player, value).top then
            player.deltaY = 0
            player.yPos = value.yPos + value.height
        end


    end

    if canLand then
        player.onGround = true
    else
        player.onGround = false
    end

    if love.keyboard.isDown('right') and math.abs(player.deltaX) < 150 then
    player.deltaX = player.deltaX + 50*dTime
--else
--    player.deltaX = player.deltaX - 10
    end

    if love.keyboard.isDown('left') and math.abs(player.deltaX) < 150 then
        player.deltaX = player.deltaX - 50*dTime
--else
--     player.deltaX = player.deltaX - 10

    --if player is just right of the wall's right side and player is no more than 5 pixels into the object (which means boundary breaking can happen?) 
    end




    --will reconfigure to jump thing later, acts like top-down for now
    if love.keyboard.isDown('down') and player.deltaY == 0 and not player.onGround then
        if math.abs(player.deltaY) < 100 then
            player.deltaY = player.deltaY + 50*dTime
        end
    end

    if love.keyboard.isDown('up') then
        if math.abs(player.deltaY) < 100 then
            player.deltaY = player.deltaY - 50*dTime
        end
    end

    if love.keyboard.isDown('space') and player.onGround then
        player.deltaY = -jumpHeight*dTime
        player.onGround = false
    end
-- bad version of movement without momentum, test collision only
    




--enemy object no longer needed
--[[
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
--]]


    if player.deltaY > maxVelocity then
        player.deltaY = maxVelocity
    end
    if player.deltaX > maxVelocity then
        player.deltaX = maxVelocity
    end


    player.xPos = player.xPos + player.deltaX

    --if player.onGround == false then
    player.deltaY = math.floor(player.deltaY*10)/10
    player.yPos = player.yPos + player.deltaY
    --else
     --   player.deltaY = 0
    --end

    --make player loop around to top after hitting bottom
    if player.yPos > 600 and player.deltaY > 0 then
        if not player.loop then    
            level.y = level.y - 1
            loadLevel(level)
        end
        player.yPos = -player.height
    end
    if player.xPos > 800 and player.deltaX > 0 then
        player.xPos = -player.width
        level.x = level.x + 1
        loadLevel(level)
    end

    if player.yPos + player.height < 0 and player.deltaY < 0 then
        if not player.loop then
            level.y = level.y + 1
            loadLevel(level)
        end
        player.yPos = 600
    end
    if player.xPos + player.width < 0 and player.deltaX < 0 then
        player.xPos = 800
        level.x = level.x - 1
        loadLevel(level)
    end

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

    love.graphics.setColor(0.1, 0, 0.8, 0.8)
end


function love.mousepressed(x, y, button, istouch)
  --[[if button == 1 then
      imgx = x -- move image to where mouse clicked
      imgy = y
   end
   --]]
    makeWallRect{xPos=x,yPos=y,width=130}
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
    if key == 'l' then
        player.loop = not player.loop
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
    if key == 't' then
        print('player.onGround: '..tostring(player.onGround))
    end
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


