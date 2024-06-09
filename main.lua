--let's get to work!
io.stdout:setvbuf("no")




function love.load()
    require('modules/collision')
    require('modules/gravity')
    require('modules/make')
    require('modules/camera')

    --debug: play, make, view
    settings = {debug='play'}

	winX = 320
	winY = 180
	renderScale = 5
    zoom = 1
    --auto, static, manual


	love.graphics.setDefaultFilter('linear','nearest',1)
	love.window.setMode(winX*renderScale,renderScale*winY)



	function newAnimation(image, width, height, duration)
	    local animation = {}
	    animation.spriteSheet = image
	    animation.quads = {}

	    for y = 0, image:getHeight() - height, height do
	        for x = 0, image:getWidth() - width, width do
	            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
	        end
	    end

	    animation.duration = duration or 0.3
	    animation.currentTime = 0

	    return animation
	end

	walking = newAnimation(love.graphics.newImage('img/walk2.png'),12,16)
    stand = love.graphics.newImage('img/stand.png')
    airUp = love.graphics.newImage('img/airUp.png')
    airFloat = love.graphics.newImage('img/airFloat.png')
    airDown = love.graphics.newImage('img/airDown.png')





	maxVelocity = 2        


	function genPlayer(q)
	
		local temp = {}

		temp.xPos = q.xPos or winX/2
		temp.yPos = q.yPos or winY/2
        temp.speed = q.speed or 30



		temp.width = q.width or 12
		temp.height = q.height or 16

		temp.grounded = true
		temp.deltaX = q.deltaX or 0
		temp.deltaY = q.deltaY or 0

        temp.facing = q.facing or 1

        temp.canJump = q.canJump or true
        temp.isJumping = q.isJumping or false

        return temp
	end

    function genRect(q)
        local temp = {}

        temp.xPos = q.xPos or 15
        temp.yPos = q.yPos or 15
        temp.width = q.width or 50
        temp.height = q.height or 25

        return temp
    end

    function setLevelParam(q)
        temp.id = q.id or 1
        temp.spawnX = q.spawnX or 0
        temp.spawnY = q.spawnY or 0
        temp.bounds = q.bounds or {left=0,right=winX,top=0,bottom=winY}
        temp.boundBehavior = q.boundsBehavior or {left=0,right=0,top=0,bottom=0}
        --0 for hit wall, 1 for pass, 2 for death plane
    end

	player = genPlayer{}
    rectObjects = {genRect{yPos=200,xPos=0,width=2*winX},genRect{yPos=-200,xPos=0,width=2*winX}}
    camera.bounds = cameraBounds(rectObjects)
    --from all rectangles, finds the minX, minY, maxX, maxY and returns it


end

    



