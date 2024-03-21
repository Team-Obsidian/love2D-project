io.stdout:setvbuf("no")



function love.load()
    screenWidth = 1024
    screenHeight = 576
    love.window.setMode(screenWidth, screenHeight)
    tile = love.graphics.newImage('floor-tile.png')
    --love.window.setMode(800, 600, {resizable=false, vsync=0})

    level = {x=1,y=1}
    --[[
   image = love.graphics.newImage("cake.jpg")
   love.graphics.setNewFont(12)
   love.graphics.setColor(0,0,0)
   love.graphics.setBackgroundColor(255,255,255)
   --]]
   --testVarNum = 0
   wallBuffer = 2
   maxVelocity = 300

   --gravity stuff (https://2dengine.com/doc/platformers.html)

   jumpHeight = 600
   --generic number, needs deltaTime to work properly
   timeToApex = 60

 
   player = {}
   player.xPos = 100
   player.deltaX = 0
   player.yPos = 100
   player.deltaY = 0
   player.width = 25
   player.height = 30
   player.onGround = true
   player.loop = false
   --0 is do nothing, 1 is death/reset, 2 is loadlevel
   player.boundary = {up=0,down=0,left=0,right=0}
   player.respawn = {x=500,y=300}
   player.canDash = true
   player.isDashing = false
   player.direction = 'r'
   player.dashSpeed = 600
   player.dashTime = {current=800,max=800}



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
   collectObjects = {}
   collectedObjects = {}
   score = 0

    function makeWallRect(param)
        local rect = {}
        rect.xPos = param.xPos or 0
        rect.yPos = param.yPos or 0
        rect.width = param.width or 200
        rect.height = param.height or 100
        rect.level = param.level or 1
        rect.visible = param.visible or true
        rect.returns = param.returns or false
        if param.returns then
            return rect
        else
            table.insert(wallObjects, rect)
        end
    end

    function makeCollectable(param)
        local rect = {}
        rect.width = param.width or 20
        rect.height = param.height or 20
        rect.xPos = param.xPos - rect.width / 2 or 400
        rect.yPos = param.yPos - rect.height/ 2 or 300
        rect.id = param.id or 0
        for key, value in pairs(collectedObjects) do
            print(value)
            if value == rect.id then
                print('collectable id: '.. rect.id .. ' has already been collected')
                return
            end    
        end
        rect.returns = param.returns or false
        if param.returns then
            return rect
        else
            table.insert(collectObjects, rect)
        end
    end

    function wallBlock(param)
        if param.up == true then
            makeWallRect{xPos=0,yPos=-wallBuffer,width=screenWidth,height=wallBuffer,visible=false}
        end
        if param.down == true then
            makeWallRect{xPos=0,yPos=screenHeight,width=screenWidth,height=wallBuffer,visible=false}
        end
        if param.left == true then
            makeWallRect{xPos=-wallBuffer,yPos=0,width=wallBuffer,height=screenHeight,visible=false}
        end
        if param.right == true then
            makeWallRect{xPos=screenWidth,yPos=0,width=wallBuffer,height=screenHeight,visible=false}
        end
    end

    --Need to make a text object to be rendered
    --level = {x=2,y=1}
    function loadLevel(levelNum)
        print('level is now : '..level.x..','..level.y)
        wallObjects = {}
        collectObjects = {}
        -- ~ Level Data ~
        if levelNum.y == 1 then
            if levelNum.x == 1 then
                wallBlock{up=true,left=true}
                makeWallRect{xPos=-50,yPos=400,width=screenWidth + 100,height=300}
                makeCollectable{xPos=screenWidth/2,yPos=screenHeight/2,id=1}
                player.respawn = {x=screenWidth/2,y=400}
                player.boundary = {up=0,down=1,left=1,right=2}
            elseif levelNum.x == 2 then
                love.graphics.print('Hold against the wall to wall jump after pressing Z', 500, 100)
                makeWallRect{xPos=-50,yPos=400,width=50,height=300}
                makeWallRect{xPos=0,yPos=500, width = screenWidth/2,height = 200}
                makeWallRect{xPos=screenWidth*2/3,yPos=200, width = screenWidth/3,height = 400}
                makeCollectable{xPos=screenWidth*2/3-20,yPos=screenHeight-25,id=2}
                player.boundary = {up=0,down=1,left=2,right=2}
                player.respawn = {x=100,y=450}
            elseif levelNum.x == 3 then
                makeWallRect{xPos=0,yPos=200,height=500,width=100}
                makeWallRect{xPos=250,yPos=0,height=300,width=100}
                makeWallRect{xPos=500,yPos=300,height=500,width=100}
                makeWallRect{xPos=600,yPos=500,height=100,width=500}
                makeCollectable{xPos=325,yPos=315,id=3}
                player.boundary = {up=0,down=1,left=2,right=2}
                player.respawn = {x=50,y=150}
            elseif levelNum.x == 4 then
            elseif levelNum.x == 5 then
                makeWallRect{xPos=-50,yPos=400,width=200,height=300}
                makeWallRect{xPos=500,yPos=300,width=350,height= 100}
                makeCollectable{xPos=500,yPos=200,id=2}
                player.respawn = {x=50,y=375}
                player.boundary = {up=0,down=1,left=2,right=2}
            elseif levelNum.x == 6 then
            elseif levelNum.x == 7 then
            elseif levelNum.x == 8 then
            else
                player.xPos = player.respawn.x
                player.yPos = player.respawn.y
            end
        else
            player.xPos = player.respawn.x
            player.yPos = player.respawn.y
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

    -- ~ dashing mechanics 1 (detection) ~
    if love.keyboard.isDown('x') and player.canDash and not player.isDashing then
        --print('player began dash')
        if love.keyboard.isDown('up') and love.keyboard.isDown('left') then
            player.direction = 'ul'

        elseif love.keyboard.isDown('up') and love.keyboard.isDown('right') then
            player.direction = 'ur'

        elseif love.keyboard.isDown('down') and love.keyboard.isDown('left') then
            player.direction = 'dl'

        elseif love.keyboard.isDown('down') and love.keyboard.isDown('right') then
            player.direction = 'dr'

        elseif love.keyboard.isDown('up') then
            player.direction = 'u'

        elseif love.keyboard.isDown('down') then
            player.direction = 'd'

        elseif love.keyboard.isDown('left') then
            player.direction = 'l'

        elseif love.keyboard.isDown('right') then
            player.direction = 'r'
        else
            --player.direction = player.direction
            --need a way to keep track of direction you're facing?
        end
        --print('current player.direction: '.. player.direction)
        player.isDashing = true
        player.canDash = false
    end

    -- ~ dashing mechanics 2 (movement/direction) ~
    if player.isDashing then 
        if player.direction == 'ul' then
            player.deltaX = -player.dashSpeed / math.sqrt(2) * dTime
            player.deltaY = -player.dashSpeed / math.sqrt(2) * dTime
        elseif player.direction == 'ur' then
            player.deltaX = player.dashSpeed / math.sqrt(2) *dTime
            player.deltaY = -player.dashSpeed / math.sqrt(2) *dTime
        elseif player.direction == 'dl' then
            player.deltaX = -player.dashSpeed / math.sqrt(2) * dTime
            player.deltaY = player.dashSpeed / math.sqrt(2) * dTime
        elseif player.direction == 'dr' then
            player.deltaX = player.dashSpeed / math.sqrt(2) * dTime
            player.deltaY = player.dashSpeed / math.sqrt(2) * dTime
        elseif player.direction == 'u' then
            player.deltaY = -player.dashSpeed *dTime
            player.deltaX = 0
        elseif player.direction == 'd' then
            player.deltaY = player.dashSpeed *dTime
            player.deltaX = 0
        elseif player.direction == 'l' then
            player.deltaX = -player.dashSpeed *dTime
            player.deltaY = 0
        elseif player.direction == 'r' then
            player.deltaX = player.dashSpeed *dTime
            player.deltaY = 0
        else
            print('nonsense player direction, '.. player.direction)
        end
        player.canDash = false
        player.dashTime.current = player.dashTime.current - 5000*dTime
        if player.dashTime.current < 0 then
            player.dashTime.current = player.dashTime.max
            player.isDashing = false
        end
        --print('player is still dashing')
    else

        --movement friction for controlled movement
        if player.deltaX ~= 0 then
            player.deltaX = player.deltaX*0.80
        end

        if player.deltaY ~= 0 then
            player.deltaY = player.deltaY*0.970
        end

           -- ~~~falling~~~
        if player.onGround == false then
                player.deltaY = player.deltaY + 20*dTime
        else
            player.canDash = true
        end

    --[[
        if doesCollideRect(player, enemy) == true then
            --print("player is on ground")
            player.onGround = true
        else
        end
    --]]




        --move right
        if love.keyboard.isDown('right') and math.abs(player.deltaX) < 150 then
            player.deltaX = player.deltaX + 50*dTime
            player.direction = 'r'
        end

        --move left
        if love.keyboard.isDown('left') and math.abs(player.deltaX) < 150 then
            player.deltaX = player.deltaX - 50*dTime
            player.direction = 'l'
        end

        --jump
        if love.keyboard.isDown('z') and player.onGround then
            player.deltaY = -jumpHeight*dTime
            player.onGround = false
        end




        --will reconfigure to jump thing later, acts like top-down for now



    --[[ unneeded because gravity
        
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
    --]]







        if player.deltaY > maxVelocity then
            player.deltaY = maxVelocity
        end
        if player.deltaX > maxVelocity then
            player.deltaX = maxVelocity
        end

        player.deltaY = math.floor(player.deltaY*10)/10
    end

        --extra syntax after the willCollide stuff is because willCollide only checks for if it's past the edge, not whether it's still within the object
    local canLand = false
    -- ~ Collision Boundary Stop Checks + Wall Jumping ~
    for key, value in pairs(wallObjects) do    
        if willCollide(player, value).right then
            player.deltaX = 0
            player.xPos = value.xPos - player.width

            if player.deltaY > 0 then
                if player.deltaY > 7 then
                    player.deltaY = player.deltaY - math.floor(500*dTime)/10
                elseif player.deltaY > 3 then
                    player.deltaY = player.deltaY - math.floor(300*dTime)/10
                else
                    player.deltaY = player.deltaY - math.floor(150*dTime)/10
                end
                if love.keyboard.isDown('z') and value.visible then
                    player.deltaY = -jumpHeight*dTime/1.2
                    player.deltaX = -jumpHeight*dTime*1.5
                    --player.onGround = false
                end                    
            end
        end

        if willCollide(player, value).left then
            --player stops moving horizontally
            player.deltaX = 0
            --player snaps to wall
            player.xPos = value.xPos + value.width

            if player.deltaY > 0 then
                if player.deltaY > 7 then
                    player.deltaY = player.deltaY - math.floor(500*dTime)/10
                elseif player.deltaY > 3 then
                    player.deltaY = player.deltaY - math.floor(300*dTime)/10
                else
                    player.deltaY = player.deltaY - math.floor(150*dTime)/10
                end
                if love.keyboard.isDown('z') and value.visible then
                    player.deltaY = -jumpHeight*dTime/1.2
                    player.deltaX = jumpHeight*dTime*1.5
                    --player.onGround = false
                end                    
            end
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

    for key, value in pairs(collectObjects) do    
        if doesCollideRect(player, value) then
            score = score + 1
            table.insert(collectedObjects, value.id, value.id)
            table.remove(collectObjects, key)
        end

    end

    if canLand then
        player.onGround = true
    else
        player.onGround = false
    end

    player.xPos = player.xPos + player.deltaX
    player.yPos = player.yPos + player.deltaY


    -- ~ level swap / screen wrap ~
    if player.yPos > screenHeight and player.deltaY > 0 then
        if player.boundary.down == 0 then

        elseif player.boundary.down == 1 then
            --insert player death here, make death function and some graphical effects
            player.xPos = player.respawn.x
            player.yPos = player.respawn.y
        elseif player.boundary.down == 2 then    
            level.y = level.y - 1
            loadLevel(level)
            player.yPos = -player.height
        end

    end
    if player.xPos > screenWidth and player.deltaX > 0 then
        if player.boundary.right == 0 then

        elseif player.boundary.right == 1 then
            --insert player death here, make death function and some graphical effects
            player.xPos = player.respawn.x
            player.yPos = player.respawn.y
        elseif player.boundary.right == 2 then    
            level.x = level.x + 1
            loadLevel(level)
            player.xPos = -player.width
        end

    end

    if player.yPos + player.height < 0 and player.deltaY < 0 then
        if player.boundary.up == 0 then

        elseif player.boundary.up == 1 then
            --insert player death here, make death function and some graphical effects
            player.xPos = player.respawn.x
            player.yPos = player.respawn.y
        elseif player.boundary.up == 2 then    
            level.y = level.y + 1
            loadLevel(level)
        player.yPos = screenHeight
        end

    end
    if player.xPos + player.width < 0 and player.deltaX < 0 then
        if player.boundary.left == 0 then

        elseif player.boundary.left == 1 then
            --insert player death here, make death function and some graphical effects
            player.xPos = player.respawn.x
            player.yPos = player.respawn.y
        elseif player.boundary.left == 2 then    
            level.x = level.x - 1
            loadLevel(level)
            player.xPos = screenWidth
        end



    end

    -- ~ Debug Print Statements ~
    --print('player.deltaY: ' .. player.deltaY)
end

function love.draw()
   --[[
   love.graphics.draw(image, imgx, imgy)
   love.graphics.print("Click and drag the cake around or use the arrow keys", 10, 10)
   --]]
   --makeWallRect(0,400,400,200)

    for i,v in ipairs(wallObjects) do

        --love.graphics.drawinrect('floor-tile.png', v.xPos, v.yPos, v.width, v.height)--, r, ox, oy, kx, ky)
        if v.visible then
            love.graphics.setColor(0.1, 0, 0.8, 0.5)
            love.graphics.rectangle('fill',v.xPos,v.yPos,v.width,v.height)
            love.graphics.setColor(1, 1, 1, 0.8)
            love.graphics.rectangle('line',v.xPos+1,v.yPos+1,v.width-1,v.height-1)
        end

        --love.graphics.draw(tile, v.xPos, v.yPos)

    end

    for i,v in ipairs(collectObjects) do
        love.graphics.setColor(0.3, 1, 0.3, 0.5)
        love.graphics.rectangle('fill',v.xPos,v.yPos,v.width,v.height)
    end

    if player.canDash then
        love.graphics.setColor(0.8, 0.1, 0, 1.0)
    else
        --love.graphics.setColor(0, 0, 0.1, 1.0)
        --love.graphics.rectangle("fill", player.xPos-2, player.yPos-2, player.width+4, player.height+4)
        love.graphics.setColor(0.1, 0.4, 0.9, 1.0)
    end
    love.graphics.rectangle("fill", player.xPos, player.yPos, player.width, player.height)
    
    --love.graphics.setColor(1, 1, 1, 1.0)


    love.graphics.setColor(0.9, 0.7, 0.9, 0.9)
    love.graphics.print('Trash Collected: '.. tostring(score), 800, 100)

end


function love.mousepressed(x, y, button, istouch)
  --[[if button == 1 then
      imgx = x -- move image to where mouse clicked
      imgy = y
   end
   --]]
    makeWallRect{xPos=x,yPos=y,width=25,height=25}
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


