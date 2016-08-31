--a general purpose lua library

function wait(i)
    --number i
    --busy wait for i seconds
    local ti = os.time()
    repeat until os.time() > ti + i
end

function printBreak()
    --prints a visual text break
    io.write("\n")
    for i=1,10 do io.write("=") end
    io.write("\n")
end
