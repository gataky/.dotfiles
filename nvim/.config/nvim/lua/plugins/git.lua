-- return {
--   "tpope/vim-fugitive",
--   cmd = "Git",
--   dependencies = { "shumphrey/fugitive-gitlab.vim" },
-- }

return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "sindrets/diffview.nvim", -- optional - Diff integration

        -- Only one of these is needed, not both.
        "nvim-telescope/telescope.nvim", -- optional
        -- "ibhagwan/fzf-lua",              -- optional
    },
    cmd = "Neogit",
    config = true,
}
