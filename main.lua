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

	    animation.duration = duration or 1
	    animation.currentTime = 0

	    return animation
	end

	walking = newAnimation(love.graphics.newImage('walk.png'),12,16)






	maxVelocity = 3        --player.deltaX = player.deltaX*0.80


	function genPlayer(q)
	
		local temp = {}

		temp.xPos = q.xPos or winX/2
		temp.yPos = q.yPos or winY/2
		temp.width = q.width or 12
		temp.height = q.height or 16

		temp.speed = q.speed or 200

		temp.grounded = true

		temp.deltaX = q.deltaX or 0
		temp.deltaY = q.deltaY or 0

		return temp


	end
	player = genPlayer{}

end





function love.draw()
	love.graphics.push()
	love.graphics.scale(renderScale,renderScale)
	local spriteNum = math.floor(walking.currentTime/walking.duration*#walking.quads) + 1
	
	local horizOffset = 0
	local vertOffset = 0
	local horizScale = 1
	local vertScale = 1

	if player.grounded == true and math.abs(player.deltaX) > 0.5 then
		if player.deltaX < 0 then
			horizOffset = player.width
			horizScale = horizScale * -1
		else

		end
		love.graphics.draw(walking.spriteSheet, walking.quads[spriteNum], 
			player.xPos, player.yPos, 0, horizScale, vertScale, horizOffset, vertOffset)
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

	if player.grounded and math.abs(player.deltaX) >= 0.5 then
		walking.currentTime = walking.currentTime + dTime
		if walking.currentTime >= walking.duration then
			walking.currentTime = walking.currentTime - walking.duration
		end
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

end