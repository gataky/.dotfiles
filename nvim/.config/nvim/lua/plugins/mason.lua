return {
    "williamboman/mason.nvim",
    opts = function(_, opts)
        -- add tsx and treesitter
        vim.list_extend(opts.ensure_installed, {})
    end,
}
