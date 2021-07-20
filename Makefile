.PHONY: lint format test

init:
	luarocks install luacheck

lint:
	luacheck lua/

format:
	stylua lua/ --config-path ./.stylua.toml

test:
	nvim --noplugin -u scripts/minimal_init.vim ./README.md
