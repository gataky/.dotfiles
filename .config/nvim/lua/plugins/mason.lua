-- tools for installing lsps/formatters/linters...
add({
    source = 'williamboman/mason.nvim',
})

later(function()
    require('mason').setup({
        ensure_installed = {
            'basedpyright',
            'gopls',
            'lua-language-server',
            'ruff-lsp',
            'typescript-language-server',
            'vue-language-server',
            'omnisharp',
        },
        ui = {
            border = border,
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    })
end)