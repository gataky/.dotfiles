return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_dir = function(fname)
    return vim.fs.root(fname, {
      'pyproject.toml',
      'setup.py',
      'setup.cfg',
      'requirements.txt',
      'Pipfile',
      'pyrightconfig.json',
      '.git',
    })
  end,
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
}