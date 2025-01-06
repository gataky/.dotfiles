return {
    "williamboman/mason.nvim",
    enabled = false,
    opts = function(_, opts)
        -- add tsx and treesitter
        vim.list_extend(opts.ensure_installed, {})
    end,
}
