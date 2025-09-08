add({ source = 'nvim-tree/nvim-tree.lua' })
add({ source = 'nvim-tree/nvim-web-devicons' })

later(function()
    require("nvim-tree").setup()
    require('nvim-web-devicons').setup()

    vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<cr>', { noremap = true, expr = false })
end)