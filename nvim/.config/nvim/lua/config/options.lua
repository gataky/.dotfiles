-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.opt.colorcolumn = "79"
vim.opt.clipboard = ""

vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldlevel = 10
vim.o.foldlevelstart = 10
vim.o.foldenable = true

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4

vim.g.fugitive_gitlab_domains = { "https://gitlab.zgtools.net" }

vim.opt.spelllang = "en_us"
vim.opt.spell = true
