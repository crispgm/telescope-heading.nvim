local telescope_heading = {}

telescope_heading.setup = function(opts)
    telescope_heading.treesitter = opts.treesitter or false
end

return telescope_heading
