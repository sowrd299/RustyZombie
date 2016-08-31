--a simple library for parsing csv documents
--present build does not support quoted values

function ParseCSV(path,sep)
    --string path
    --string sep (allows for values sepporated by chars other than ,)
    --parses the csv at the given path
    --returns a 2D array
    sep = sep or ","
    local r = {}
    for line in io.lines() do
        table.insert(r,parseCsvLine(line,sep))
    end
    return r
end


local function parseCsvLine(line,sep)
    --string line
    --stirng sep
    --parses the given csv line
    --returns as an array
    sep = sep or ","
    local r = {}
    local p = 1
    for i=1,string.len(line) do
        if string.sub(line,i,i) == sep or i=string.len(line) then
            local t = string.sub(p,i-1)
            table.insert(r,t or "")
            p = i+1
        end
    end
    return r
end

