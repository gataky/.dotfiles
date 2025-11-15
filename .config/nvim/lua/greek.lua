-- Set up Greek keymap
vim.opt.keymap = "greek"
vim.opt.iminsert = 0     -- Start with English in insert mode
vim.opt.imsearch = 0     -- Use English for search
vim.g.persistent_greek = false

-- When leaving insert mode, turn off Greek unless persistent mode is on
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
        if not vim.g.persistent_greek then
            vim.opt.iminsert = 0
        end
    end,
})

-- When entering insert mode, turn on Greek if persistent mode is on
vim.api.nvim_create_autocmd("InsertEnter", {
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
        vim.opt.iminsert = 1  -- Turn on Greek
        print("Greek mode ON")
    else
        vim.opt.iminsert = 0  -- Turn off Greek
        print("Greek mode OFF")
    end
end, { noremap = true, desc = 'Toggle persistent Greek input' })
