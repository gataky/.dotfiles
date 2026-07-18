-- Set up Greek keymap
vim.opt.keymap = "greek"
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.g.persistent_greek = false

-- Create an augroup to keep autocmds organized and prevent duplicates
local greek_group = vim.api.nvim_create_augroup("GreekKeyboard", { clear = true })

-- When leaving insert mode, turn off Greek unless persistent mode is on
vim.api.nvim_create_autocmd("InsertLeave", {
    group = greek_group,
    pattern = "*",
    callback = function()
        if not vim.g.persistent_greek then
            vim.opt.iminsert = 0
            vim.opt.imsearch = 0  -- Also reset search to be consistent
        end
    end,
})

-- When entering insert mode, turn on Greek if persistent mode is on
vim.api.nvim_create_autocmd("InsertEnter", {
    group = greek_group,
    pattern = "*",
    callback = function()
        if vim.g.persistent_greek then
            vim.opt.iminsert = 1
            vim.opt.imsearch = 1
        end
    end,
})

-- Toggle persistent Greek mode
vim.keymap.set('n', '<leader>gr', function()
    vim.g.persistent_greek = not vim.g.persistent_greek
    if vim.g.persistent_greek then
        vim.opt.iminsert = 1
        vim.opt.imsearch = 1
        print("Greek mode ON")
    else
        vim.opt.iminsert = 0
        vim.opt.imsearch = 0
        print("Greek mode OFF")
    end
end, { noremap = true, silent = false, desc = 'Toggle persistent Greek input' })

-- Optional: Add a keymap to temporarily toggle Greek without affecting persistent mode
vim.keymap.set('i', '<C-^>', '<C-^>', { desc = 'Temporarily toggle Greek input' })
