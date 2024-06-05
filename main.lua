--let's get to work!
io.stdout:setvbuf("no")




function love.load()
	winX = 320
	winY = 180
	renderScale = 5
	love.graphics.setDefaultFilter('linear','nearest',1)
	love.window.setMode(winX*renderScale,renderScale*winY)



	function newAnimation(image, width, height, duration)
	    local animation = {}
	    animation.spriteSheet = image;
	    animation.quads = {};

	    for y = 0, image:getHeight() - height, height do
	        for x = 0, image:getWidth() - width, width do
	            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
	        end
	    end

	    animation.duration = duration or 0.3
	    animation.currentTime = 0

	    return animation
	end

	walking = newAnimation(love.graphics.newImage('walk.png'),12,16)
    stand = love.graphics.newImage('stand.png')





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
    loadedObjects = {genRect{}}
end

    



function love.draw()
	love.graphics.push()
	love.graphics.scale(renderScale,renderScale)
    love.graphics.translate(-player.xPos + winX/2, -player.yPos + winY/2)

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
        player.deltaY = player.deltaY*0.80
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



    if math.abs(player.deltaX) > maxVelocity then
        local sign = 0
        if player.deltaX > 0 then sign = 1 elseif player.deltaX < 0 then sign = -1 end
        player.deltaX = maxVelocity * sign

        --might want to adjust player.facing, need to preserve direction of deltaX somehow
    end
    if math.abs(player.deltaY) > maxVelocity then
        local sign = 0
        if player.deltaY > 0 then sign = 1 elseif player.deltaY < 0 then sign = -1 end
        player.deltaY = maxVelocity * sign
    end

    player.yPos = player.deltaY + player.yPos
    player.xPos = player.deltaX + player.xPos

end

function love.keypressed(key)
    if key == 'space' then
        print('player.xPos: '..tostring(player.xPos).. ' player.yPos: '..tostring(player.yPos))
    end
end