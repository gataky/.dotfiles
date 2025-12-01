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
