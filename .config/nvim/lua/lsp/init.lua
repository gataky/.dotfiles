local lspconfig = require('lspconfig')

-- Common on_attach function
local on_attach = function(client, buffer)
    local opts = { buffer = buffer, noremap = true, silent = true }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
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

        local final_config = vim.tbl_deep_extend("force", {
            on_attach = on_attach,
        }, server_config)

        lspconfig[server_name].setup(final_config)
    end
end