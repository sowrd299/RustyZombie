Zombie = { spd = 1 } --space move forward and hp lost each turn
local mt = { __index = Zombie }

function Zombie:new (hp, distance, dmg, drop)
    --number hp, distance, dmg
    --Spell drop
    local z = {}
    setmetatable(z,mt)
    z.hp = hp
    z.maxHP = hp
    z.dist= distance
    z.dmg = dmg
    z.drop = drop
    z.dot = 0
    return z
end

function Zombie:turn ()
    --called once per turn
    self.dist = self.dist - self.spd
    self:damage(self.dot)
    --chance to explode
    if not self:isDead() and math.random(self.dist*self.hp+1) == 1 then
        self.exploding = true
    end
end

function Zombie:damage (val)
    --number val
    --deals val damage to the zombie
    self.hp = self.hp - val
end

function Zombie:ignite (val)
    --number val
    --increase dot by val
    self.dot = self.dot + val
end

function Zombie:isExploding ()
    return self.exploding and not self:isDead()
end

function Zombie:willDrop ()
    return not self.exploding and self.drop
end

function Zombie:explode (character)
    --Character character
    --deals damage to character
    local d = self.dmg - self.dist
    local dd = d>0 and d or 0
    character:damage(dd)
    self.hp = 0
end

function Zombie:isDead ()
    --returns true is zombie is dead
    return self.hp <= 0
end

function Zombie:txt ()
    local t = "Damage: " .. self.dmg .. ", Distance: " .. self.dist .. ", Health: " .. self.hp .. "/" .. self.maxHP
    return t
end