function love.draw()
    --print(love.mouse.getX())
	love.graphics.push()





	love.graphics.scale(renderScale*zoom,renderScale*zoom)



    drawGrid()
    --draw direct on screen

    --find and render cursor




    --draw with camera
    cameraTranslate()
    for i, rect in pairs(rectObjects) do
        love.graphics.setColor(0.5, 0.2, 0.8, 1)
        love.graphics.rectangle('fill', rect.xPos, rect.yPos, rect.width, rect.height)
    end

	local spriteNum = math.floor(walking.currentTime/walking.duration*#walking.quads) + 1
	if player.deltaX == 0 then walking.currentTime = 0 end


	local horizOffset = 0
	local vertOffset = 0
	local horizScale = 1
	local vertScale = 1

    if player.deltaX < 0  then
        player.facing = -1
    elseif player.deltaX > 0 then
        player.facing = 1
    end

    if player.facing == -1 then
        horizOffset = player.width
        horizScale = horizScale * -1
    elseif player.facing == 1 then
        --do nothing, already initialized
    end


    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', player.xPos, player.yPos, player.width, player.height)
	if player.grounded  and math.abs(player.deltaX) >= 0.1 then


		love.graphics.draw(walking.spriteSheet, walking.quads[spriteNum], 
			player.xPos, player.yPos, 0, horizScale, vertScale, horizOffset, vertOffset)
    elseif player.grounded  and math.abs(player.deltaX) < 0.1 then


        love.graphics.draw(stand,player.xPos,player.yPos,0,horizScale,vertScale,horizOffset,vertOffset)
    elseif player.grounded == false and player.deltaY <= -0.1 then
        love.graphics.draw(airUp,player.xPos,player.yPos,0,horizScale,vertScale,horizOffset,vertOffset)
    elseif player.grounded == false and player.deltaY >= 1 then
        love.graphics.draw(airDown,player.xPos,player.yPos,0,horizScale,vertScale,horizOffset,vertOffset)
    else 
        love.graphics.draw(airFloat,player.xPos,player.yPos,0,horizScale,vertScale,horizOffset,vertOffset)
    end
    print('player.deltaY: '..tostring(player.deltaY))



	--love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.xPos, player.yPos)
	





    if settings.debug == 'make' then

        love.graphics.setColor(0.4,0.2,0.2,0.4)
        love.graphics.rectangle('fill', 
            math.min(selected.lastX, selected.xPos), 
            math.min(selected.lastY, selected.yPos), 
            math.abs(selected.xPos-selected.lastX)+tileSize, 
            math.abs(selected.yPos-selected.lastY)+tileSize
            --remember to always add back in the tile in calculations
            )
        love.graphics.setColor(0.8,0.2,0.2,0.8)
        love.graphics.rectangle('line', 
            math.min(selected.lastX, selected.xPos), 
            math.min(selected.lastY, selected.yPos), 
            math.abs(selected.xPos-selected.lastX)+tileSize, 
            math.abs(selected.yPos-selected.lastY)+tileSize
            --remember to always add back in the tile in calculations
            )

        --draw debug cursor
        love.graphics.setColor(0.8, 0.3, 0.3, 0.8)
        love.graphics.rectangle('fill', selected.xPos, selected.yPos, tileSize, tileSize)
        love.graphics.setColor(0.3, 0.3, 0.8, 0.8)
        love.graphics.rectangle('fill', selected.lastX, selected.lastY, tileSize, tileSize)

        love.graphics.setColor(0.3, 0.8, 0.3, 0.8)
        love.graphics.rectangle('line', cursor.xPos, cursor.yPos, tileSize, tileSize)



    end

    love.graphics.pop()
end

function love.update(dTime)
    --print('player.yPos: ' .. tostring(player.yPos))
--[[
	animation.currentTime = animation.currentTime + dTime
	if animation.currentTime >= animation.duration then
		animation.currentTime = animation.currentTime - animation.duration 
	end
--]]
    --print(player.grounded)

    if settings.debug == 'play' then
    	if player.grounded and math.abs(player.deltaX) >= 0.5 then
    		walking.currentTime = walking.currentTime + dTime
    		if walking.currentTime >= walking.duration then
    			walking.currentTime = walking.currentTime - walking.duration
    		end
    	end

--[[bad, need to make another system
        if math.abs(player.deltaX) >= 0.1 then
            --player.deltaX = player.deltaX*0.80
            player.deltaX = player.deltaX*0.80
        else
            player.deltaX = 0
        end
]]

