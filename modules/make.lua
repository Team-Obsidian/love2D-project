
tileSize = 8
cursor = {}
selected = {}

function initMake()
    cursor = {}
    cursor.xPos = 0
    cursor.xGrid = 0
    cursor.yPos = 0
    cursor.yGrid = 0



    selected = {}
    selected.xPos = 0
    selected.xGrid = 0
    selected.yPos = 0
    selected.yGrid = 0

    selected.lastX = 0
    selected.lastY = 0

    selected.dragging = false

end
initMake()

function swapDebug()
    local debugModes = {'play','make','view'}
    local debugNum
    for i, mode in ipairs(debugModes) do
        local tempI = i
        if settings.debug == mode then
            debugNum = tempI + 1
        end
    end
    --check maximum index instead of hardcoding
    if debugNum > 3 then debugNum = 1 end
    settings.debug = debugModes[debugNum]
end

function findCursor()
    cursor.xPos = (love.mouse.getX())/renderScale - camera.offX
    cursor.yPos = (love.mouse.getY())/renderScale - camera.offY
    --print('cursor.xPos: '..tostring(cursor.xPos)) + camera.offY
    cursor.xPos = cursor.xPos - (cursor.xPos % tileSize)
    cursor.yPos = cursor.yPos - (cursor.yPos % tileSize)

    --kind of redundant...?
    cursor.xGrid = cursor.xPos / tileSize
    cursor.yGrid = cursor.yPos / tileSize

    --print('cursor.xPos: '..tostring(cursor.xPos)..' cursor.yPos: '..tostring(cursor.yPos))
end

function findSelect()

    selected.xPos = cursor.xPos
    selected.yPos = cursor.yPos
    
    print(
        'xPos: '..tostring(selected.xPos)..' yPos: '..tostring(selected.yPos)..
        ' lastX: '..tostring(selected.lastX)..' lastY: '..tostring(selected.lastY)
    )
end

function drawGrid()
    --hmm, no clamping here at spaceX or Y
    local offsetX = camera.offX % tileSize
    local spaceX = winX/tileSize
    local offsetY = camera.offY % tileSize
    local spaceY = winY/tileSize

    for i=0, spaceX do
        --fix so consistent and not constantly shifting
        --if i % 4 == 0 then love.graphics.setColor(0, 0.8, 0.8, 0.8) else love.graphics.setColor(0.8, 0.8, 0.8, 0.4) end
        love.graphics.setColor(0.8, 0.8, 0.8, 0.4)
        love.graphics.line(i/spaceX*winX+offsetX, winY, i/spaceX*winX+offsetX, 0)
    end

    for i=0, spaceY do
        --if i % 4 == 0 then love.graphics.setColor(0, 0.8, 0.8, 0.8) else love.graphics.setColor(0.8, 0.8, 0.8, 0.4) end
        love.graphics.setColor(0.8, 0.8, 0.8, 0.4)
        love.graphics.line(0, i/spaceY*winY+offsetY, winX, i/spaceY*winY+offsetY)
    end
end






