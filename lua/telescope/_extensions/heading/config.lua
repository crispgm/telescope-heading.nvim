local telescope_heading = {
    treesitter = false,
}

telescope_heading.setup = function(opts)
    telescope_heading.treesitter = vim.F.if_nil(opts.treesitter, false)
end

return telescope_heading
