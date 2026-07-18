now(function()
    require('mini.basics').setup({
        mappings = {
            basic = false,  -- Disable basic mappings
            option_toggle_prefix = [[\]],
            windows = false,  -- Disable window mappings
            move_with_alt = false,
        },
    })
end)