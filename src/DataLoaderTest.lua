--a script for testing EquipDataLoader

require "EquipDataLoader"

local t = LoadEquipData("../data/Equip.csv")
io.write(t[1]:txt())
