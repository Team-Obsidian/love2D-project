

function falling()
	local timeValue = 2
	local jumpHeight = 300
	local temp = {}
	temp.gravity = jumpHeight/(2*((timeValue)^2))
	temp.jumpSpeed = math.sqrt(2*jumpHeight*temp.gravity)
	return temp
end