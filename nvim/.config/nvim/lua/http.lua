-- HTTP/GraphQL/gRPC client for .http/.rest files
add({ source = 'mistweaverco/kulala.nvim' })

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'http', 'rest' },
    once = true,
    callback = function()
        require('kulala').setup({
            global_keymaps = true,
            global_keymaps_prefix = '<leader>r',
        })
    end,
})
