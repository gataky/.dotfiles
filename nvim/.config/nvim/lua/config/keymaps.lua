-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jk", "<esc>")

local opts = {
    noremap = true,
    silent = true,
}

vim.keymap.set("n", "<c-s-H>", "<c-w>H", opts)
vim.keymap.set("n", "<c-s-J>", "<c-w>J", opts)
vim.keymap.set("n", "<c-s-K>", "<c-w>K", opts)
vim.keymap.set("n", "<c-s-L>", "<c-w>L", opts)
vim.keymap.set("n", "<c-s-R>", "<c-w>R", opts)

-- vim.keymap.del("n", "<leader>gg")
-- vim.keymap.del("n", "<leader>gG")

-- stylua: ignore start
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy from system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>Y', '"+yg_', { desc = 'Copy from system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard' })
-- stylua: ignore end

vim.keymap.set("n", "<F12>c", [[:exe ":silent !open -a 'Google Chrome' %"<cr>]])

vim.keymap.set("n", "<leader>r", function()
    package.loaded["foo"] = nil
    require("foo")
end)

vim.keymap.set("n", "vx", function()
    require("foo").select()
end)

vim.keymap.set("n", "dx", function()
    require("foo").delete()
end)
