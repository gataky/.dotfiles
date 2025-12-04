local lspconfig = require('lspconfig')

-- Set up LSP capabilities for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Integrate with mini.completion if available
local has_mini_completion, mini_completion = pcall(require, 'mini.completion')
if has_mini_completion then
    capabilities = vim.tbl_deep_extend('force', capabilities, mini_completion.completionitem_info or {})
end

-- Common on_attach function
local on_attach = function(client, buffer)
    -- Set keymaps directly using the API with explicit buffer option
    local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
            buffer = buffer,
            noremap = true,
            silent = true,
            desc = desc or ""
        })
    end

    -- LSP keymaps
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "<leader>D", vim.lsp.buf.type_definition, "Type definition")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "gr", function()
        require('telescope.builtin').lsp_references()
    end, "Find references")
    map("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, "Format buffer")

    -- Diagnostic navigation keymaps
    map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
    map("n", "<leader>d", vim.diagnostic.open_float, "Show diagnostic")
    map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic list")
end

-- Diagnostic configuration
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        source = "always",
        header = "",
        prefix = "",
        suffix = "",
    },
})

-- Dynamically set up all LSP servers
local lsp_path = vim.fn.stdpath('config') .. '/lua/lsp'
local lsp_files = vim.fn.readdir(lsp_path)

for _, file_name in ipairs(lsp_files) do
    if file_name:match('%.lua$') and file_name ~= 'init.lua' then
        local server_name = file_name:gsub('%.lua$', '')
        local server_config = require('lsp.' .. server_name)

        -- Start with server_config as base
        local final_config = vim.tbl_deep_extend("force", {}, server_config)

        -- If server has custom on_attach, wrap it to call common on_attach first
        if server_config.on_attach then
            local custom_on_attach = server_config.on_attach
            final_config.on_attach = function(client, bufnr)
                -- Call common on_attach first for standard key bindings
                on_attach(client, bufnr)
                -- Then call custom on_attach
                custom_on_attach(client, bufnr)
            end
        else
            -- No custom on_attach, just use the common one
            final_config.on_attach = on_attach
        end

        -- Set capabilities (always set, don't let server override)
        final_config.capabilities = capabilities

        -- Use lspconfig's setup method
        lspconfig[server_name].setup(final_config)
    end
end
