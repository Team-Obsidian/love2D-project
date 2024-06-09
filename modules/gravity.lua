
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

--temporary solution time!
function falling()
	local temp = {}
	--really bad and randomly made but hey,
	--kinda works
	if player.deltaY < -2 then
		temp.gravity = 20
	else
		temp.gravity = 5
	end

	temp.jumpSpeed = 300
	return temp
end