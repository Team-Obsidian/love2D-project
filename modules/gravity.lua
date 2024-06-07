
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
	temp.gravity = 10
	temp.jumpSpeed = 300
	return temp
end