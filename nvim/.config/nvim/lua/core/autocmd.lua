-- Built-in treesitter highlighting/indent (no nvim-treesitter plugin).
-- Parsers not bundled with Neovim core are installed by ./install-parsers.sh;
-- this is a no-op for filetypes without a parser installed.
vim.treesitter.language.register("bash", "sh")

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("Treesitter", { clear = true }),
    callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)
        if ok then
            vim.bo[args.buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
        end
    end,
})

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = vim.api.nvim_create_augroup("Color", {}),
    pattern = "*",
    callback = function()
        -- Get the normal background color to match floating windows
        local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg

        -- Get a subtle border color from existing highlight groups
        -- Use the foreground of Comment for a subtle border
        local comment_fg = vim.api.nvim_get_hl(0, { name = "BlinkCmpKindEnum" }).fg

        -- Set border color - subtle foreground, same background as buffer
        local border_color = { fg = comment_fg, bg = normal_bg }

        vim.api.nvim_set_hl(0, "FloatBorder", border_color)
        vim.api.nvim_set_hl(0, "MiniNotifyBorder", border_color)

        vim.api.nvim_set_hl(0, "TelescopePreviewBorder", border_color)
        vim.api.nvim_set_hl(0, "TelescopeResultsBorder", border_color)
        vim.api.nvim_set_hl(0, "TelescopePromptBorder", border_color)

        vim.api.nvim_set_hl(0, "LspFloatWinBorder", border_color)

        -- Set floating window background to match normal buffer background
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal_bg })

        vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "NONE" })
    end,
})

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

-- Never show the quickfix/location window: whatever opens one (`:copen`, `:grep`,
-- `:make`, LSP handlers, plugins) gets bounced into the matching Telescope picker.
-- Set `vim.g.qf_no_telescope = true` (or use `:QfNative`) to opt out temporarily.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("QuickfixToTelescope", { clear = true }),
    pattern = "qf",
    callback = function()
        if vim.g.qf_no_telescope then
            return
        end

        local win = vim.api.nvim_get_current_win()
        local info = vim.fn.getwininfo(win)[1]
        local is_loclist = info ~= nil and info.loclist == 1

        -- Defer: the window is still being set up while FileType fires.
        vim.schedule(function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
            local builtin = require('telescope.builtin')
            if is_loclist then
                builtin.loclist()
            else
                builtin.quickfix()
            end
        end)
    end,
})

-- Escape hatch: `:QfNative copen` runs a command with the interception disabled.
vim.api.nvim_create_user_command("QfNative", function(opts)
    vim.g.qf_no_telescope = true
    pcall(vim.cmd, opts.args ~= "" and opts.args or "copen")
    vim.schedule(function() vim.g.qf_no_telescope = nil end)
end, { nargs = "*", complete = "command", desc = "Run a command with the real quickfix window" })

-- Automatic Centering with Autocommands, when navigating makes sure the spot you're navigating
-- to is centered in the buffer.
vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("CenterJump", { clear = true }),
    callback = function()
        -- Check if the current file type is one where jumping is common
        -- For example, you might exclude files like 'help' or 'packer' windows
        vim.cmd("normal! zz")
    end,
    -- This pattern ensures it runs on most files
    pattern = "*",
})