--[[I don't know what I used this for, mess with my gravity
        if math.abs(player.deltaY) >= 0.1 then
            --player.deltaX = player.deltaX*0.80
            --player.deltaY = player.deltaY*0.80
        else
            player.deltaY = 0
        end
--]]
        if love.keyboard.isDown('left') then
        	if player.deltaX > -maxVelocity then
            	player.deltaX = player.deltaX - player.speed*dTime
        	end
        end

        if love.keyboard.isDown('right') then
        	if player.deltaX < maxVelocity then
            	player.deltaX = player.deltaX + player.speed*dTime
        	end
        end

        if love.keyboard.isDown('up') then
        	if player.deltaY > -maxVelocity then
            	player.deltaY = player.deltaY - player.speed*dTime
        	end
        end

        if love.keyboard.isDown('down') then
        	if player.deltaY < maxVelocity then
            	player.deltaY = player.deltaY + player.speed*dTime
        	end
        end

        if love.keyboard.isDown('z') and player.grounded and player.canJump then
            player.grounded = false
            player.canJump = false
            shortJump = false
            player.isJumping = true
            player.deltaY = -jumpSpeed
        end


        if math.abs(player.deltaX) > maxVelocity then
            local sign = 0
            if player.deltaX > 0 then sign = 1 elseif player.deltaX < 0 then sign = -1 end
            player.deltaX = maxVelocity * sign

            --might want to adjust player.facing, need to preserve direction of deltaX somehow
        end

        --[[ Gravity needs to happen, no terminal velocity yet
        if math.abs(player.deltaY) > maxVelocity then
            local sign = 0
            if player.deltaY > 0 then sign = 1 elseif player.deltaY < 0 then sign = -1 end
            player.deltaY = maxVelocity * sign
        end
        --]]

        --standing on the ground / land
        for i, rect in pairs(rectObjects) do
            if willCollide(player, rect).bottom then
                player.yPos = rect.yPos - player.height
                player.deltaY = 0
                player.grounded = true
                player.isJumping = false
                shortJump = false      
            end
        end

        --Ceilings and bonked heads
        for i, rect in pairs(rectObjects) do
            if willCollide(player,rect).top then
                player.yPos = rect.yPos + rect.height
                player.deltaY = 0
                shortJump = true
            end
        end

        --Gravity happens here, grounded
        if player.grounded == false then
            checkGravity()
            player.deltaY = gravity*dTime + player.deltaY
        end

        if player.deltaY > 5*maxVelocity then player.deltaY = 5*maxVelocity end

        player.yPos = player.deltaY + player.yPos
        player.xPos = player.deltaX + player.xPos
    end

    if settings.debug == 'make' then
        findCursor()
        if selected.dragging then
            findSelect()
        end


    end






    --camera controls
    if love.keyboard.isDown('w') then
        if camera.mode == 'manual' then
            camera.offY = camera.offY + camera.speed*dTime
        end
    end

    if love.keyboard.isDown('a') then
        if camera.mode == 'manual' then
            camera.offX = camera.offX + camera.speed*dTime
        end
    end

    if love.keyboard.isDown('s') then
        if camera.mode == 'manual' then
            camera.offY = camera.offY - camera.speed*dTime
        end
    end

    if love.keyboard.isDown('d') then
        if camera.mode == 'manual' then
            camera.offX = camera.offX - camera.speed*dTime
        end
    end

    if love.keyboard.isDown('lshift') then
        camera.speed = 200
    end

    if player.deltaX ~= 0 then
        --player.deltaX = player.deltaX*0.80
        player.deltaX = player.deltaX*0.80
    end
--[[




    --player.deltaY = math.floor(player.deltaY*10)/10


    player.xPos = player.xPos + player.deltaX
    player.yPos = player.yPos + player.deltaY



    if math.abs(player.deltaX) < 1 then
    	player.deltaX = math.floor(player.deltaX)
    end

    if player.deltaY ~= 0 then
        player.deltaY = player.deltaY*0.80
        --player.deltaY = player.deltaY*0.970
    end

    if math.abs(player.deltaY) < 1 then
    	player.deltaY = math.floor(player.deltaY)
    end
--]]

    --player.deltaY






end

function love.keypressed(key)
    if key == 'space' then
        --objectPlace('wall')
        --printMaker()
    end

    if key == 'q' then
        swapCamera()
    end
    if key == 'e' then
        swapDebug()
    end
end

function love.keyreleased(key)
    if key == 'z' then
        player.canJump = true
        if player.isJumping then
            shortJump = true
        end
        --very sloppy but hey, works
        


    end


    if key == 'p' then
        zoom = zoom + 0.2
    end
    if key == 'o' then
        zoom = zoom - 0.2
    end

    if key == 'lshift' then
        camera.speed = 50
    end

end

function love.mousepressed(x, y, button, istouch, presses)
    if settings.debug == 'make' then
        selected.lastX, selected.lastY = cursor.xPos, cursor.yPos
        selected.dragging = true
        --tileDrag(button)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if settings.debug == 'make' then
        selected.dragging = false
        --maker.pointer.drag = false
        --print('tile undrag')
    end
end