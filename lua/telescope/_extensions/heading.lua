local telescope_installed, telescope = pcall(require, 'telescope')

if not telescope_installed then
    error('This plugins requires nvim-telescope/telescope.nvim')
end

local actions = require('telescope.actions')
local actions_set = require('telescope.actions.set')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values

local function get_headings()
    local index, total = 1, vim.fn.line('$')
    local bufnr = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(bufnr)

    local headings = {}
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

local function pick_headings(opts)
    opts = opts or {}

    local headings = get_headings()

    pickers.new(opts, {
        prompt_title = 'Select a heading',
        results_title = 'Headings',
        finder = finders.new_table{
            results = headings,
            entry_maker = function(entry)
                return {
                    value = entry.line,
                    display = entry.heading,
                    ordinal = entry.heading,
                    filename = entry.path,
                    lnum = entry.line,
                }
            end,
        },
        previewer = conf.qflist_previewer(opts),
        sorter = conf.file_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            actions_set.select:replace(function()
                local entry = actions.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd(string.format('%d', entry.value))
            end)
            return true
        end,
    }):find()
end

return telescope.register_extension{
    exports = {
        heading = pick_headings,
    },
}
