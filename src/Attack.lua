Attack = {}
local mt = { __index = Attack }

function Attack:new (dmg, targets, kwargs)
    --number dmg, targets
    --table kwargs:
        --bool dxt
        --number dot, rng, rngPen
    local a = {}
    setmetatable(a,mt)
    a.dmg = dmg --damage delt
    a.targets = targets --to how many targets
    if kwargs then
        a.dxt = kwargs.dxt --is dexterity applied
        a.dot = kwargs.dot --damage over time delt
        a.rng = kwargs.rng --range
        a.rngPen = kwargs.rngPen --penalty for being out of range
    end
    return a
end

local function ranged(atk)
    --Attack atk
    --return true if given attack has a limited ranged
    return atk.rng and atk.rngPen
end 

function Attack:run(target, dxt, mod)
    --Zombie target
    --number dxt
    --io.write("Using " .. self:txt())
    local d = self.dmg
    if self.dxt then d = d + dxt end
    if ranged(self) and target.dist > self.rng then
        d = d + self.rngPen
    end
    if mod then d = d + mod end
    target:damage(d)
    if self.dot then target:ignite(self.dot) end
end

function Attack:txt()
    --returns a text representation of the attack
    local t = "Damage: " .. self.dmg .. ", Targets: " .. self.targets .. ", "
    if self.dxt then t = t .. "DEXTOROUS, " end
    if self.dot then t = t .. "IGNITE: " .. self.dot .. ", " end
    if ranged(self) then
        t = t .. "LIMITTED: " .. self.rng .. " OUTSIDE: Damage"
        if self.rngPen >= 0 then t = t .. "+" end
        t = t .. self.rngPen .. ","
    end
    t = t .. "\n"
    return t
end
