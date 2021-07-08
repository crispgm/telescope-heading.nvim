set rtp+=.
set rtp+=../telescope.nvim/

runtime! plugin/telescope.vim
lua require('telescope').load_extension('heading')
