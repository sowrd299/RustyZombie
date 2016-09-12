--a class for loading weapon data from soft code
--build ontop of CsvConstruct

--perhaps should be more closely tied to classes

if not CsvConstruct then require "CsvConstruct" end
if not Spell then require "Spell" end
if not Attack then require "Attack" end
if not Equip then require "Equip" end

local function loadKwargs(arg)
    --string arg
    --parses key word arguments from given softcode
    local t = ParseCsvLine(arg,".")
    local r = {}
    for i=1,#t,2 do
        --special kwargs
        if t[i] == "atk" then
            r[t[i]] = CsvConstructObj(t[i+1],Attack,{tonumber,tonumber,loadKwargs})
        else
        --default case
            r[t[i]] = tonumber(t[i+1])
        end
    end
    return r
end

function loadHPR(line)
    --string line
    --returns the line, parsed to number[]
    local r = ParseCsvLine(line,".") 
    for i=1,#r do
        r[i] = tonumber(r[i])
    end
    return r
end

local eFormat = { nil, nil, tonumber, loadHPR, loadKwargs } 
local sFormat = { nil, nil, tonumber, tonumber, loadKwargs } 

function LoadEquipData(path)
    --string path
    --returns Equip[] built from given csv file
    return CsvConstruct(path, Equip, eFormat)    
end

function LoadSpellData(path)
    --string path
    --returns Spell[] built from given csv file
    return CsvConstruct(path, Spell, sFormat)
end
