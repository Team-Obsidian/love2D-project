camera = {mode='auto',offY=0,offX=0,speed=50}

function swapCamera()
    local cameraModes = {'auto','manual','static','player'}
    local cameraNum
    for i, mode in ipairs(cameraModes) do
        local tempI = i
        if camera.mode == mode then
            cameraNum = tempI + 1
        end
    end
    --check maximum index instead of hardcoding
    if cameraNum > 4 then cameraNum = 1 end
    camera.mode = cameraModes[cameraNum]
end

function cameraBounds(objectList)
    local minX = {}
    local minY = {}
    local maxX = {}
    local maxY = {}

    local output = {}

    for i, rect in pairs(objectList) do
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

function cameraTranslate()
    if camera.mode == 'auto' then
        if player.yPos + winY/2 > camera.bounds.maxY then
            camera.offY = -camera.bounds.maxY + winY
        elseif player.yPos - winY/2 < camera.bounds.minY then
            camera.offY = -camera.bounds.minY 
        else
            --print('okay')
            camera.offY = -player.yPos + winY/2
        end


        camera.offX = -player.xPos + winX/2
        love.graphics.translate(camera.offX, camera.offY)


    elseif camera.mode == 'manual' or camera.mode == 'static' then
        love.graphics.translate(camera.offX, camera.offY)
    elseif camera.mode == 'player' then
        camera.offY = -player.yPos + winY/2
        camera.offX = -player.xPos + winX/2
        love.graphics.translate(camera.offX, camera.offY)
    end
end
