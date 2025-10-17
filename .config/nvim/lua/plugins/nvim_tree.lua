add({ source = 'nvim-tree/nvim-tree.lua' })
add({ source = 'nvim-tree/nvim-web-devicons' })

later(function()
    require("nvim-tree").setup({
        actions = {
            open_file = {
                quit_on_open = false,
                resize_window = true,
                window_picker = {
                    enable = true,
                    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                    exclude = {
                        filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                        buftype = { "nofile", "terminal", "help" },
                    },
                },
            },
        },
        on_attach = function(bufnr)
            local api = require('nvim-tree.api')
            
            -- Default keymaps
            local function opts(desc)
                return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            
            -- Open in vertical split
            vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
            -- Open in horizontal split  
            vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split'))
            -- Open in tab
            vim.keymap.set('n', 't', api.node.open.tab, opts('Open: New Tab'))
            -- Open in preview
            vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
            -- Toggle preview
            vim.keymap.set('n', 'p', api.node.navigate.parent_close, opts('Close Directory'))
            -- Close node
            vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
        end,
    })
    require('nvim-web-devicons').setup()

    vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<cr>', { noremap = true, expr = false })
end)