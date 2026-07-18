-- navigating between wim windows and tmux panes
add({ source = 'alexghergh/nvim-tmux-navigation' })

later(function()
    require('nvim-tmux-navigation').setup({})
    vim.api.nvim_set_keymap('n', "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", { noremap = true })
    vim.api.nvim_set_keymap('n', "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", { noremap = true })
    vim.api.nvim_set_keymap('n', "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", { noremap = true })
    vim.api.nvim_set_keymap('n', "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", { noremap = true })
end)