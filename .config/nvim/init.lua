-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        'https://github.com/echasnovski/mini.nvim', mini_path
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

-- Load themes
require('themes')

-- Load plugin manager and plugin configs
require('plugins')

-- Load LSP configurations
require('lsp')
