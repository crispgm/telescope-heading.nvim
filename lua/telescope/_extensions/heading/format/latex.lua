local Latex = {}

local disallowedEnvs = {
    'texMath',
    'texComment'
}

local function isDisallowedEnv(lnum, col)
    local syntaxstack = vim.fn.synstack(lnum, col)
    local name

    for _, syntax in ipairs(syntaxstack) do
        name = vim.fn.synIDattr(syntax, 'name')

        -- disallowed environments
        for _, env in ipairs(disallowedEnvs) do
            if string.match(name, '^' .. env) then
                return true
            end
        end
    end

    return false
end

function Latex.get_headings(filepath, start, total)
    local headings = {}
    local index = start
    local matchtable = {}
    local matches = {
        'part',
        'chapter',
        'section',
        'subsection',
        'subsubsection',
        'paragraph',
        'subparagraph',
    }

    -- allows syntax of matchtable[headingname]
    for _, m in ipairs(matches) do
        matchtable[m] = ''
    end

    while index <= total do
        local line = vim.fn.getline(index)
        local trimmedline = string.gsub(line, '^%s+', '')
        local headingname = string.match(trimmedline, '^\\%l+') or ''
        headingname = string.sub(headingname, 2)
        local skip = false

        if matchtable[headingname] then
            local firstWordCol = string.len(line) - string.len(trimmedline) + 1
            skip = isDisallowedEnv(index, firstWordCol)
        else
            skip = true
        end

        if not skip then
            table.insert(headings, {
                heading = vim.trim(line),
                line = index,
                path = filepath,
            })
        end

        index = index + 1
    end

    return headings
end

return Latex
