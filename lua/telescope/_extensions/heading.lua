local telescope_installed, telescope = pcall(require, 'telescope')

if not telescope_installed then
    error('This plugin requires nvim-telescope/telescope.nvim')
end

local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')
local actions_set = require('telescope.actions.set')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local heading_config = require('telescope._extensions.heading.config')

local function filetype()
    local ft_maps = {
        ['vimwiki'] = 'markdown',
        ['pandoc'] = 'markdown',
        ['markdown.pandoc'] = 'markdown',
        ['markdown.gfm'] = 'markdown',
        ['tex'] = 'latex',
        ['help'] = 'vimdoc',
        ['asciidoctor'] = 'asciidoc',
    }
    local ft = vim.bo.filetype
    if ft_maps[ft] ~= nil then
        ft = ft_maps[ft]
    end

    return ft
end

local function support_treesitter(ft)
    local ts_ft_maps = {
        ['beancount'] = true,
        ['markdown'] = true,
        ['rst'] = true,
        ['vimdoc'] = true,
        ['norg'] = true,
    }

    if ts_ft_maps[ft] ~= nil then
        return ts_ft_maps[ft]
    end
    return false
end

local function get_headings()
    local ft = filetype()
    local mod_path =
        string.format('telescope._extensions.heading.format.%s', ft)
    local ok, mod = pcall(require, mod_path)
    if not ok then
        vim.notify(
            'The file type is not supported by telescope-heading',
            vim.log.levels.WARN,
            { title = 'Telescope Heading' }
        )
        return nil
    end

    local index, total = 1, vim.fn.line('$')
    local bufnr = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    if heading_config.treesitter and support_treesitter(ft) then
        if vim._ts_has_language(ft) then
            return mod.ts_get_headings(filepath, bufnr)
        else
            vim.notify(
                string.format(
                    'No treesitter language parser installed for [%s]. Fallback to normal parser.',
                    ft
                ),
                vim.log.levels.WARN,
                { title = 'Telescope Heading' }
            )
        end
    end

    return mod.get_headings(filepath, index, total)
end

local function pick_headings(opts)
    opts = vim.tbl_deep_extend('keep', opts or {}, heading_config.picker_opts)

    local headings = get_headings()
    if headings == nil then
        return
    end
    pickers
        .new(opts, {
            prompt_title = 'Select a heading',
            results_title = 'Headings',
            finder = finders.new_table({
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
            }),
            previewer = conf.qflist_previewer(opts),
            sorter = conf.file_sorter(opts),
            attach_mappings = function(prompt_bufnr)
                actions_set.select:replace(function()
                    local entry = actions_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    vim.cmd(string.format('%d', entry.value))
                end)
                return true
            end,
        })
        :find()
end

return telescope.register_extension({
    setup = heading_config.setup,
    exports = {
        heading = pick_headings,
    },
})
