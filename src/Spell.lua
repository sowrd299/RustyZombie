if not Equip then require "Equip" end

Spell = { __index = Equip }
setmetatable(Spell, Spell)
local mt = { __index = Spell }

function Spell:new(name, slot, value, count, kwargs)
    --add used
    kwargs = kwargs or {} 
    kwargs.used = function (self) self.count = self.count - 1 end
    --/add used
    s = Equip:new(name,slot,nil,nil,kwargs)
    setmetatable(s,mt)
    s.value = value
    s.count = count
    return s
end

function Spell:txt()
    --testing
    --print("USING SPELL TXT")
    --/testing
    return Spell.__index.txt(self) .. self.count .. " Copies\n"
end

function Spell:isDead()
    return self.count <= 0
end
