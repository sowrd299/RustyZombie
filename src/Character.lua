if not Hits then require "Hits" end

Character = { bpSize = 3, slots = { "chest", "off", "head", "main" } }
local mt = { __index = Character }

function Character:new(hp)
    local c = {}
    setmetatable(c,mt)
    c.bp = {} --backpack
    c.equiped = {}
    --build hit priorities
    c.hpr = {}
    for i = 1,hp do
        c.hpr[i] = (hp+1-i)*10
    end
    --/build hpr
    c.hits = 0 --hits taken
    c.dust = 0 --money
    return c
end

function Character:turn()
    --to be called once per turn
    --remove destroyed equipment
    for i=1,#self.slots do
        if self.equiped[self.slots[i]] and self.equiped[self.slots[i]]:isDead() then
            self.equiped[self.slots[i]] = nil
        end
    end
end

function Character:getDxt()
    --returns the characters "dexterity" value
    --based on total dexterity of items - #items in dp
    --for use by game mechanics
    local dxt = 0
    for k,v in pairs(self.equiped) do
       if v.dxt then dxt = dxt + v.dxt end 
   end
   return dxt - self:getPackCount()
end

function Character:txt()
    local t = ""
    --returns a string representation of the character
    for k,v in pairs(self.slots) do
        if self.equiped[v] then t = t .. k .. "=> " .. self.equiped[v]:txt() .. "\n" end
    end
    t = t .. "Hit Priorities " .. HitsText(self) .. "\n"
    t = t .. self.dust .. " Dust, "
    t = t .. self:getPackCount() .. "/" .. self.bpSize .. " Items in Pack, "
    t = t .. self:getDxt() .. " Dexterity"
    return t
end

--STORAGE
local function condense(e,f)
    --Spell e,f
    --attemps to condense e into f
    --returns true if successful
    if e.count and f.count and e.name == f.name then
        f.count = f.count + e.count
        return true
    end
    return false
end

function Character:getPackCount()
    --returns total number of items in bp
    local c = 0 
    for k,v in pairs(self.bp) do
        c = c + 1
    end
    return c
end

function Character:discard(e)
    --Equipment e/Spell e
    if e.value then
        self.dust = self.dust + e.value * (e.count and e.count or 1)
    end
end

function Character:spend(i)
    --number i
    --loose i dust
    self.dust = self.dust-i
end

function Character:pack(e)
    --Equipment e/Spell e
    --adds the given item to the backpack
    --uses the first availible slot
    --returns false if no slots availible
    for i=1,self.bpSize do
        if not self.bp[i] or condense(self.bp[i],e) then
            self.bp[i] = e
            return true
        end
    end
    self:discard(e)
    return false
end

function Character:equip(e,slot)
    --Equipment e/Spell e
    --String slot
    --adds the given item to the given slot
    slot = slot or e.slot --if slot not given use e's default slot
    if self.equiped[slot] then
        if not condense(self.equiped[slot],e) then self:pack(self.equiped[slot]) end 
    end
    self.equiped[slot] = e
end
--/STORAGE

--COMBAT
function Character:damage(val)
    --number val
    --distributes taken damage to highest priority candidates
        --amongst equipment and character
    for i=1,val do
        local e --index of item to damage
        for i=1,#self.slots do
            local ie = self.equiped[self.slots[i]]
            if ie then
                if not e or HitPriority(ie) > HitPriority(e) then
                    e = ie
                end
            end
        end
        if not e or HitPriority(self) > HitPriority(e) then
            self.hits = self.hits + 1
        else
            e:damage(1)
        end
    end
end


function Character:getAttack(i)
    --number i
    --returns the attack of the weapon stored at the given index
    local e = self.equiped[self.slots[i]] 
    if e then
        return e.atk
    else
        return nil
    end
end

function Character:used(i)
    --number i
    --calls the used method of the item at the given index
    local e = self.equiped[self.slots[i]]
    if e.used then
        e:used()
    end
end

function Character:isDead()
    --returns true if the player is dead
    return IsDead(self)
end
