add({
  source = "nvim-neotest/neotest",
  depends = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    "nvim-neotest/neotest-python"
  }
})

later(function()
  require("neotest").setup({
  adapters = {
    require("neotest-python")
  }
})
end)