--code to run the primary game loop
--maybe probably should be multiple files

require "Zombie"
require "Equip"
require "Attack"
require "Character"
require "Spell"
require "Tools"

local function placeItem(player, e)
    --Characters player
    --Equip e
    --an interface for placing an item in a player's storage
    --returns false is item is discarded
    io.write(e:txt())
    if e.cost then io.write("Costs " .. e.cost .. " Dust\n") end
    if e.value then io.write("Worth " .. e.value .. " Dust\n") end
    io.write("1=> Equip\n2=> Pack\n3=> Discard")
    if e.value then io.write(" for Dust") end
    io.write("\nSelect: ")
    local c = io.read()
    if c == "1" then
        player:equip(e)
        return true
    elseif c == "3" then
        player:discard(e)
        return false
    else
        return player:pack(e)
    end
end

local function merch(player, e)
    --Character player
    --Equip e (with cost)
    --promps player with a chance to purchase an item
    io.write("Your sponsor genoroursly offers you:\n")
    if placeItem(player, e) then
        player:spend(e.cost)
    end
end

local function combat(player, zombies)
    --Character player
    --Zombie[] zombies
    --runs combat between the give combatants
    --returns false if the character dies in battle
    --probably should be spread accross way more funcs than is
    local zCount = #zombies --store number of live zombies
    while player and zCount > 0 do
        --the main loop
        --display
        printBreak()
        for k,v in pairs(zombies) do
            io.write( "Shambler " .. k .. "=> " .. v:txt() .. "\n\n" )
        end
        io.write(player:txt())  
        --attack
        io.write("\nSelect attack (leave blank to abstain): ")
        local c = io.read()
        if c ~= "" and player:getAttack(tonumber(c)) then
            c = tonumber(c)
            local atk = player:getAttack(c)
            --targeting
            local targets
            if atk.targets >= zCount then
                targets = zombies
            else
                targets = {}
                for i=1,atk.targets do
                    io.write("\nSelect target " .. i .. "/" .. atk.targets .. ": ")
                    local c = tonumber(io.read())
                    if c then targets[c] = zombies[c] end
                end
            end
            --run attack
            for k,v in pairs(targets) do
                atk:run(v, player:getDxt(), 0)
            end
            player:used(c)
        elseif not c then
            --CRTL D TO SURRENDER
            return false
        end
        --upkeep
        for k,v in pairs(zombies) do
            v:turn()
            if v:isExploding() then
               io.write("\nShambler " .. k .. " Explodes.")
               v:explode(player)
            end
            if v:isDead() then
                if v:willDrop() then 
                    io.write("\nShambler " .. k .. " Drops: ")
                    placeItem(player,v.drop)
                end
                zombies[k] = nil
                zCount = zCount - 1 --decriment number of z's
                if zCount <= 0 then return true end
            end
        end
        player:turn()
        if player:isDead() then
            --end combat if the player is dead
            return false
        end
    end
end

local function genPlayer()
    --returns a shiny new outfited player character
    local p = Character:new(3) --BASE HR(r)
    local a = Attack:new(3,1)
    local e = Equip:new("Bulk Pistol", "main", 0, {40,20}, { atk = a })
    local eq = Equip:new("Tin Plate", "chest", 0, {50,40,30})
    p:equip(e); p:equip(eq)
    return p
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

local function genZsWithTutorial(r)
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

local function genMerch(r,dust)
    --number r,dust
    --returns an item to be sold durring given round with given max cost
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

function gameLoop(player,sr,genZombies,genMerch)
    --Character player
    --number sr ("sigma rounds")
    --Func genZombies, genMerch
    --runs the core game loop for given player
    --returns true if the player survives sr rounds
    for r=1,sr do
        printBreak()
        --round begin animation
        io.write("\nRound " .. r .. "/" .. sr .. " ")
        for i=1,3 do io.write(".") end --; wait(0.5) end
        io.write("BEGIN!\n")
        --/animation
        if not combat(player, genZombies(r)) then --GEN Z'S MAY NEED MORE ARGS
            io.write("\nYOU ARE DEAD. Your sponsor is ashamed.")
            return false
        end
        --insert inventory manip?
        ---[[
        if r~=sr then --don't need to buy gear after killed all z's
            local e = genMerch(r,player.dust)
            if e then
                printBreak()
                merch(player,e)
            end
        end
        --]]
        --insert inventory manip?
    end
    return true
end

function main()
    --start the game
    if gameLoop(genPlayer(),3,genZsWithTutorial,genMerch) then io.write("\nVICTORY! Your sponsor is proud of you.") end
    io.read() --wait to close
end

main()
