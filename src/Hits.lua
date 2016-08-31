--a library of fucntions for objs in the
--the priority-based damage distribution system

local function isHitObj(self)
    --returns true if the given obj has the hit obj interface
    return self.hpr and self.hits
end

function HitsText (self)
    --HitObj self
    --returns string representing given Hit Priorities and Hits taken
    --returns "" if invalid arg given
    if not isHitObj(self) then
        return ""
    end
    local t = "[ "
    for k,v in pairs(self.hpr) do
        --testing
        --io.write("\nTESTING: "..k..","..self.hits.."\n")
        --/testing
        if k <= self.hits then
            t = t .. "X"
        else
            t = t .. v
        end
        t = t .. " "
    end
    t = t .. "]"
    return t
end

function HitPriority(self)
    --Equip self/Character self
    --returns current hit priority of given item
    --returns 0 if invalid argument given (e.g. a spell)
    if not isHitObj(self) or IsDead(self) then 
        return 0
    end
    return self.hpr[self.hits+1]
end

function IsDead(self)
    --returns true if given a hit obj with enough hits to be "dead"
    if not isHitObj(self) then
        return false
    end
    return self.hits >= #self.hpr
end
