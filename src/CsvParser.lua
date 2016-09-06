--a simple library for parsing csv documents
--present build does not support quoted values

function ParseCsvLine(line,sep,qt,verbose)
    --string line
    --stirng sep
    --string qt
    --bool verbose
    --parses the given csv line
    --returns as an array
    sep = sep or ","
    qt = qt or "\""
    local r = {} --track found values
    local p = 1 --track begining of current value
    local qtd = false --track if inside quote
    local wqtd = false --if marks should be included in qtd vals
    for i=1,string.len(line)+1 do
        if verbose then print("Checking char " .. i .. "; Marker is at " .. p) end
        if i == string.len(line)+1 --if it is the end
                or (not qtd and string.sub(line,i,i) == sep) --or a comma outside a quote
                or (qtd and string.sub(line,i,i) == qt and (string.sub(line,i+1,i+1) == sep or string.len(line) == i)) then
                    --or a quote followed by a comma or line end
            local t = string.sub(line,p,i-1)
            if verbose then print("Adding value: " .. t) end
            table.insert(r,t or "")
            p = i+(wqtd and 2 or 1)
            qtd = false
            wqtd = false
        elseif string.sub(line,i,i) == qt then
            --check in begining a quoted value
            qtd = true
            if p==i then 
                p=p+1
                wqtd = true
            end
        end
    end
    return r
end

function ParseCSV(path,sep,com,qt,verbose)
    --string path
    --string sep (allows for values sepporated by chars other than ,)
    --string com,qt
    --(chars use to mark rows as comments and values with special char to be ignored, respectively)
    --bool verbose
    --parses the csv at the given path
    --returns a 2D array
    sep = sep or ","
    com = com or "--"
    qt = qt or "\""
    local r = {}
    if verbose then print("Begining...") end
    for line in io.lines(path) do
        if verbose then print("Checking next line...") end
        if string.sub(line,1,string.len(com)) ~= com then --if the line is not a comment
            if verbose then print("Reading next line...") end
            table.insert(r,ParseCsvLine(line,sep,qt,verbose))
        end
    end
    return r
end
