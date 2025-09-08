add({
    source = 'yetone/avante.nvim',
    monitor = 'main',
    depends = {
        'nvim-treesitter/nvim-treesitter',
        'stevearc/dressing.nvim',
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'echasnovski/mini.icons'
    },
    hooks = { post_checkout = function() vim.cmd('make') end }
})