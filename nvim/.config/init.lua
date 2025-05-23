-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

local deps = require('mini.deps')
deps.setup({ path = { package = path_package } })
-- ================================================================================================
--       1         2         3         4         5         6         7         8         9         0
-- 456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.

-- icons used for diagnostics, they don't appear to be in mini.icons.  Used by mini.statusline and
-- lspconfig
local diag_signs = { ERROR = '󰅚 ', WARN = '󰀪 ', INFO = ' ', HINT = '󰌶 ' }

-- Try and keep a consistent border for all windows
local border = 'rounded'
vim.o.winborder = 'rounded'

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = vim.api.nvim_create_augroup("Color", {}),
    pattern = "*",
    callback = function()
        -- local color = { fg = "#00ff00" }
        local color = { link = "DiagnosticWarn" }
        --
        vim.api.nvim_set_hl(0, "FloatBorder", color)
        vim.api.nvim_set_hl(0, "MiniNotifyBorder", color)

        vim.api.nvim_set_hl(0, "TelescopePreviewBorder", color)
        vim.api.nvim_set_hl(0, "TelescopeResultsBorder", color)
        vim.api.nvim_set_hl(0, "TelescopePromptBorder", color)

        vim.api.nvim_set_hl(0, "LspFloatWinBorder", color)

        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

        vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "NONE" })
    end,
})

-- ================================================================================================
-- add: used to add additional plugins not part of the mini ecosystem.
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


-- ================================================================================================
local now = deps.now

--                                                                                      mini.basics
now(function()
    require('mini.basics').setup()
    vim.g.mapleader = " "

    vim.g.loaded_python3_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0

    vim.opt.colorcolumn = "100"

    vim.opt.laststatus = 3
    vim.opt.spelllang = "en_us"
    vim.opt.spell = true

    vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
    vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
    vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
    vim.o.shiftwidth = 4

    vim.api.nvim_set_keymap('i', 'jk', '<esc>', { noremap = true, expr = false })
    vim.api.nvim_set_keymap('n', '<esc>', ':noh<cr>', { noremap = true, expr = false })

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

    local active_content = function()
        local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
        local git           = statusline.section_git({ trunc_width = 40 })
        local diagnostics   = statusline.section_diagnostics({
            trunc_width = 75, signs = diag_signs, icon = "",
        })
        local lsp           = statusline.section_lsp({ trunc_width = 75 })
        local filename      = statusline.section_filename({ trunc_width = 140 })
        local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
        local search        = statusline.section_searchcount({ trunc_width = 75 })

        return statusline.combine_groups {
            { hl = mode_hl,                  strings = { mode } },
            "%<", -- Mark general truncate point
            create_statusline_separator(mode_hl, "MiniStatuslineFileinfo", ""),
            { hl = "MiniStatuslineFileinfo", strings = { git, diagnostics, filename } },
            "%=", -- End left alignment
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

--                                                                                              lsp
now(function()
    local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
    local lsp_servers = {}

    if vim.fn.isdirectory(lsp_dir) == 1 then
        for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
            if file:match("%.lua$") then
                local server_name = file:gsub("%.lua$", "")
                table.insert(lsp_servers, server_name)
            end
        end
    end

    local config = {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.INFO] = "",
        },
      },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        source = "always",
        header = "",
        prefix = "",
        suffix = "",
      },
    }
    vim.diagnostic.config(config)

    local on_attach = function(client, buffer)
        local opts = { buffer = buffer }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "H", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>f", function() require("conform").format() end, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", function() require('telescope.builtin').lsp_references() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
    end

    vim.lsp.handlers['client/registerCapability'] = (function(overridden)
      return function(err, res, ctx)
        local result = overridden(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        client.handlers["textDocument/publishDiagnostics"] = function(...) end
        if not client then
          return
        end
        -- Call your custom on_attach logic...
        on_attach(client, vim.api.nvim_get_current_buf())
        return result
      end
    end)(vim.lsp.handlers['client/registerCapability'])

    vim.lsp.config("*", {})
    vim.lsp.enable(lsp_servers)
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

-- Hack for Telescope issue with nvim 0.11
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopeFindPre",
  callback = function()
    vim.opt_local.winborder = "none"
    vim.api.nvim_create_autocmd("WinLeave", {
      once = true,
      callback = function()
        vim.opt_local.winborder = "rounded"
      end,
    })
  end,
})

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
