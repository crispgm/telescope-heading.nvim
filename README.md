# telescope-heading.nvim

[![build](https://github.com/crispgm/telescope-heading.nvim/actions/workflows/ci.yml/badge.svg)](https://github.com/crispgm/telescope-heading.nvim/actions/workflows/ci.yml)

An extension for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) that allows you to switch between headings.

[![asciicast](https://asciinema.org/a/14.png)](https://asciinema.org/a/14)

![screenshot](/screenshot.png)

## Supported File Type

- Markdown, including `vimwiki`, `vim-pandoc-syntax`, and `vim-gfm-syntax`.
- AsciiDoc (experimental)
- LaTeX (experimental)
- OrgMode (experimental)
- ReStructuredText (experimental)
- Vim Help (experimental)

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
