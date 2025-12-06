return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_dir = function(fname)
    return vim.fs.root(fname, 'go.work') or vim.fs.root(fname, 'go.mod') or vim.fs.root(fname, '.git')
  end,
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
    vim.lsp.codelens.refresh()
  end,
}
