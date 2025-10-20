-- ui to help search for anything really
add({
    source = 'nvim-telescope/telescope.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
})

later(function()
    local telescope = require('telescope')
    telescope.setup({})

    vim.api.nvim_set_keymap('n', "<C-p>", '', {
        callback = function() require('telescope.builtin').find_files({ hidden = true, find_command = { 'rg', '--files' } }) end,
        noremap = true,
    })
    vim.api.nvim_set_keymap('n', '<leader>sw', '', {
        callback = function() require('telescope.builtin').grep_string() end,
        noremap = true,
    })
    vim.api.nvim_set_keymap('n', '<leader>sg', '', {
        callback = function() require('telescope.builtin').live_grep() end,
        noremap = true,
    })
    vim.api.nvim_set_keymap('n', '<leader>gf', '', {
        callback = function() require('telescope.builtin').git_files() end,
        noremap = true,
    })
end)
