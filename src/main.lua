--code to run the primary game loop
--maybe probably should be multiple files

require "Zombie"
require "Attack"
require "Character"
require "Spell"
require "Tools"

require "GenMerch"
require "GenZombies"

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
        io.write("\n--Foes--\n")
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
            if v:isDead() then
                --if died from causes other then exploding
                io.write("\nYou have slain Shambler " .. k)
                io.read() --wait for player end
            end
            if v:isExploding() then
                io.write("\nShambler " .. k .. " Explodes.")
                v:explode(player)
                io.read() --wait for player
            end
            if v:isDead() then
                if v:willDrop() then 
                    io.write("\nAs it dies, Shambler " .. k .. " drops: ")
                    placeItem(player,v.drop)
                end
                zombies[k] = nil
                zCount = zCount - 1 --decriment number of z's
                if zCount <= 0 then return not player:isDead() end
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
            --defeat message
            io.write("\nYOU ARE DEAD. Your sponsor is ashamed.")
            return false
        else
            --victory message
            if math.random(2)==1 then
                io.write("\nThe crowd cheers")
            else
                io.write("\nYour Sponsor smiles")
            end
            io.write("; you have survived the round.")
        end
        --insert inventory manip?
        if r~=sr then --don't need to buy gear after killed all z's
            local e = genMerch(r,player.dust,sr)
            if e then
                printBreak()
                merch(player,e)
            end
        end
        --insert inventory manip?
    end
    return true
end

function main()
    --start the game
    textScroll("../data/Opening.txt")
    if gameLoop(genPlayer(),3,GenZsWithTutorial,GenMerch) then io.write("\nVICTORY! Your sponsor is proud of you.") end
    io.read() --wait to close
end

main()
