-- add({ source = 'nvim-tree/nvim-tree.lua' })
-- add({ source = 'nvim-tree/nvim-web-devicons' })

-- later(function()
--     require("nvim-tree").setup()
--     require('nvim-web-devicons').setup()
--
--     vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<cr>', { noremap = true, expr = false })
-- end)

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
    require('neo-tree').setup({})

    vim.api.nvim_set_keymap('n', '<leader>e', ':Neotree toggle<cr>', { noremap = true, expr = false })
end)
