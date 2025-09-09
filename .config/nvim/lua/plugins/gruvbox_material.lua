-- Gruvbox Material theme configuration
add({ source = 'sainnhe/gruvbox-material' })

now(function()
    vim.g.gruvbox_material_better_performance = 1
    -- Theme configuration only - colorscheme is set in themes.lua
end)