local Help = {}

local function is_heading(line, char)
    if #line == 0 then
        return false
    end
    for i = 1, #line do
        local c = line:sub(i, i)
        if c ~= char then
            return false
        end
    end

    return true
end

function Help.get_headings(filepath, start, total)
    local headings = {}
    local index = start
    local last_line = ''
    while index <= total do
        local line = vim.fn.getline(index)
        if is_heading(last_line, '=') then
            local matches = vim.regex('\\*\\S\\+\\*$'):match_str(line)
            if matches ~= nil then
                local heading = ''
                local i = 1
                while i < matches do
                    heading = heading .. line:sub(i, i)
                    i = i + 1
                end
                table.insert(headings, {
                    heading = vim.trim(heading),
                    line = index,
                    path = filepath,
                })
            end
        end
        last_line = line
        index = index + 1
    end

    return headings
end

return Help
