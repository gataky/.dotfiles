return {
    "ThePrimeagen/harpoon",
    enabled = true,
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(_, opts)
        local harpoon = require("harpoon"):setup(opts)
        local events = require("harpoon.extensions").event_names
        harpoon:extend({
            [events.UI_CREATE] = function(ids)
                local bg_highlight =
                    vim.api.nvim_get_hl(0, { name = "Normal" }).bg
                vim.api.nvim_win_set_option(
                    ids.win_id,
                    "winhl",
                    "Normal:" .. bg_highlight .. ",FloatBorder:Float"
                )
            end,
        })
    end,
    -- stylua: ignore
    keys = {
        { "<leader>a", function() require("harpoon"):list():append() end, desc = "Harpoon Append" },
        { "<leader>h", function()
                require("harpoon").ui:toggle_quick_menu(require("harpoon"):list(), { border = "rounded", title_pos = "center"})
            end, desc = "Harpoon List" },
        { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon #1" },
        { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon #2" },
        { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon #3" },
        { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon #4" },
    },
}
