---练习7.1 请编写一个程序，该程序读取一个文本文件然后将每行的内容按照字母表顺序排序后重写该文件。
---如果调用时不带参数，则从标准输入读取并向标准输出写入；
---如果调用时传入一个文件名作为参数，则从该文件中读取并向标准输出写入；
---如果调用时传入两个文件名作为参数，则从第一个文件读取并将结果写入第二个文件中

---练习7.2  改写7.1的程序，使得当指定的输出文件已经存在时，要求用户确认。
local function file_exists(name)
    local f = io.open(name, 'r')
    if f then
        io.close(f)
        return true
    end
    return false
end

local function sortAndWrite(inputFile, outputFile)
    local function writeHelper(str)
        local t = {string.byte(str, 1, -1)}
        table.sort(t)
        str = string.char(table.unpack(t))
        io.write(str, '\n')
    end
    local of = nil
    if outputFile then
        if (file_exists(outputFile)) then
            local signal = ''
            local fmt = string.format('File %s is already existed, do you want to rewtire it?(yes/no)', outputFile)
                while signal ~= 'YES' and signal ~= 'NO' do
                    print(fmt)
                    signal = string.upper(io.read())
                end
                if signal == 'YES' then
                    of = io.output(outputFile)
                end
        else
            of = io.output(outputFile)
        end
    end
    if inputFile then
        for line in io.lines(inputFile) do
            writeHelper(line)
        end
    else
        writeHelper(io.read())
    end
    if not of then
        print()
    end
end
-- sortAndWrite("7_1_input.txt","7_1_output.txt")

---练习7.3 
---对比使用下列几种不同的方式把标准输入流复制到标准输出流中的Lua程序的性能表现
---● 按字节  ● 按行  ● 按块（每块大小8KB） ● 一次性读取整个文件

---对于最后一种情况，输入文件最大支持多大
---答:取决于解释器能分配的最大内存，不过最好一次性不要操作几十mb以上的文件（参见 www.lua.org/pil/21.2.1.html）
local function formatcost(type, time)
    return type .. 'cost time: ' .. time .. 's\n'
end

local function test7_3()
    assert(io.input('7_2_input.txt'))
    local str = io.read('a')
    local bytes = {string.byte(str)}
    local startTime;

    startTime = os.time()
    for i = 1, #bytes do
        io.write(bytes[i])
    end
    local cost1 = os.difftime(os.time(), startTime)

    startTime = os.time()
    for line in io.lines('7_2_input.txt') do
        io.write(line)
    end
    local cost2 = os.difftime(os.time(), startTime)
    
    startTime = os.time()
    for block in io.input():lines(2^13) do
        io.write(block)
    end
    local cost3 = os.difftime(os.time(), startTime)

    startTime = os.time()
    io.write(str)
    print()
    local cost4 = os.difftime(os.time(), startTime)
    print("==============cost===============")
    print(formatcost('cost1', cost1))
    print(formatcost('cost2', cost2))
    print(formatcost('cost3', cost3))
    print(formatcost('cost4', cost4))
end

test7_3()


---练习7.4 请编写一个程序，该程序输出一个文本文件的最后一行。当文件较大时且可以使用seek时，尝试避免读取整个文件来完成。
---练习7.5 请将7.4的程序修改得更加通用，使其可以输出一个文本文件得最后n行。当文件较大时且可以使用seek时，尝试避免读取整个文件来完成。
-- TODO