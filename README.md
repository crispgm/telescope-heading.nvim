# telescope-heading.nvim

An extension for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) that allows you to switch between headings.

It is very simple and only supports Markdown headings from h1 to h6.

## Setup

```lua
paq 'nvim-telescope/telescope.nvim'
paq 'crispgm/telescope-heading.nvim'
```

You can setup the extension by adding the following to your config:
```lua
require'telescope'.load_extension('heading')
```

## Usage

```viml
:Telescope heading
```
