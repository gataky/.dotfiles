-- syntax highlighting
add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

now(function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            'bash',
            'go',
            'lua',
            'python',
            'tmux',
            'typescript',
            'vimdoc',
            'javascript',
        },
        highlight = { enable = true },
    })
end)