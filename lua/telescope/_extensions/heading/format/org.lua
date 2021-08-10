local OrgMode = {}

function OrgMode.get_headings(filepath, start, total)
    local headings = {}
    local index = start
    local matches = {
        '* ',
        '** ',
        '*** ',
    }
    local is_code_block = false
    while index <= total do
        local line = vim.fn.getline(index)
        -- process code/example blocks
        if vim.startswith(line, '----') then
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

return OrgMode
