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
            require("neotest-python")({
                dap = { justMyCode = false },
                runner = "pytest"
            })
        }
    })

    -- Run the nearest test
    vim.keymap.set("n", "<leader>tn", function() require("neotest").run.run() end)
    -- Run the current file
    vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%:p")) end)
    -- Show the output
    vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end)
    -- Show the summary panel
    vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end)
end)
