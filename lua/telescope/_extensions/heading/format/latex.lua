local Latex = {}

local function skipSyntax(lnum, col)
    local syntaxstack = vim.fn.synstack(lnum, col)
    local name

    for _, syntax in ipairs(syntaxstack) do
        name = vim.fn.synIDattr(syntax, 'name')

        -- disallow math sections
        if string.find(name, '^texMath') then
            return true
        end
    end

    return false
end

function Latex.get_headings(filepath, start, total)
    local headings = {}
    local index = start
    local matches = {
        '\\part',
        '\\chapter',
        '\\section',
        '\\subsection',
        '\\subsubsection',
        '\\paragraph',
        '\\subparagraph',
    }

    while index <= total do
        local line = vim.fn.getline(index)
        local trimmedline = string.gsub(line, '^%s+', '')
        local skip

        -- checks if line begins with a \\ (for performance reasons).
        -- if it does begin with \\, we need to check the syntax stack.
        -- otherwise, it will never match, so we can skip entirely
        if string.find(trimmedline, '^\\') ~= nil then
            local firstWordCol = string.len(line) - string.len(trimmedline) + 1
            skip = skipSyntax(index, firstWordCol)
        else
            skip = true
        end

        -- goes to next line
        if skip then
            goto next
        end

        for _, pattern in pairs(matches) do
            if string.find(trimmedline, '^' .. pattern) ~= nil then
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

return Latex
