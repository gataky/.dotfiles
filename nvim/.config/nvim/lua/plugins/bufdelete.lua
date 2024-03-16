return {
  "famiu/bufdelete.nvim",
  -- stylua: ignore
  keys = {
    { "<c-c>", "<cmd>Bdelete<cr>", desc = "[C]lose buffer + keep split" },
    { "<c-x>", ":bdelete<cr>",     desc = "[C]lose buffer + close split" },
  },
}
