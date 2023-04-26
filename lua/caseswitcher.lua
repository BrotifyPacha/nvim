local M = {}

local function splitCamelCase(word)
    local parts = {}

    local singleWord = ""
    for i = 1, #word do
        local c = word:sub(i,i)

        if c:lower() ~= c and singleWord ~= "" then
            parts[#parts+1] = singleWord
            singleWord = ""
        end

        singleWord = singleWord .. c:lower()
    end
    parts[#parts+1] = singleWord

    return parts
end

local function splitByStr(word, str)
    local parts = {}

    for part in vim.gsplit(word, str, { plain=true }) do
        if part ~= "" then
            parts[#parts+1] = part:lower()
        end
    end

    return parts
end

local function splitSnakeCase(word)
    return splitByStr(word, '_')
end

local function splitKebabCase(word)
    return splitByStr(word, '-')
end

local splitters = {
    {
        name = "camel",
        split = splitCamelCase,
    },
    {
        name = "snake",
        split = splitSnakeCase,
    },
    {
        name = "kebab",
        split = splitKebabCase,
    },
}

local function test_split_funcs()
    local tests = {
        {
            splitter = "camel",
            word = "helloWorld",
            want = { "hello", "world" }
        },
        {
            splitter = "camel",
            word = "HelloWorld",
            want = { "hello", "world" }
        },
        {
            splitter = "camel",
            word = "HelloWorld-Borld",
            want = { "hello", "world-", "borld" }
        },
        {
            splitter = "snake",
            word = "HeLlo_WoRld",
            want = { "hello", "world" }
        },
        {
            splitter = "kebab",
            word = "Hello-WorlD",
            want = { "hello", "world" }
        },
        {
            splitter = "kebab",
            word = "hello-World-",
            want = { "hello", "world" }
        },
    }
    for i = 1, #tests do
        local t = tests[i]
        local want = t.want
        local got = {}
        if t.splitter == "camel" then
            got = splitCamelCase(t.word)
        elseif t.splitter == "snake" then
            got = splitSnakeCase(t.word)
        elseif t.splitter == "kebab" then
            got = splitKebabCase(t.word)
        end
        local equal = table.concat(want) == table.concat(got) and #want == #got
        assert(equal, "splitter = " .. t.splitter .. "; word = '".. t.word .."' failed; want = ".. vim.inspect(t.want) .. " got = " .. vim.inspect(got))
    end
end

test_split_funcs()

function M.splitParts(word)
    parts = { word }
    for _, splitter in ipairs(splitters) do
        local subParts = {}
        for _, p in ipairs(parts) do
            tmp = splitter.split(p)
            subParts = vim.list_extend(subParts, tmp)
        end
        parts = subParts
    end
    return parts
end

local function tbl_join(list, str)
    local result = ""
    for i, item in ipairs(list) do
        result = result .. item
        if i ~= #list then
            result = result .. str
        end
    end
    return result
end

local combiners = {
    {
        name = "pascal", -- HelloWorld
        func = function (list)
            local result = ""
            for _, item in ipairs(list) do
                result = result .. item:sub(1,1):upper() .. item:sub(2,#item)
            end
            return result
        end
    },
    {
        name = "camel", -- helloWorld
        func = function (list)
            local result = ""
            for i, item in ipairs(list) do
                if i == 1 then
                    result = item
                else
                    result = result .. item:sub(1,1):upper() .. item:sub(2,#item)
                end
            end
            return result
        end
    },
    {
        name = "snake", -- hello_world
        func = function (list)
            return tbl_join(list, "_")
        end
    },
    {
        name = "snake-screaming", -- hello_world
        func = function (list)
            return tbl_join(list, "_"):upper()
        end
    },
    {
        name = "kebab", -- hello-world
        func = function (list)
            return tbl_join(list, "-")
        end
    },
    {
        name = "kebab-screaming", -- HELLO-WORLD
        func = function (list)
            return tbl_join(list, "-"):upper()
        end
    },
}

function M.combineParts(combiner, list)
    for _, c in ipairs(combiners) do
        if c.name == combiner then
            return c.func(list)
        end
    end
    return tbl_join(list, "")
end

local function test_integrated()
    local tests = {
        {
            combiner = "camel",
            word = "Hello_world",
            want = "helloWorld",
        }
    }

    for _, t in ipairs(tests) do
        local parts = M.splitParts(t.word)
        local got = M.combineParts(t.combiner, parts)
        assert(got == t.want, "word = '".. t.word .."' combiner = '".. t.combiner .. "' parts = " .. vim.inspect(parts) .." want = '".. t.want .."' got = '".. got .."'")
    end
end

test_integrated()

function M.swapCaseOfWordUnderCursor(style)
    vim.fn.execute('normal! mm')
    local word = vim.fn.expand('<cword>')
    local parts = M.splitParts(word)
    local swapped = M.combineParts(style, parts)
    vim.fn.execute('normal! ciw' .. swapped)
    vim.fn.execute('normal! `m')
    return swapped
end

return M
