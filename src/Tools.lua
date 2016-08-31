--a lua library of useful functions for text-based games

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

function textScroll(path)
    --string path
    --scrolls line-by line through the file at the given path
    for line in io.lines(path) do
        io.write(line,"\n")
        io.read()
    end
end
