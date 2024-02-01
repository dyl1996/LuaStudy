--练习5.1 下列代码的输出是什么？为什么？
local sunday = "monday"
local monday = "sunday"
local t = {sunday = "monday",[sunday] = monday}
print(t.sunday, t[sunday], t[t.sunday]) -- ‘monday’ 'sunday' 'sunday'

---练习5.2 考虑如下代码
local a = {}
a.a = a
--- a.a.a.a的值是什么 每个a都一样吗
print(a);
print(a.a);
print(a.a.a);
print(a.a.a.a);
-- 一样 都是table的内存地址
---如果将下列代码追加到上述代码中,现在a.a.a.a的值变成了什么?
-- a.a.a.a = 3
-- a.a变成了3 不再是表 后续的表字段访问会报错

---练习5.3
---假设要创建一个以转义序列为值，以转义序列对应字符串为键的表（参见4.1节）。
---请问应该如何编写构造器?
local t = {
    ['newLine'] = '\n',
    ['alarm'] = '\a',
    ['backSpace'] = '\b'
}
print('Line' .. t['newLine'] .. 'Line')
---练习5.4 在Lua语言中，我们可以使用由系数组成的列表{a0,a1,....,an}来表达多项式an * x^n + an-1 *x^n-1 + .... + a1x + a0
---请编写一个函数，该函数以多项式(使用table表示)和值x为参数，返回结果为对应多项式的值。
local function CalculatePolynomial(a, x)
    local result = 0
    x = x or 0
    if type(a) ~= 'table' or #a <= 0 then
        return result
    end
    for i = 1, #a do
        result = result + a[i] * x^(i - 1)
    end
    return result
end
print(CalculatePolynomial({1, 2, 3}, 2))

---练习5.5 改写上述函数，使之最多使用n个加法和n个乘法（且没有指数）
local function CalculatePolynomial(a, x)
    local result = 0
    x = x or 0
    if type(a) ~= 'table' or #a <= 0 then
        return result
    end
    for i = #a, 1, -1 do
        result = a[i] + result * x
    end
    return result
end
print(CalculatePolynomial({1, 2, 3}, 2))

---练习5.6 请编写一个函数，该函数用于测试指定的表是否为有效的序列
local function isValidSequence(a)
    if type(a) ~= "table" then
        return false
    end
    local keyNums = 0
    for _ in ipairs(a) do
        keyNums = keyNums + 1
    end
    for key in pairs(a) do
        if (math.type(key) == 'integer' and key > keyNums) then
            return false
        end
    end
    return true
end
print(isValidSequence({1,a = 2,3,4}))
print(isValidSequence({1,nil,3,4}))

---练习5.7 请编写一个函数，该函数将指定列表的所有元素插入到另一个列表的指定位置
local function insertAll(source, des, pos)
    for i = 1, #source do
        table.insert(des,  pos, source[i])
        pos = pos + 1
    end
end

local function text_5_7()
    local source = {5, 6, 7}
    local des = {1, 2, 3, 4, 8, 9}
    insertAll(source, des, 5)
    local result = ''
    for i = 1, #des do
        result = result .. des[i]
    end
    print(result)
end
text_5_7()

---练习5.8 表标准库中提供了函数table.concact，该函数将制定表的字符串元素连接在一起。
---请实现该函数，并比较在大数据量情况下与标准库的性能差异 
local function myConcat1(t)
    local result = ''
    for i = 1, #t do
        result = result .. t[i]
    end
    return result
end

local function myConcat2(t)
    local result = {}
    local str, temp
    for i = 1, #t do
        str = tostring(t[i])
        temp = { string.byte(str, 1, #str) }
        for j = 1, #temp do
            result[#result+1] = temp[j]
        end
    end
    return string.char(table.unpack(result))
end

local function test_5_8()
    local a = {}
    for i = 1, 200000 do
        a[i] = 'abc'
    end
    local startTime = os.time()
    local str1 = table.concat(a)
    print('table.concat cost time: ' .. os.time() - startTime .. 's')
    startTime = os.time()
    local str2 = myConcat1(a)
    print('myConcat1 cost time: ' .. os.time() - startTime .. 's')
    startTime = os.time()
    local str3 = myConcat2(a)
    print('myConcat2 cost time: ' .. os.time() - startTime .. 's')
    assert(str1 == str2 and str2 == str3, "check str1 str2 str3 failed")
end

test_5_8()