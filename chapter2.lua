-- 八皇后问题
local N = 8
local count = 0
-- 检查下一行位置是否正确
local function isPlaceOk(a, n , c) 
    count = count + 1
    for i = 1, n - 1 do
        if (a[i] == c) or
        (a[i] - i == c - n) or
        (a[i] + i == c + n) then
            return false
        end
    end
    return true
end

-- 打印棋盘
local function printSolution(a) 
    for i = 1, N do
        for j = 1, N do
            io.write(a[i] == j and "X" or "-", " ")
        end
        io.write("\n")
    end
    io.write("\n")
end

-- 放置皇后
local function addQueen(a, n)
    if n > N then
        printSolution(a)
        -- os.exit()
    else
        for c = 1, N do
            if isPlaceOk(a, n, c) then
                a[n] = c
                addQueen(a, n + 1)
            end
        end
    end
end

-- addQueen({}, 1)
-- print(count)

---练习2.2 解决八皇后问题的另一种方式是，先生成 1-8 之间的所有排列，然后依此遍历这些排列，检查每一个排列是否是问题的有效解。
---请使用这种方法编写程序，并对比新旧程序之间的性能差异(提示: 比较调用isplaceok 函数的次数)
local q = {}
local function addQueen2()
    for a = 1, N do
        q[1] = a
        for b = 1, N do
            q[2] = b
            for c = 1, N do
                q[3] = c
                for d = 1, N do
                    q[4] = d
                    for e = 1, N do
                        q[5] = e
                        for f = 1, N do
                            q[6] = f
                            for g = 1, N do
                                q[7] = g
                                for h = 1, N do
                                    q[8] = h
                                    local isOk = false
                                    for row = 2, N do
                                        isOk = isPlaceOk(q, row, q[row])
                                        if not isOk then
                                            break
                                        end
                                    end
                                    if isOk then
                                        printSolution(q)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

addQueen2()
print(count)