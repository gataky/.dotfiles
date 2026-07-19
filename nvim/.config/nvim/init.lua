-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        -- Uncomment next line to use 'stable' branch
        -- '--branch', 'stable',
        'https://github.com/nvim-mini/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end


local deps = require('mini.deps')
_G.add = deps.add     -- Make 'add' global
_G.now = deps.now     -- Make 'now' global
_G.later = deps.later -- Make 'later' global
deps.setup({ path = { package = path_package } })


-- Load core settings
require('core.options')
require('core.keymaps')
require('core.autocmd')
require('core.greek')

-- Optional machine/employer-specific overrides (gitignored, see local.lua.example)
pcall(require, 'local')

-- Functional modules
require('ui')          -- first: colorscheme loads immediately to avoid flash
require('editing')
require('completion')  -- before lsp: lsp reads mini.completion capabilities
require('navigation')
require('git')
require('testing')
require('http')
require('lang')

-- Load LSP configurations
require('lsp')
