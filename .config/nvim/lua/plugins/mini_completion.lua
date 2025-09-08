now(function()
    require('mini.completion').setup({
        window = {
            info = { height = 25, width = 80 },
            signature = { height = 25, width = 80 },
        },
    })
    local imap_expr = function(lhs, rhs)
      vim.keymap.set('i', lhs, rhs, { expr = true })
    end
    imap_expr('<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
    imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
end)