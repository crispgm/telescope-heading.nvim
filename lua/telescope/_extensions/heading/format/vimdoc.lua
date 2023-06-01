local Vimdoc = {}

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

function Vimdoc.get_headings(filepath, start, total)
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

function Vimdoc.ts_get_headings(filepath, bufnr)
    local ts = vim.treesitter
    local query = [[
      (h1) @text.title
    ]]
    local parse_query = ts.query.parse or ts.parse_query
    local parsed_query = parse_query('vimdoc', query)
    local parser = ts.get_parser(bufnr, 'vimdoc')
    local root = parser:parse()[1]:root()
    local start_row, _, end_row, _ = root:range()

    local headings = {}
    for _, node in parsed_query:iter_captures(root, bufnr, start_row, end_row) do
        local offset = 2
        local row, _ = node:range()
        local title = vim.fn.getline(row + offset)
        table.insert(headings, {
            heading = vim.trim(title),
            line = row + offset,
            path = filepath,
        })
    end
    return headings
end

return Vimdoc
