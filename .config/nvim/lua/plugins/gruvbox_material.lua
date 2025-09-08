-- colors
add({ source = 'sainnhe/gruvbox-material' })

now(function()
    vim.g.gruvbox_material_better_performance = 1
    vim.cmd('colorscheme gruvbox-material')
end)