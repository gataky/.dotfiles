later(function() require('mini.align').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.jump').setup() end)
later(function() require('mini.jump2d').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.surround').setup() end)

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
