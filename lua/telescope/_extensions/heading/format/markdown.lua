local Markdown = {}

function Markdown.get_headings(filepath, start, total)
    local headings = {}
    local index = start
    local matches = {
        '# ',
        '## ',
        '### ',
        '#### ',
        '##### ',
        '###### ',
    }
    local is_code_block = false
    while index <= total do
        local line = vim.fn.getline(index)
        -- process markdown code blocks
        if vim.startswith(line, '```') then
            is_code_block = not is_code_block
            goto next
        else
            if is_code_block then
                goto next
            end
        end
        -- match heading
        for _, pattern in pairs(matches) do
            if vim.startswith(line, pattern) then
                table.insert(headings, {
                    heading = vim.trim(line),
                    line = index,
                    path = filepath,
                })
                break
            end
        end

        ::next::
        index = index + 1
    end

    return headings
end

function Markdown.ts_get_headings(filepath, bufnr)
    local ts = vim.treesitter
    local query = [[
    (atx_heading) @heading
    ]]
    local parsed_query = ts.parse_query('markdown', query)
    local parser = ts.get_parser(bufnr, 'markdown')
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

return Markdown
