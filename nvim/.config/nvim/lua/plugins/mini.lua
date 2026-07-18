later(function() require('mini.align').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.cursorword').setup() end)
later(function() require('mini.fuzzy').setup() end)
later(function() require('mini.indentscope').setup() end)
later(function() require('mini.jump').setup() end)
later(function() require('mini.jump2d').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.surround').setup() end)

now(function() require('mini.git').setup() end)
now(function() require('mini.notify').setup() end)

now(function()
    require('mini.basics').setup({
        mappings = {
            basic = false,   -- Disable basic mappings
            option_toggle_prefix = [[\]],
            windows = false, -- Disable window mappings
            move_with_alt = false,
        },
    })
end)

later(function()
    require('mini.bufremove').setup()

    vim.api.nvim_set_keymap('n', '<c-c>', '', {
        callback = function()
            require('mini.bufremove').wipeout()
        end
    })
end)

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
    imap_expr('<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
    imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
end)

now(function()
    require('mini.hipatterns').setup({
        highlighters = {
            fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
            hack  = { pattern = 'HACK', group = 'MiniHipatternsHack' },
            todo  = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
            note  = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
        }
    })
end)

now(function()
    local icons = require('mini.icons')
    icons.setup()
    icons.tweak_lsp_kind()
end)


now(function()
    local tabline = require('mini.tabline')

    local format = function(buf_id, label)
        local suffix = vim.bo[buf_id].modified and '+ ' or ''
        return tabline.default_format(buf_id, label) .. suffix
    end
    tabline.setup({
        format = format,
    })
end)

later(function()
    require('mini.trailspace').setup()
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
            local trailspace = require('mini.trailspace')
            trailspace.trim()
            trailspace.trim_last_lines()
        end,
    })
end)
