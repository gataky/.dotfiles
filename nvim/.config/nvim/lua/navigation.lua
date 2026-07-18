-- ui to help search for anything really
add({
    source = 'nvim-telescope/telescope.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
})

later(function()
    local telescope = require('telescope')
    telescope.setup({})

    vim.api.nvim_set_keymap('n', "<C-p>", '', {
        callback = function() require('telescope.builtin').find_files({ hidden = true, find_command = { 'rg', '--files' } }) end,
        noremap = true,
    })
    vim.api.nvim_set_keymap('n', '<leader>sw', '', {
        callback = function() require('telescope.builtin').grep_string() end,
        noremap = true,
    })
    vim.api.nvim_set_keymap('n', '<leader>sg', '', {
        callback = function() require('telescope.builtin').live_grep() end,
        noremap = true,
    })
    vim.api.nvim_set_keymap('n', '<leader>gf', '', {
        callback = function() require('telescope.builtin').git_files() end,
        noremap = true,
    })
end)

-- file tree
add({
    source = 'nvim-neo-tree/neo-tree.nvim',
    checkout = 'v3.x',
    depends = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, but recommended
    }
})

later(function()
    require('neo-tree').setup({
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
            },
            use_libuv_file_watcher = true,
        },
        default_component_configs = {
            indent = {
                with_expanders = true,
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
        },
    })

    vim.api.nvim_set_keymap('n', '<leader>e', ':Neotree toggle reveal<cr>', { noremap = true, expr = false })
end)

-- navigating between wim windows and tmux panes
add({ source = 'alexghergh/nvim-tmux-navigation' })

later(function()
    require('nvim-tmux-navigation').setup({})
    vim.api.nvim_set_keymap('n', "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", { noremap = true })
    vim.api.nvim_set_keymap('n', "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", { noremap = true })
    vim.api.nvim_set_keymap('n', "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", { noremap = true })
    vim.api.nvim_set_keymap('n', "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", { noremap = true })
end)
