return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  single_file_support = true,
  root_markers = { 'go.work', 'go.mod', '.git' },
  settings = {
    gopls = {
      -- Enable navigation within external dependencies
      ["build.expandWorkspaceToModule"] = true,
            -- Additional helpful settings
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
            gofumpt = true,

            -- Trust local modules (for Zillow internal packages)
            ["local"] = "gitlab.zgtools.net",
        },
    },
    on_attach = function(client, bufnr)
        -- Go-specific configuration: refresh codelens
        vim.lsp.codelens.enable(true, { bufnr = bufnr })
    end,
}
