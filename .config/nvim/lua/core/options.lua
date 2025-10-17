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

vim.g.mapleader = " "

-- AWS environment variables for Bedrock
vim.env.AWS_PROFILE = "zillow-sandbox"
vim.env.AWS_REGION = "us-west-2"
vim.env.HOME = vim.fn.expand("~")
-- Ensure AWS CLI and Homebrew curl are in PATH (Homebrew bins should come first)
vim.env.PATH = "/opt/homebrew/bin:/opt/homebrew/opt/curl/bin:" .. vim.env.PATH

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.opt.colorcolumn = "100"

vim.opt.laststatus = 3
vim.opt.spelllang = "en_us"
vim.opt.spell = true

vim.o.relativenumber = true
vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4



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
