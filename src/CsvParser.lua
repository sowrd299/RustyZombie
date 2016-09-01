--a simple library for parsing csv documents
--present build does not support quoted values

function ParseCsvLine(line,sep,verbose)
    --string line
    --stirng sep
    --bool verbose
    --parses the given csv line
    --returns as an array
    sep = sep or ","
    local r = {}
    local p = 1
    for i=1,string.len(line)+1 do
        if verbose then print("Checking char " .. i .. "; Marker is at " .. p) end
        if i == string.len(line)+1 or string.sub(line,i,i) == sep then
            local t = string.sub(line,p,i-1)
            if verbose then print("Adding value: " .. t) end
            table.insert(r,t or "")
            p = i+1
        end
    end
    return r
end

function ParseCSV(path,sep,verbose)
    --string path
    --string sep (allows for values sepporated by chars other than ,)
    --bool verbose
    --parses the csv at the given path
    --returns a 2D array
    sep = sep or ","
    local r = {}
    if verbose then print("Begining...") end
    for line in io.lines(path) do
        if verbose then print("Reading next line...") end
        table.insert(r,ParseCsvLine(line,sep,verbose))
    end
    return r
end
