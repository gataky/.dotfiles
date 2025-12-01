-- tools for installing lsps/formatters/linters...
add({
    source = 'williamboman/mason.nvim',
})

later(function()
    require('mason').setup({
        ui = {
            border = 'rounded',
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    })
end)