vim.keymap.set("i", "jk", "<esc>", { noremap = true })
vim.keymap.set("n", "<esc>", ":noh<cr>", { noremap = true })

vim.keymap.set("v", "gy", '"+y', { noremap = true })


vim.keymap.set('n', '<leader>nh', function()
  MiniNotify.show_history()
end, { desc = 'Show notification history' })
