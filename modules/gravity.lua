
--[[ Fix gravity later...
function falling()
	local timeValue = 2
	local jumpHeight = 300
	local temp = {}
	temp.gravity = jumpHeight/(2*((timeValue)^2))
	temp.jumpSpeed = math.sqrt(2*jumpHeight*temp.gravity)
	return temp
end
--]]
gravity = 4
jumpSpeed = 3
shortJump = false
--temporary solution time!
function checkGravity()
	print('shortJump: '..tostring(shortJump))
	--really bad and randomly made but hey,
	--kinda works
	if player.deltaY > 0 then
		gravity = 6
	elseif shortJump and player.deltaY < 0 then
		gravity = 12
	else
		gravity = 4
	end
end