--[[    
tileSize = 32
maker = {}
tempID = ''

function initMaker()
    maker.cursor1 = {x=15,y=10}
    maker.cursor2 = {x=15,y=10}
    maker.selected = {x=20,y=5,drag=false}
    maker.current = {}
    maker.export = {}
    maker.menu = 0
    tempID = ''
end

initMaker()















function findCursor(offX, offY)
    --print('offx: '..offX..' offY: '..offY)
    x, y = love.mouse.getPosition( )
    if maker.selected.drag == false then
        x = x - offX
        y = y - offY
    end

    maker.selected.x = (x - (x % tileSize)) / tileSize
    maker.selected.y = (y - (y % tileSize)) / tileSize

    if maker.selected.drag then
        maker.cursor2.x = maker.selected.x
        maker.cursor2.y = maker.selected.y
    end

    --find lower X
    if maker.cursor1.x <= maker.cursor2.x then
        maker.current.x = maker.cursor1.x * tileSize
    else
        maker.current.x = maker.cursor2.x * tileSize
    end

    --find lower Y
    if maker.cursor1.y <= maker.cursor2.y then
        maker.current.y = maker.cursor1.y * tileSize
    else
        maker.current.y = maker.cursor2.y * tileSize
    end

    --find width and height, add 1 so it goes around cursor 2 before scaling
    maker.current.w = (math.abs(maker.cursor1.x-maker.cursor2.x) + 1) * tileSize
    maker.current.h = (math.abs(maker.cursor1.y-maker.cursor2.y) + 1) * tileSize

    --print("x: ".. maker.current.x .. ' y: '.. maker.current.y .. " w: "..maker.current.w.. ' h: '..maker.current.h)
end

function drawCursor()
    love.graphics.setColor(0.5, 0.1, 0.1, 0.8)
    love.graphics.rectangle("fill", maker.cursor1.x*tileSize, maker.cursor1.y*tileSize, tileSize, tileSize)
    love.graphics.setColor(0.1, 0.1, 0.5, 0.8)
    love.graphics.rectangle("fill", maker.cursor2.x*tileSize, maker.cursor2.y*tileSize, tileSize, tileSize)
    love.graphics.setColor(0.1, 0.5, 0.1, 0.8)
    love.graphics.rectangle("line", maker.selected.x*tileSize, maker.selected.y*tileSize, tileSize, tileSize)

    love.graphics.setColor(0.3, 0.3, 0.3, 0.4)
    love.graphics.rectangle("fill", maker.current.x, maker.current.y, maker.current.w, maker.current.h)
end

function objectPlace(type)
    if type == 'wall' then
        table.insert(maker.export, 'genRect{xPos='..maker.current.x..',yPos='..maker.current.y..',width='..maker.current.w..',height='..maker.current.h..'}')
        genRect{xPos=maker.current.x,yPos=maker.current.y,width=maker.current.w,height=maker.current.h}
        print('genRect{xPos='..maker.current.x..',yPos='..maker.current.y..',width='..maker.current.w..',height='..maker.current.h..'}')
    
    elseif type == 'collectable' then
        if tonumber(tempID) ~= nil then
            table.insert(maker.export, 'makeCollectable{xPos='..maker.selected.x*tileSize..',yPos='..maker.selected.y*tileSize..',width='..tileSize..',height='..tileSize..',id='..tonumber(tempID)..'}')
            makeCollectable{xPos=maker.selected.x*tileSize,yPos=maker.selected.y*tileSize,width=tileSize,height=tileSize,id=tonumber(tempID)}
            print('makeCollectable{xPos='..maker.selected.x*tileSize..',yPos='..maker.selected.y*tileSize..',width='..tileSize..',height='..tileSize..',id='..tonumber(tempID)..'}')
            tempID = 'Success!'
        else
            tempID = 'Failed...'
        end
    end
end

function tileDrag(button)
    print('tile Drag')
    xPosTile = (x - (x % tileSize)) / tileSize
    yPosTile = (y - (y % tileSize)) / tileSize
    print('xPosTile is ' .. xPosTile .. ', yPosTile is ' .. yPosTile)
    if button == 1 then
        maker.cursor1 = {x=xPosTile,y=yPosTile}
        maker.selected.drag = true
    elseif button == 2 then
        --objectPlace('collectable')
    end
end

function printMaker()
    print()

    for key, value in pairs(maker) do
        local tempValue = value
        local tempKey = key
        local endValue = value
        local endKey = key
        if type(value) == 'table' then
            print(tostring(tempKey) .. ':')
            for key2, value2 in pairs(tempValue) do
                endValue = tostring(value2)
                endKey = '\t' .. tostring(key2)
                print(tostring(endKey) .. ': '.. tostring(endValue))
            end

        end


    end
 
end
--]]