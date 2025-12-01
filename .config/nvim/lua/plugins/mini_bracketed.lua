later(function()
    require('mini.bracketed').setup({
        -- Disable diagnostic navigation since LSP handles it
        diagnostic = { suffix = '' },  -- Disable [d and ]d mappings
    })
end)