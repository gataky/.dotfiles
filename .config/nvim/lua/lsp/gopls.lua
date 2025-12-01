return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_dir = function(fname)
    return vim.fs.root(fname, 'go.work') or vim.fs.root(fname, 'go.mod') or vim.fs.root(fname, '.git')
  end,
  on_attach = function(client, bufnr, common_on_attach)
    -- Call the common on_attach to set up standard key bindings
    if common_on_attach then
      common_on_attach(client, bufnr)
    end

    -- Go-specific configuration
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
    vim.lsp.codelens.refresh()
  end,
}
