
--[[ Iterates through keys and sequentially prints each value :)
for i, rect in pairs(loadedObjects) do
    print()
    for key, value in pairs(willCollide(player,rect)) do
        print(tostring(key) .. ': '.. tostring(value))
    end
end
--]]