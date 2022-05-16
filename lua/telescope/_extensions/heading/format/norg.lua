local Neorg = {}

function Neorg.get_headings(filepath, start, total)
    local headings = {}
    local index = start
    local matches = {
        '* ',
        '** ',
        '*** ',
        '**** ',
        '***** ',
        '****** ',
    }
    while index <= total do
        local line = vim.fn.getline(index)
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

        index = index + 1
    end

    return headings
end

return Neorg
