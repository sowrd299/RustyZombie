require "Hits"

Equip = {}
local mt = { __index = Equip } 

function Equip:new (name, slot, cost, hpr, kwargs)
    --string name, slot
    --number[] hpt
    --Attack attack
    --table kwargs:
        --int dblDmg
        --Void Func(self) used
    local e = {}
    setmetatable(e,mt)
    e.name = name
    e.slot = slot
    e.cost = cost
    e.hpr = hpr --hit priority values
    e.hits = 0 --hits taken
    if kwargs then
        e.atk = kwargs.atk --attack
        e.dblDmg = kwargs.dblDmg --extra damage dealt from DOUBLE
        e.dxt = kwargs.dxt --mod to dextarity
        e.used = kwargs.used --called when attack used
    end
    return e
end

function Equip:txt ()
    --returns a text representation of the item
    local t = self.name .. " " .. HitsText(self) .. " "
    t = t .. "(" .. self.slot .. ")" .. "\n"
    if self.atk then t = t .. "ATTACK: " .. self.atk:txt() end
    if self.dblDmg then t = t .. "DOUBLE: Damage+" .. self.dblDmg end
    return t
end

function Equip:damage(val)
    --number val
    self.hits = self.hits + val
end

function Equip:isDead()
    return IsDead(self)
end
