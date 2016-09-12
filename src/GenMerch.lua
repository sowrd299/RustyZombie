--a library for generating equipment

if not EquipDataLoader then require "EquipDataLoader" end

local eqDataPath = "../data/Equip.csv"
local eqs = LoadEquipData(eqDataPath)
local lenEqs = #eqs --stored for speed, assumes eqs const

function GenMerch(r,dust,sr)
    --number r,dust,sr
    --returns an item to be sold during the rth of sr rounds
    --with given max cost
    --return nil if no candidate found
    sr = sr -1 --account that will never receive item on last round
    local s = lenEqs * r / (sr) --index of item to return 
    local step = lenEqs / sr
    --testing
    print("\n\nlenEqs = " .. lenEqs)
    print("s = " .. s)
    print("step = " .. step)
    --/testing
    s = math.ceil(s - (step > 1 and (math.random(step) - 1) or 0)) --if more then 1 item per stage randomize which used
    --testing
    print("s adjusted = " .. s)
    --/testing
    --DOUBLE CHECK ALL INDEXES REACHIBLE
    while eqs[s].cost > dust and s > 1 do
        if s > step then
            s = s - step
        else
            s = s - 1
        end
    end
    if eqs[s].cost <= dust then
        return eqs[s]
    else
        return nil
    end
end

function HGenMerch(r,dust)
    --number r,dust
    --returns an item to be sold durring given round with given max cost
    --uses a primitive Hard coded algorithm
    --TESTING
    local e = nil
    if r>=2 and dust>=20 then
        if math.random(2)==1 then
            local a = Attack:new(5,1,{rng=2,rngPen=-3})
            e = Equip:new("Electric Flail", "main", 20, {50,40,30}, {atk=a})
        else
            local a = Attack:new(2,2,{rng=2,rngPen=2})
            e = Equip:new("Machine Rifle", "main", 20, {40,40},  {atk=a})
        end
    elseif dust>=10 then
        local a = Attack:new(2,2)
        e = Equip:new("Machine Pistol", "main", 10, {40,20}, {atk=a})
    end
    return e
    --/TESTING
end 

