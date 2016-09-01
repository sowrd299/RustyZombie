--consturcts objects based on constructor params given in csv
require "CsvParser"

function CsvConsrut(path,class,format)
    --string path
    --(class) table class
        --must have a "new" function
    --Func[] format
    local t = ParseCSV(path)
    local r = {}
    for i=1,#t do
        local args = t[i]
        if format then
            for j=1,#args do
                if format[j] then
                    args[j] = format[j](args[i])
                end
            end
        end
        r[i] = class:new(unpack(args))
    end
end
