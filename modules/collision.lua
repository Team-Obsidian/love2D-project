wallBuffer = 0.1

function isInside(obj1,obj2)
	if obj1.xPos > obj2.xPos and obj1.xPos + obj1.width < obj2.xPos + obj2.width
		and obj1.yPos > obj2.yPos and obj1.yPos + obj1.height < obj2.yPos + obj2.height then
		return true
	else
		return false
	end
end

function willCollide(object1, object2)
	--print('object1.deltaY is: ' .. tostring(object1.deltaY))
	local collides = {}
	    --print('start of doesCollideRect: '.. testVarNum)
	    --testVarNum = testVarNum + 1
	    bottom1 = object1.yPos+object1.height
	    bottom2 =object2.yPos+object2.height

	--check if object1 is at a vertical position to hit horizontally
	if (bottom1) > object2.yPos and (object1.yPos < bottom2) then


	    --if object1 left passes object2 right and object1 right is still right of object2 right
	    if (object1.xPos + object1.deltaX < object2.xPos + object2.width) and object1.xPos + object1.width > object2.xPos + object2.width - wallBuffer then
	        collides.left = true
	    else
	        collides.left = false
	    end

	    --if object1 right passes object2 left and object1 left is still left of object2 right
	    if (object1.xPos + object1.width + object1.deltaX) > object2.xPos and object1.xPos < object2.xPos + wallBuffer then
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

	if isInside(object1,object2) then
		collides.inside = true
	else
		collides.inside = false
	end
	--collides should be {['left']=true,['right']=true,['top']=true,['bottom']=true} when inside of object 2
	return collides
end

--[[ Version 2 rewrite WIP
	function willCollide(obj1,obj2)
	    local collides = {left=false,right=false,top=false,bottom=false}
	    if obj1.xPos + obj1.width > obj2.xPos and obj1.xPos < obj2.xPos then
	        if obj1.yPos + obj1.height > obj2.yPos 
	    end
	end
--]]

