# telescope-heading.nvim

[![build](https://github.com/crispgm/telescope-heading.nvim/actions/workflows/ci.yml/badge.svg)](https://github.com/crispgm/telescope-heading.nvim/actions/workflows/ci.yml)

An extension for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) that allows you to switch between headings.

![screenshot](/screenshot.png)

[Live Demo](https://asciinema.org/a/410656)

## Supported File Type

- Markdown, including `vimwiki` and `vim-pandoc-syntax`.
- AsciiDoc (experimental)
- OrgMode (experimental)
- ReStructuredText (experimental)

## Setup

```lua
paq 'nvim-telescope/telescope.nvim'
paq 'crispgm/telescope-heading.nvim'
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
