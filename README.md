# telescope-heading.nvim

<p align="center">
  <img alt="Preview" src="https://i.imgur.com/LMdp3Cf.gif" />
</p>

<p align="center">
  <img alt="GitHub CI" src="https://github.com/crispgm/telescope-heading.nvim/actions/workflows/ci.yml/badge.svg" />
  <img alt="GitHub Tag" src="https://img.shields.io/github/v/tag/crispgm/telescope-heading.nvim" />
</p>

An extension for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) that allows you to switch between document's headings.

## Supported File Types

| File Type        | Tree-sitter | Notes                                                          |
| ---------------- | ----------- | -------------------------------------------------------------- |
| AsciiDoc         | ✅          |                                                                |
| Beancount        | ✅          |                                                                |
| LaTeX            | ⬜          |                                                                |
| Markdown         | ✅          | including `vimwiki`, `vim-pandoc-syntax`, and `vim-gfm-syntax` |
| Neorg            | ✅          |                                                                |
| OrgMode          | ⬜          |                                                                |
| ReStructuredText | ✅          |                                                                |
| Vim Help         | ✅          |                                                                |

## Setup

Install with your favorite package manager:

```lua
use('nvim-telescope/telescope.nvim')
use('crispgm/telescope-heading.nvim')
```

You can setup the extension by adding the following to your config:

```lua
require('telescope').load_extension('heading')
```

### Tree-sitter Support

telescope-heading supports Tree-sitter for parsing documents and finding headings. But not all file types are supported, you may check [Supported File Types](#supported-file-types) section and inspect the Tree-sitter column.
```lua
-- add nvim-treesitter
use('nvim-treesitter/nvim-treesitter')

-- make sure you have already installed treesitter modules
require('nvim-treesitter.configs').setup({
    ensure_installed = {
        -- ..
        'markdown',
        'rst',
        -- ..
    },
})

-- enable treesitter parsing
local telescope = require('telescope')
telescope.setup({
    -- ...
    extensions = {
        heading = {
            treesitter = true,
        },
    },
})

-- `load_extension` must be after `telescope.setup`
telescope.load_extension('heading')
```

If `nvim-treesitter` was not correctly loaded, it would have fallen back to normal parsing. You may check `nvim-treesitter` configurations and whether your language is `TSInstall`ed.

### Telescope Picker Options

We may specific picker options for telescope-heading, which overrides the general telescope picker options.

```lua
local telescope = require('telescope')
telescope.setup({
    -- ...
    extensions = {
        heading = {
          picker_opts = {
              layout_config = { width = 0.8, preview_width = 0.5 },
              layout_strategy = 'horizontal',
          },
        },
        -- ...
    },
})
```

## Usage

```viml
:Telescope heading
```

## Development

Init:

```bash
make init
```

Load telescope-heading locally:

```bash
nvim --noplugin -u scripts/minimal_init.vim ./README.md # replace with /path/to/testfile
# or
make test
```

Lint:

```bash
make lint
```

## Contributing

All contributions are welcome.

## License

Copyright 2022 David Zhang. MIT License.
