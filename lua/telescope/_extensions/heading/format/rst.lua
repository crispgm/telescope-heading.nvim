local ReStructuredText = {}

local function is_heading(line, char)
    for i = 1, #line do
        local c = line:sub(i, i)
        if c ~= char then
            return false
        end
    end

    return true
end

function ReStructuredText.get_headings(filepath, start, total)
    local headings = {}
    local index = start
    -- not all, but all recommended
    local sectionChars = {
        '=',
        '-',
        '`',
        ':',
        '.',
        "'",
        '"',
        '~',
        '^',
        '_',
        '*',
        '+',
        '#',
    }
    local last_line = ''
    local line_mode = 0 -- 1: overline, 2: underline
    -- luacheck: no unused
    local line_top = 0 -- for underline, there is no line_top, only line_bottom
    local line_title = 0
    local line_bottom = 0
    local heading = ''
    while index <= total do
        local line = vim.fn.getline(index)
        for _, char in pairs(sectionChars) do
            if is_heading(line, char) then
                if last_line == '' then -- overline start
                    line_mode = 1
                    line_top = string.len(line)
                else
                    if line_mode == 1 then -- overline end
                        line_title = string.len(last_line)
                        line_bottom = string.len(line)
                        if
                            line_top == line_title
                            and line_title == line_bottom
                        then
                            heading = last_line
                        end
                    else -- underline
                        line_title = string.len(last_line)
                        line_bottom = string.len(line)
                        if line_title == line_bottom then
                            heading = last_line
                            line_mode = 2
                        end
                    end
                end
                if #heading > 0 then
                    table.insert(headings, {
                        heading = vim.trim(heading),
                        line = index,
                        path = filepath,
                    })
                    -- reset
                    heading = ''
                    line_mode = 0
                    line_top, line_bottom, line_title = 0, 0, 0
                end

                break
            end
        end

        last_line = line
        index = index + 1
    end

    return headings
end

function ReStructuredText.ts_get_headings(filepath, bufnr)
    local ts = vim.treesitter
    local query = [[
    (section) (title) @section_title
    ]]
    local parse_query = ts.query.parse or ts.parse_query
    local parsed_query = parse_query('rst', query)
    local parser = ts.get_parser(bufnr, 'rst')
    local root = parser:parse()[1]:root()
    local start_row, _, end_row, _ = root:range()

    local headings = {}
    for _, node in parsed_query:iter_captures(root, bufnr, start_row, end_row) do
        local row, _ = node:range()
        local line = vim.fn.getline(row + 1)
        table.insert(headings, {
            heading = vim.trim(line),
            line = row + 1,
            path = filepath,
        })
    end
    return headings
end

return ReStructuredText
