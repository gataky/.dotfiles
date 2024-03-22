local diffview_toggle = function()
    local lib = require("diffview.lib")
    local view = lib.get_current_view()
    if view then
        -- Current tabpage is a Diffview; close it
        vim.cmd.DiffviewClose()
    else
        -- No open Diffview exists: open a new one
        vim.cmd.DiffviewOpen()
    end
end

return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {},
        cmd = "Neogit",
        config = true,
        -- stylua: ignore
        keys = {
            { "<leader>gg", function() require("neogit").open() end, desc = "[g]it" },
        },
    },
    {
        "sindrets/diffview.nvim",
        opts = {},
        -- stylua: ignore
        keys = {
            { "<leader>gd", function() diffview_toggle() end, desc = "[G]it [d]iffview toggle" },
            { "<leader>df", function() vim.cmd.DiffviewFileHistory('%') end, desc = "Git [d]iffview file history"},
        },
    },
}
