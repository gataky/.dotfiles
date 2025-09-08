local deps = require('mini.deps')
_G.add = deps.add -- Make 'add' global
_G.now = deps.now -- Make 'now' global
_G.later = deps.later -- Make 'later' global

-- Load individual plugin configurations
require('plugins.lspconfig')
require('plugins.neogit')
require('plugins.diffview')
require('plugins.tmux_navigation')
require('plugins.telescope')
require('plugins.treesitter')
require('plugins.mason')
require('plugins.gruvbox_material')
require('plugins.avante')
require('plugins.render_markdown')
require('plugins.nvim_tree')
require('plugins.conform')
require('plugins.neotest')


local utilities_dir = vim.fn.expand("~/Documents/utilities.nvim")
if vim.fn.isdirectory(utilities_dir) then
    vim.opt.runtimepath:append(vim.fn.expand(utilities_dir))
    add({source = utilities_dir, checkout = "HEAD"})

    -- https://google.com
    vim.api.nvim_set_keymap('n', '<leader>ou', ':lua require("utilities").open_url_under_cursor()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '<leader>gl', ':lua require("utilities").get_repo_link_for_selection()<CR>', { noremap = true, silent = true })

end



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
require('plugins.mini_jump')
require('plugins.mini_jump2d')
-- require('plugins.mini_pairs')
require('plugins.mini_surround')
require('plugins.mini_bufremove')
require('plugins.mini_trailspace')
