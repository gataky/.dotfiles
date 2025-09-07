-- add: used to add additional plugins not part of the mini ecosystem.
local deps = require('mini.deps')
local add = deps.add

-- helpful for setting up lsp support
add({ source = 'neovim/nvim-lspconfig' })

-- git interaction in nvim
add({ source = 'NeogitOrg/neogit' })

-- git merge conflict resolution
add({ source = 'sindrets/diffview.nvim' })

-- navigating between wim windows and tmux panes
add({ source = 'alexghergh/nvim-tmux-navigation' })

-- ui to help search for anything really
add({
    source = 'nvim-telescope/telescope.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
})

-- syntax highlighting
add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

-- tools for installing lsps/formatters/linters...
add({
    source = 'williamboman/mason.nvim',
})

-- colors
add({ source = 'sainnhe/gruvbox-material' })

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
add({ source = 'MeanderingProgrammer/render-markdown.nvim' })

add({ source = 'nvim-tree/nvim-tree.lua' })
add({ source = 'nvim-tree/nvim-web-devicons' })
add({ source = 'stevearc/conform.nvim'})

add({
  source = "nvim-neotest/neotest",
  depends = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    "nvim-neotest/neotest-python"
  }
})

-- ================================================================================================
local now = deps.now

--                                                                                      mini.basics
now(function()
    require('mini.basics').setup()
end)

--                                                                                         mini.git
now(function()
    require('mini.git').setup()
end)

--                                                                                gruvbox-material
now(function()
    vim.g.gruvbox_material_better_performance = 1
    vim.cmd('colorscheme gruvbox-material')
end)

--                                                                                       mini.icons
now(function()
    local icons = require('mini.icons')
    icons.setup()
    icons.tweak_lsp_kind()
end)

--                                                                                     mini.tabline
now(function()
    local tabline = require('mini.tabline')

    local format = function(buf_id, label)
        local suffix = vim.bo[buf_id].modified and '+ ' or ''
        return tabline.default_format(buf_id, label) .. suffix
    end
    tabline.setup({
        format = format,
    })
end)

