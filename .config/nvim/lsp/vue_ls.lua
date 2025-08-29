local util = require 'lspconfig.util'

return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json' },
  -- https://github.com/vuejs/language-tools/blob/v2/packages/language-server/lib/types.ts
  init_options = {
    typescript = {
      tsdk = '',
    },
  },
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and config.init_options.typescript.tsdk == '' then
      config.init_options.typescript.tsdk = util.get_typescript_server_path(config.root_dir)
    end
  end,
}

-- npm install @vue/language-server
-- npm install typescript typescript-language-server
