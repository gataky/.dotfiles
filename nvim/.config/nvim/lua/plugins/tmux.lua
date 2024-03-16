return {
    "gataky/navi.nvim",
    dir = "~/Documents/nvim/navi.nvim",
    dev = false,
    opts = {},
    -- config = function(opts)
    --     vim.opt.runtimepath:append("~/Documents/nvim/navi")
    --     require("navi").setup({})
    -- end,
    keys = {
        { "<c-h>", "<cmd> NaviLeft  <cr>", desc = "Move Left" },
        { "<c-j>", "<cmd> NaviDown  <cr>", desc = "Move Down" },
        { "<c-k>", "<cmd> NaviUp    <cr>", desc = "Move Up" },
        { "<c-l>", "<cmd> NaviRight <cr>", desc = "Move Right" },
    },
}
