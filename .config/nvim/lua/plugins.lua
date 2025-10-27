
-- Core functionality plugins
require('plugins.lspconfig')
require('plugins.mason')
require('plugins.treesitter')
require('plugins.conform')

-- File management and navigation
require('plugins.telescope')
require('plugins.neo_tree')
require('plugins.tmux_navigation')

-- Git integration
require('plugins.neogit')
require('plugins.diffview')

-- Development tools
require('plugins.neotest')
require('plugins.render_markdown')
-- require('plugins.avante')

-- Mini plugins
require('plugins.mini_basics')
require('plugins.mini_git')
require('plugins.mini_icons')
require('plugins.mini_tabline')
require('plugins.mini_statusline')
require('plugins.mini_notify')
require('plugins.mini_hipatterns')
require('plugins.mini_completion')
require('plugins.mini_align')
require('plugins.mini_bracketed')
require('plugins.mini_comment')
require('plugins.mini_cursorword')
require('plugins.mini_fuzzy')
require('plugins.mini_indentscope')
-- require('plugins.mini_jump')
-- require('plugins.mini_jump2d')
require('plugins.mini_surround')
require('plugins.mini_bufremove')
require('plugins.mini_trailspace')

require('plugins.nvim_colorizer')

-- -- Local plugins
-- local utilities_dir = vim.fn.expand("~/Documents/utilities.nvim")
-- if vim.fn.isdirectory(utilities_dir) ~= 0 then
--     vim.opt.runtimepath:append(vim.fn.expand(utilities_dir))
--     add({ source = utilities_dir, checkout = "HEAD" })
--
--     local utils = require("utilities")
--     local opts = { noremap = true, silent = true }
--     vim.api.nvim_set_keymap('n', '<leader>ou', utils.open_url_under_cursor, opts)
--     vim.api.nvim_set_keymap('v', '<leader>gl', utils.get_repo_link_for_selection, opts)
-- end
