add({
    source = 'yetone/avante.nvim',
    monitor = 'main',
    depends = {
        'nvim-treesitter/nvim-treesitter',
        'stevearc/dressing.nvim',
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'echasnovski/mini.icons'
    },
    hooks = { post_checkout = function() vim.cmd('make') end }
})

later(function()
    require('avante').setup({
        debug = false,
        provider = "bedrock",
        auto_suggestions_provider = "bedrock",
        providers = {
            bedrock = {
                model = "us.anthropic.claude-sonnet-4-5-20250929-v1:0",
                aws_profile = "zillow-sandbox",
                aws_region = "us-west-2",
                extra_request_body = {
                    temperature = 0,
                    max_tokens = 4096,
                },
            },
        },
        behaviour = {
            auto_suggestions = false,
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            support_paste_from_clipboard = false,
        },
        mappings = {
            ask = "<leader>aa",
            edit = "<leader>ae",
            refresh = "<leader>ar",
            diff = {
                ours = "co",
                theirs = "ct",
                all_theirs = "ca",
                both = "cb",
                cursor = "cc",
                next = "]x",
                prev = "[x",
            },
            suggestion = {
                accept = "<M-l>",
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-]>",
            },
            jump = {
                next = "]]",
                prev = "[[",
            },
            submit = {
                normal = "<CR>",
                insert = "<C-s>",
            },
            sidebar = {
                switch_windows = "<Tab>",
                reverse_switch_windows = "<S-Tab>",
            },
        },
        hints = { enabled = true },
        windows = {
            position = "right",
            wrap = true,
            width = 30,
            sidebar_header = {
                align = "center",
                rounded = true,
            },
        },
        highlights = {
            diff = {
                current = "DiffText",
                incoming = "DiffAdd",
            },
        },
    })
end)
