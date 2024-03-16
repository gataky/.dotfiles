return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0
                and vim.api
                        .nvim_buf_get_lines(0, line - 1, line, true)[1]
                        :sub(col, col)
                        :match("%s")
                    == nil
        end

        local luasnip = require("luasnip")
        local cmp = require("cmp")
        opts.window = {
            completion = {
                side_padding = 1,
                border = "rounded",
                scrollbar = false,
            },
            documentation = {
                border = "rounded",
            },
        }

        opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
            { name = "codeium" },
            { name = "emoji" },
        }))

        opts.sorting = {
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                cmp.config.compare.recently_used,
                cmp.config.compare.locality,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        }

        opts.mapping = vim.tbl_extend("force", opts.mapping, {
            ["<cr>"] = cmp.mapping.confirm({ select = true }),
            ["<tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<s-tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<c-p>"] = cmp.mapping.select_prev_item(),
            ["<c-n>"] = cmp.mapping.select_next_item(),
            ["<c-u>"] = cmp.mapping.scroll_docs(-4),
            ["<c-f>"] = cmp.mapping.scroll_docs(4),
            ["<c-e>"] = cmp.mapping.abort(),
            ["<c-]>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-[>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        })
    end,
}
