function cap()
    capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )
    capabilities.textDocument.completion.completionItem.snippetSupport = false
    return capabilities
end

local lspconfig = require("lspconfig")
require("lspconfig.configs").gataky = {
    default_config = {
        cmd = { "/Users/jeffor/Projects/lsp/main" },
        filetypes = { "markdown" },
        name = "gataky",
        root_dir = lspconfig.util.root_pattern("go.mod"),
    },
}

return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            capabilities = cap(),
            diagnostics = {
                virtual_text = false,
            },
            servers = {
                gataky = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            format = {
                                enable = true,
                                defaultConfig = {
                                    indent_style = "space",
                                    indent_size = "4",
                                },
                            },
                        },
                    },
                },
                rust_analyzer = {
                    settings = {
                        diagnostics = {
                            enable = false,
                        },
                        cmd = { "rustup", "run", "nightly", "rust-analyzer" },
                    },
                },
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                    },
                },
            },
        },
    },
}