--                                                                                  mini.statusline
now(function()
    local statusline = require('mini.statusline')

    local error = "DiagnosticError"
    local warn = "DiagnosticWarn"
    local info = "DiagnosticInfo"
    local hint = "DiagnosticHint"
    local diag_signs = {
      ERROR = string.format("%%#%s#%s", error, " "),
      WARN  = string.format("%%#%s#%s", warn, " "),
      INFO  = string.format("%%#%s#%s", info, " "),
      HINT  = string.format("%%#%s#%s", hint, ""),
    }

    local create_statusline_separator = function(before_hl, after_hl, char)
        local hl_name = string.format("Statusline%s%s", before_hl, after_hl)
        vim.cmd(
            string.format(
                [[ hi! %s guifg=%s guibg=%s ]],
                hl_name,
                string.format("#%06x", vim.api.nvim_get_hl_by_name(before_hl, true).background),
                string.format("#%06x", vim.api.nvim_get_hl_by_name(after_hl, true).background)
            )
        )
        return "%#" .. hl_name .. "#" .. char
    end

    vim.cmd([[hi! MiniStatuslineGit guibg=#0085cc guifg=#ebdbb2]])
    vim.cmd([[hi! MiniStatuslineFilename guibg=#504945 guifg=#ebdbb2]])


    local active_content = function()
        local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
        local git           = statusline.section_git({ trunc_width = 40 })
        local diagnostics   = statusline.section_diagnostics({
            trunc_width = 75, use_icons = true, signs = diag_signs,
        })
        local lsp           = statusline.section_lsp({ trunc_width = 75 })
        local filename      = statusline.section_filename({ trunc_width = 140 })
        local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
        local search        = statusline.section_searchcount({ trunc_width = 75 })

        return statusline.combine_groups {
            { hl = mode_hl,                  strings = { mode } },
            "%<", -- Mark general truncate point
            create_statusline_separator(mode_hl, "MiniStatuslineGit", ""),
            { hl = "MiniStatuslineGit", strings = { git } },
            create_statusline_separator("MiniStatuslineGit", "MiniStatuslineFilename", ""),
            { hl = "MiniStatuslineFilename", strings = { filename } },
            create_statusline_separator("MiniStatuslineFilename", "MiniStatuslineFileinfo", ""),
            "%=", -- End left alignment
            { hl = "MiniStatuslineFileinfo", strings = { diagnostics } },
            create_statusline_separator("MiniStatuslineFileinfo", "MiniStatuslineModeOther", ""),
            { hl = "MiniStatuslineModeOther", strings = { lsp } },
            create_statusline_separator("MiniStatuslineModeOther", mode_hl, ""),
            { hl = mode_hl,                   strings = { fileinfo } },
            { hl = mode_hl,                   strings = { search } },
        }
    end

    statusline.setup({ content = { active = active_content } })
end)

--                                                                                      mini.notify
now(function()
    -- require('mini.notify').setup({ window = { config = { border = border } } })
    require('mini.notify').setup()
end)

--                                                                                  mini.hipatterns
now(function()
    require('mini.hipatterns').setup({
        highlighters = {
            fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
            hack  = { pattern = 'HACK', group = 'MiniHipatternsHack' },
            todo  = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
            note  = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
        }
    })
end)

--                                                                                  mini.completion
now(function()
    require('mini.completion').setup({
        window = {
            info = { height = 25, width = 80 },
            signature = { height = 25, width = 80 },
        },
    })
    local imap_expr = function(lhs, rhs)
      vim.keymap.set('i', lhs, rhs, { expr = true })
    end
    imap_expr('<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
    imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
end)

--                                                                                       treesitter
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

-- ================================================================================================
local later = deps.later

later(function() require('mini.align').setup() end)
-- later(function() require('mini.animate').setup() end)
later(function() require('mini.bracketed').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.cursorword').setup() end)
later(function() require('mini.fuzzy').setup() end)
later(function() require('mini.indentscope').setup() end)
later(function() require('mini.jump').setup() end)
later(function() require('mini.jump2d').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.surround').setup() end)
--                                                                                   mini.bufremove
later(function()
    require('mini.bufremove').setup()

    vim.api.nvim_set_keymap('n', '<c-c>', '', {
        callback = function()
            require('mini.bufremove').wipeout()
        end
    })
end)
--                                                                                  mini.trailspace
later(function()
    require('mini.trailspace').setup()
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
            local trailspace = require('mini.trailspace')
            trailspace.trim()
            trailspace.trim_last_lines()
        end,
    })
end)
--                                                                                            mason
later(function()
    require('mason').setup({
        ensure_installed = {
            'basedpyright',
            'gopls',
            'lua-language-server',
            'ruff-lsp',
            'typescript-language-server',
            'vue-language-server',
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
--                                                                             nvim-tmux-navigation
later(function()
    require('nvim-tmux-navigation').setup({})
    vim.api.nvim_set_keymap('n', "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", { noremap = true })
    vim.api.nvim_set_keymap('n', "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", { noremap = true })
    vim.api.nvim_set_keymap('n', "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", { noremap = true })
    vim.api.nvim_set_keymap('n', "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", { noremap = true })
end)
--                                                                                           neogit
later(function()
    local neogit = require('neogit')
    neogit.setup({
        signs = {
            -- { closed, opened }
            hunk = { "", "" },
            item = { "▷", "▽" },
            section = { "▷", "▽" },
        },
    })
    vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>Neogit<cr>', { noremap = true })
end)
--                                                                                        telescope
later(function()
    local telescope = require('telescope')
    telescope.setup({})

    vim.api.nvim_set_keymap('n', "<C-p>", '', {
        callback = function() require('telescope.builtin').find_files({ hidden = true }) end,
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

--                                                                                  render-markdown
later(function() require('render-markdown').setup({}) end)

--                                                                                        nvim-tree
later(function()
    require("nvim-tree").setup()
    require('nvim-web-devicons').setup()

    vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<cr>', { noremap = true, expr = false })
end)

--                                                                                          conform
later(function()
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "autoflake", "isort", "black" },
    -- -- You can customize some of the format options for the filetype (:help conform.format)
    -- rust = { "rustfmt", lsp_format = "fallback" },
    -- -- Conform will run the first available formatter
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})
end)

later(function()
  require("neotest").setup({
  adapters = {
    require("neotest-python")
  }
})
end)
