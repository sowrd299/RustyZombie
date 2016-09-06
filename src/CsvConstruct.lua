--consturcts objects based on constructor params given in csv
require "CsvParser"

local function constructObj(args,class,format)
    --[] data
    --//for other args see above
    if format then
        for j=1,#args do
            if format[j] then
                args[j] = format[j](args[j])
            end
        end
    end
    return class:new(unpack(args))
end

function CsvConstructObj(data,class,format)
    --string path
    --(class) table class
        --must have a "new" function
    --Func[] format
    --parses an individual line into an object
    return constructObj(ParseCsvLine(data),class,format)
end

function CsvConstruct(path,class,format)
    --string path
    --(class) table class
        --must have a "new" function
    --Func[] format
    --parses a csv file into an array of objs
    --DO MATH TO SEE IF CsvConstructObj APPROACH WOULD BE FASTER
    local t = ParseCSV(path)
    --testing
    --print(#t .. " lines parsed from csv")
    --/testing
    local r = {}
    for i=1,#t do
        --testing
        --print("adding item " .. i .. " to array.")
        --/testing
        r[i] = constructObj(t[i],class,format)
    end
    return r
end
