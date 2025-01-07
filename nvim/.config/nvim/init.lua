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
    depends = { 'williamboman/mason-lspconfig.nvim' }
})

-- colors
add({ source = 'sainnhe/gruvbox-material' })

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
    require('mini.notify').setup({ window = { config = { border = border } } })
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
            info = { height = 25, width = 80, border = border },
            signature = { height = 25, width = 80, border = border },
        },
    })
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
        },
        highlight = { enable = true },
    })
end)

--                                                                                        lspconfig
now(function()
    local lspconfig = require('lspconfig')
    vim.diagnostic.config({
        virtual_text = false,
        float = { border = border },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = diag_signs.ERROR,
                [vim.diagnostic.severity.WARN] = diag_signs.WARN,
                [vim.diagnostic.severity.INFO] = diag_signs.INFO,
                [vim.diagnostic.severity.HINT] = diag_signs.HINT,
            },
        },
    })

    ---LSP handler that adds extra inline highlights, keymaps, and window options.
    ---Code inspired from `noice`.
    ---@param handler fun(err: any, result: any, ctx: any, config: any): integer, integer
    ---@return function
    local function enhanced_float_handler(handler)
        return function(err, result, ctx, config)
            local buf, win = handler(
                err,
                result,
                ctx,
                vim.tbl_deep_extend('force', config or {}, {
                    border = 'rounded',
                    max_height = math.floor(vim.o.lines * 0.5),
                    max_width = math.floor(vim.o.columns * 0.4),
                })
            )

            if not buf or not win then
                return
            end

            -- Conceal everything.
            vim.wo[win].concealcursor = 'n'

            -- Add keymaps for opening links.
            if not vim.b[buf].markdown_keys then
                vim.keymap.set('n', 'K', function()
                    -- Vim help links.
                    local url = (vim.fn.expand '<cWORD>' --[[@as string]]):match '|(%S-)|'
                    if url then
                        return vim.cmd.help(url)
                    end

                    -- Markdown links.
                    local col = vim.api.nvim_win_get_cursor(0)[2] + 1
                    local from, to
                    from, to, url = vim.api.nvim_get_current_line():find '%[.-%]%((%S-)%)'
                    if from and col >= from and col <= to then
                        vim.system({ 'open', url }, nil, function(res)
                            if res.code ~= 0 then
                                vim.notify('Failed to open URL' .. url, vim.log.levels.ERROR)
                            end
                        end)
                    end
                end, { buffer = buf, silent = true })
                vim.b[buf].markdown_keys = true
            end
        end
    end

    local function organize_imports(client, bufnr)
        local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
        params.context = { only = { "source.organizeImports" } }

        local resp = client.request_sync("textDocument/codeAction", params, 3000, bufnr)
        for _, r in pairs(resp and resp.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end

    local methods = vim.lsp.protocol.Methods
    vim.lsp.handlers[methods.textDocument_hover] = enhanced_float_handler(vim.lsp.handlers.hover)
    vim.lsp.handlers[methods.textDocument_signatureHelp] = enhanced_float_handler(vim.lsp.handlers.signature_help)

    lspconfig.gopls.setup({
        on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    organize_imports(client, bufnr)
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end,
    })

    lspconfig.basedpyright.setup {}
    lspconfig.lua_ls.setup({
        on_init = function(client)
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT'
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME
                    }
                }
            })
        end,
        settings = {
            Lua = {}
        }
    })
    vim.api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], {
        noremap = true, expr = true
    })
    vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], {
        noremap = true, expr = true
    })

    vim.api.nvim_create_augroup("LspFormatting", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        group = "LspFormatting",
        callback = function()
            vim.lsp.buf.format({
                timeout_ms = 2000,
                filter = function(clients)
                    return vim.tbl_filter(function(client)
                        return pcall(function(_client)
                            return _client.config.settings.autoFixOnSave or false
                        end, client)
                    end, clients)
                end,
            })
        end,
    })


    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
            vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
                opts)
            vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>f", function() require("conform").format() end, opts)
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
        end,
    })
end)

-- ================================================================================================
local later = deps.later

later(function() require('mini.align').setup() end)
later(function() require('mini.animate').setup() end)
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
    require("mason-lspconfig").setup()
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
    telescope.setup()

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
