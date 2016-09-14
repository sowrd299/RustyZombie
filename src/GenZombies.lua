--functions for generate stages of zombies

if not EquipDataLoader then require "EquipDataLoader" end
if not GenMerch then require "GernMerch" end
if not Zombie then require "Zombie" end

local spDataPath = "../data/Spell.csv"
local sps = LoadEquipData(spDataPath)

local function genZombie(l,t,sr,copies)
    --number l
    --number[3] t
    --Spell sp
    --returns a Zombie[copies] of identical "level" l zombies 
    --with stats at ratios given by t (the last stat being max spell value)
    --that drops the given spell
    local args = {}
    for i=1,#t do
        args[i] = math.floor(l*t)
    end
    arg[4] = GenMerch(l,arg[4],sr,sps)
    local r = {}
    for i=1,copies do
        r[i] = Zombie:new(unpack(args)) 
    end
    return r 
end

local function genZombies(r)
    --number r
    --returns a group of zombies for the r'th round
    --CURRENT ALGORYTHM FOR TESTING ONLY
    local a = Attack:new(0, 2, { dot = 1 })
    local s = Spell:new("Fireball", "off", 10, 1, {atk=a})
    local zs = {} 
    for i=1,r do
        table.insert(zs,Zombie:new(i*2,i,i,s))
    end
    return zs
end

function GenZsWithTutorial(r)
    --number are
    --wrapper for genZombies that allows for unqiue 1st round
    if r==1 then
        local s = Spell:new("Twinkle", "off", 20, 1)
        local z = Zombie:new(4,4,1,s)
        local zo = Zombie:new(6,1,1,s) --teach how damage works
        return {z,zo}
    end
    return genZombies(r)
end
