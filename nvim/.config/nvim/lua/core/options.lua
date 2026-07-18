-- Try and keep a consistent border for all windows
local border = 'rounded'
vim.o.winborder = 'rounded'

vim.g.mapleader = " "
vim.o.termguicolors = true

vim.env.HOME = vim.fn.expand("~")
-- Ensure AWS CLI and Homebrew curl are in PATH (Homebrew bins should come first)
vim.env.PATH = "/opt/homebrew/bin:/opt/homebrew/opt/curl/bin:" .. vim.env.PATH

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.opt.colorcolumn = "100"
vim.opt.termguicolors = true

vim.opt.laststatus = 3
vim.opt.spelllang = "en_us"
vim.opt.spell = true

vim.o.relativenumber = true
vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4
