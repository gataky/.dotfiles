now(function() require('mini.git').setup() end)

-- git interaction in nvim
add({ source = 'NeogitOrg/neogit' })

later(function()
    local neogit = require('neogit')
    neogit.setup({
        signs = {
            -- { closed, opened }
            hunk = { "", "" },
            item = { "▷", "▽" },
            section = { "▷", "▽" },
        },
    })
    vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>Neogit<cr>', { noremap = true })
end)

-- git merge conflict resolution
add({ source = 'sindrets/diffview.nvim' })
