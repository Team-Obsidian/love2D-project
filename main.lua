--let's get to work!
io.stdout:setvbuf("no")
winX = 320
winY = 180




function love.load()


	function genPlayer(q)
	
		local temp = {}

		temp.xPos = q.xPos or winX/2
		temp.yPos = q.yPos or winY/2
		temp.width = q.width or 12
		temp.height = q.height or 16


	end
	player = genPlayer{}

end





function love.graphics.draw()
	love.graphics.setColor(0.8, 0.2, 0.8, 1)
	love.graphics.Rectangle(player.xPos,player.yPos,player.width,player,height)
	love.graphics.Rectangle(winX/2,winY/2,500,500)

end