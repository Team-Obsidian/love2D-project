--let's get to work!
io.stdout:setvbuf("no")




function love.load()
    require('modules/collision')
    require('modules/gravity')

	winX = 320
	winY = 180
	renderScale = 5
    --auto, static, manual
    camera = {mode='auto',offY=0,offX=0,speed=100}
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

	walking = newAnimation(love.graphics.newImage('img/walk.png'),12,16)
    stand = love.graphics.newImage('img/stand.png')





	maxVelocity = 2        --player.deltaX = player.deltaX*0.80


	function genPlayer(q)
	
		local temp = {}

		temp.xPos = q.xPos or winX/2
		temp.yPos = q.yPos or winY/2
		temp.width = q.width or 12
		temp.height = q.height or 16

		temp.speed = q.speed or 30

		temp.grounded = true

		temp.deltaX = q.deltaX or 0
		temp.deltaY = q.deltaY or 0

        temp.facing = q.facing or 1

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
    loadedObjects = {genRect{yPos=200,xPos=0,width=2*winX},genRect{yPos=-200,xPos=0,width=2*winX}}

    --from all rectangles, finds the minX, minY, maxX, maxY and returns it
    function cameraBounds()
        local minX = {}
        local minY = {}
        local maxX = {}
        local maxY = {}

        local output = {}

        for i, rect in pairs(loadedObjects) do
            table.insert(minX, rect.xPos)
            table.insert(minY, rect.yPos)
            table.insert(maxX, rect.xPos + rect.width)
            table.insert(maxY, rect.yPos + rect.height)
        end

        output = {}
        output.minX = math.min(unpack(minX))
        output.maxX = math.max(unpack(maxX))
        output.minY = math.min(unpack(minY))
        output.maxY = math.max(unpack(maxY))

        return output

    end
    camera.bounds = cameraBounds()
end

    



function love.draw()
	love.graphics.push()
	love.graphics.scale(renderScale,renderScale)

    if camera.mode == 'auto' then
        local cameraOffY = 0
        print('bounds: '.. tostring(camera.bounds.maxY))
        print('player: ' .. tostring(player.yPos - winY/2))
        if player.yPos + winY/2 > camera.bounds.maxY then
            cameraOffY = -camera.bounds.maxY + winY
        elseif player.yPos - winY/2 < camera.bounds.minY then
            cameraOffY = -camera.bounds.minY 
        else
            --print('okay')
            cameraOffY = -player.yPos + winY/2
        end


        --love.graphics.translate(-player.xPos + winX/2, 0)
        love.graphics.translate(-player.xPos + winX/2, cameraOffY)


    elseif camera.mode == 'manual' or camera.mode == 'static' then
        love.graphics.translate(camera.offX, camera.offY)
    end



    for i, rect in pairs(loadedObjects) do
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
	if player.grounded == true and math.abs(player.deltaX) >= 0.1 then


		love.graphics.draw(walking.spriteSheet, walking.quads[spriteNum], 
			player.xPos, player.yPos, 0, horizScale, vertScale, horizOffset, vertOffset)
    elseif player.grounded == true and math.abs(player.deltaX) < 0.1 then


        love.graphics.draw(stand,player.xPos,player.yPos,0,horizScale,vertScale,horizOffset,vertOffset)
	end



	--love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.xPos, player.yPos)
	


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
	if player.grounded and math.abs(player.deltaX) >= 0.5 then
		walking.currentTime = walking.currentTime + dTime
		if walking.currentTime >= walking.duration then
			walking.currentTime = walking.currentTime - walking.duration
		end
	end

    if math.abs(player.deltaX) >= 0.1 then
        --player.deltaX = player.deltaX*0.80
        player.deltaX = player.deltaX*0.80
    else
        player.deltaX = 0
    end

    if math.abs(player.deltaY) >= 0.1 then
        --player.deltaX = player.deltaX*0.80
        --player.deltaY = player.deltaY*0.80
    else
        player.deltaY = 0
    end

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

    if love.keyboard.isDown('z') and player.grounded then
        player.grounded = false
        player.deltaY = -falling().jumpSpeed*dTime
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


--[[




    --player.deltaY = math.floor(player.deltaY*10)/10


    player.xPos = player.xPos + player.deltaX
    player.yPos = player.yPos + player.deltaY

    if player.deltaX ~= 0 then
        --player.deltaX = player.deltaX*0.80
        player.deltaX = player.deltaX*0.80
    end

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

    --Gravity happens here, grounded
    for i, rect in pairs(loadedObjects) do
        if willCollide(player, rect).bottom then
            player.yPos = rect.yPos - player.height
            player.deltaY = 0
            player.grounded = true        
        end
    end
    if player.grounded == false then
        player.deltaY = falling().gravity*dTime + player.deltaY
    end

    player.yPos = player.deltaY + player.yPos
    player.xPos = player.deltaX + player.xPos



end

function love.keypressed(key)
    if key == 'space' then

        for i, rect in pairs(loadedObjects) do
            print()
            for key, value in pairs(willCollide(player,rect)) do
                print(tostring(key) .. ': '.. tostring(value))
            end
        end
    end
end