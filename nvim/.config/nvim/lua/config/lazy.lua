local lazypath = vim.fn.stdpath("data") .. "/current/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    -- bootstrap lazy.nvim
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
    spec = {
        {
            "catppuccin/nvim",
            name = "catppuccin",
            priority = 1000,
        },
        {
            "rebelot/kanagawa.nvim",
            name = "kanagawa",
            priority = 1000,
            opts = {
                compile = false,  -- enable compiling the colorscheme
                undercurl = true, -- enable undercurls
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = true,    -- do not set background color
                dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
                terminalColors = true, -- define vim.g.terminal_color_{0,17}
                colors = {             -- add/modify theme and palette colors
                    palette = {},
                    theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
                },
                overrides = function(colors) -- add/modify highlights
                    return {}
                end,
                theme = "dragon", -- Load "wave" theme when 'background' option is not set
                -- background = { -- map the value of 'background' option to a theme
                --     dark = "dragon", -- try "dragon" !
                --     light = "lotus",
                -- },
            },
        },
        {
            "ellisonleao/gruvbox.nvim",
            priority = 1000,
            config = true,
            opts = {
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = true,
                    emphasis = true,
                    comments = true,
                    operators = false,
                    folds = true,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "",  -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = true,
                transparent_mode = true,
            },
        },
        {
            "savq/melange-nvim",
            lazy = false,
            priority = 1000,
        },
        -- add LazyVim and import its plugins
        {
            "LazyVim/LazyVim",
            import = "lazyvim.plugins",
            opts = {
                colorscheme = "gruvbox",
            },
        },

        -- import any extras modules here
        { import = "lazyvim.plugins.extras.coding.yanky" },
        { import = "lazyvim.plugins.extras.coding.codeium" },
        { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
        { import = "lazyvim.plugins.extras.test.core" },
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.lang.python" },
        { import = "lazyvim.plugins.extras.lang.go" },
        { import = "lazyvim.plugins.extras.lang.clangd" },
        { import = "lazyvim.plugins.extras.lang.terraform" },
        { import = "lazyvim.plugins.extras.lang.json" },

        { import = "lazyvim.plugins.extras.dap.core" },

        -- import/override with your plugins
        { import = "plugins" },
    },
    defaults = {
        -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
        -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
        lazy = true,
        -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
        -- have outdated releases, which may break your Neovim install.
        version = false, -- always use the latest git commit
        -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    install = {
        colorscheme = { "catppuccin", "tokyonight", "habamax", "gruvbox" },
    },
    checker = { enabled = false }, -- automatically check for plugin updates
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
