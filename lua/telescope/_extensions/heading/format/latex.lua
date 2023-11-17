local Latex = {}

local disallowedEnvs = {
    'texMath',
    'texComment',
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

local ArticleHeadingMaker = {}
ArticleHeadingMaker.__index = ArticleHeadingMaker

function ArticleHeadingMaker:new (matches)
    local heading_counts = {}
    for _, m in ipairs(matches) do
        heading_counts[m] = 0
    end
    return setmetatable({
        heading_counts = heading_counts,
    }, ArticleHeadingMaker)
end

function ArticleHeadingMaker:update_counter(heading_name)
    if heading_name == "section" then
        self.heading_counts["subsection"] = 0
        self.heading_counts["subsubsection"] = 0
    elseif heading_name == "subsection" then
        self.heading_counts["subsubsection"] = 0
    end
    self.heading_counts[heading_name] = self.heading_counts[heading_name] + 1
end

function ArticleHeadingMaker:make_display_name(heading_name, section_title)
    local section_num = nil
    if heading_name == "section" then
        section_num = self.heading_counts["section"]
    elseif heading_name == "subsection" then
        section_num = self.heading_counts["section"] .. "."
                      .. self.heading_counts["subsection"]
    elseif heading_name == "subsubsection" then
        section_num = self.heading_counts["section"] .. "."
                      .. self.heading_counts["subsection"] .. "."
                      .. self.heading_counts["subsubsection"]
    end
    if section_title == nil then
        return section_title
    else
        return section_num .. ". " .. section_title
    end
end

function Latex.get_headings(filepath, start, total, opts)
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
    local article_heading_maker = ArticleHeadingMaker:new(matches)

    -- allows syntax of matchtable[headingname]
    for _, m in ipairs(matches) do
        matchtable[m] = true
    end

    while index <= total do
        local line = vim.fn.getline(index)
        local trimmedline = string.gsub(line, '^%s+', '')
        local headingname = string.match(trimmedline, '^\\%l+') or ''
        headingname = string.sub(headingname, 2)
        local skip

        if matchtable[headingname] then
            local firstWordCol = string.len(line) - string.len(trimmedline) + 1
            skip = isDisallowedEnv(index, firstWordCol)
        else
            skip = true
        end

        if not skip then
            local pattern = "\\" .. headingname .. "{([^}]*)}"
            local section_title = string.match(vim.trim(line), pattern)
            local display_name = nil
            if opts.use_section_number then
                article_heading_maker:update_counter(headingname)
                display_name = article_heading_maker:make_display_name(headingname, section_title
 )
            end
            table.insert(headings, {
                heading = vim.trim(line),
                display = display_name,
                line = index,
                path = filepath,
            })
        end

        index = index + 1
    end

    return headings
end

return Latex
