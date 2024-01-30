---练习4.1 请问如何在Lua程序中以字符串的方式使用如下的XML片段?
local s1 = [=[
<![CDATA[
   Hello world
]]>
]=]
local s2 = "<![CDATA[\n Hello world\n]]>"
---练习4.2 假设你需要以字符串的常量形式定义一组包含歧义的转义字符序列 你会使用哪种方式？
---请考虑诸如可读性、每行最大长度及字符串最大长度问题
local s3 = "\n \a \b \f \n \r \t \v \\ \" \'"
---练习4.3 请编写一个函数，使其实现在某个字符串的指定位置插入另一个字符串
local function checkString(str)
    if type(str) ~= "string" then
        str = tostring(str)
    end
    return str
end

function string.insert(s1, pos, s2)
    s1 = checkString(s1)
    if not s2 then
        return s1
    end
    s2 = checkString(s2)
    pos = pos or 1
    local len = string.len(s1)
    if pos <= 1 then
        return s2 .. s1
    elseif pos >= len + 1 then
        return s1 .. s2
    end
    local pre, suf = string.sub(s1, 1, pos - 1), string.sub(s1, pos, len)
    return pre .. s2 .. suf
end

print(string.insert("hello world", 1, "start: "))
print(string.insert("hello world", 7, "small "))

---练习4.4 请使用UTF-8字符串重写 insert("ação", 5, "!"))
function string.utf8Insert(s1, pos, s2)
    s1 = checkString(s1)
    if not s2 then
        return s1
    end
    s2 = checkString(s2)
    pos = pos or 1
    local utf8Len = utf8.len(s1)
    local len = string.len(s1)
    if pos <= 1 then
        return s2 .. s1
    elseif pos >= utf8Len + 1 then
        return s1 .. s2
    end
    pos = utf8.offset(s1, pos)
    local pre, sub = string.sub(s1, 0, pos - 1 ), string.sub(s1, pos, len)
    return pre .. s2 .. sub
end
print(string.utf8Insert("ação", 2, "!"))


---练习4.5 编写一个函数，该函数用于移除指定字符串中的一部分，移除的部分由起始位置和长度指定。
function string.remove(str, pos, num)
    if not str then
        error('the argument #1 is nil!')
    end
    local len = string.len(str)
    pos = pos or 1
    num = num or len
    if pos <= 1 then
        pos = 1
    elseif pos >= len + 1 then
        return str
    end
    if num <= 0 then
        return str
    end
    local m = math.min(pos + num, len)
    local pre, suf = string.sub(str, 1, pos - 1), string.sub(str, m, len)
    return pre .. suf
end
print(string.remove("abcde", 2, 1))

---练习4.6    使用UTF-8字符串重写 remove("ação", 2, 2)
function string.utf8Remove(str, pos, num)
    if not str then
        error('the argument #1 is nil!')
    end
    local utf8Len = utf8.len(str)
    local len = string.len(str)
    pos = pos or 1
    num = num or utf8Len
    if pos <= 1 then
        pos = 1
    elseif pos >= utf8Len + 1 then
        return str
    end
    if num <= 0 then
        return str
    end
    local m1 = utf8.offset(str, pos)
    local m2 = utf8.offset(str, math.min(pos + num, utf8Len + 0))
    local pre, suf = string.sub(str, 1, m1 - 1), string.sub(str, m2, len)
    return pre .. suf
end
print(string.utf8Remove("ação", 2, 2))
---练习4.7 请编写一个函数判断指定的字符串是否为回文字符串
local function ispail(str)
    if not str then
        return false
    end
    str = checkString(str)
    return str == string.reverse(str)
end

print(ispail("abba"))
print(ispail("1234"))

---练习4.8 重写之前的练习，使得它们忽略空格和标点符号
local pattern = "[%p%s]"
local function ispail2(str)
    if not str then
        return false
    end
    str = checkString(str)
    str = string.gsub(str, pattern, '')
    return str == string.reverse(str)
end
print(ispail2("ste p        ,,,on, no ,,,   pets"))
---练习4.9 使用UTF-8字符串重写之前的练习
function string.utf8reverse(str)
    if not str then
        error("the argument#1 is nil!")
    end
    if str == "" then
        return str
    end
    local array = { utf8.codepoint(str, utf8.offset(str, 1), utf8.offset(str, -1))}
    local rarray = {}
    local len = #array
    for i = len, 1, -1 do
        rarray[len - i + 1] = array[i]
    end
    return utf8.char(table.unpack(rarray))
end

local function ispail_utf8(str)
    if not str then
        error("the argument#1 is nil")
    end
    str = checkString(str)
    str = string.gsub(str, pattern, '')
    return str == string.utf8reverse(str)
end
print(ispail_utf8("上海自来水来自海上"))