--a script for testing EquipDataLoader

require "EquipDataLoader"

local t = LoadEquipData("../data/Equip.csv")
for i=1,#t do
    io.write("\n")
    if t[i] then io.write(t[i]:txt())
    else io.write("nil") end
end
