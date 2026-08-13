

-- gdev.nvim -- Godot support (editor language server + treesitter), developed
-- locally rather than installed.
--
-- Deliberately not a `mini.deps` plugin: the checkout has no git remote and is
-- edited in place, so cloning it into "pack/deps" would only fork the working
-- copy and expose it to `MiniDeps.update()`. Putting the directory straight on
-- 'runtimepath' means `:w` in the plugin repo is live on the next `:source`.
--
-- Point `vim.g.gdev_path` at a different checkout from `local.lua` to override.
-- An absent checkout is not an error: these dotfiles are shared across machines
-- and `lua/lsp/gdscript.lua` still provides a basic gdscript client without it.
local path = vim.fn.expand(vim.g.gdev_path or '~/Documents/gdev.nvim')

if vim.uv.fs_stat(path .. '/lua/gdev') == nil then
    return
end

vim.g.gdev_dev_reload = true

vim.opt.rtp:prepend(path)

require('gdev.treesitter').setup({})
require('gdev.lsp').setup({})
require('gdev.dap').setup({})
require('gdev.format').setup({})
require('gdev.server').setup({})
require('gdev.run').setup({})
require('gdev.scenetree').setup({})
require('gdev.docs').setup({})

-- `gdev.lsp` assigns `vim.lsp.config.gdscript` wholesale, which drops the
-- completion capabilities and keymaps every other server here gets from
-- `lsp/init.lua`. Layering them back on has to chain `on_attach` by hand: the
-- merge below overwrites same-named keys, so a plain assignment would discard
-- the plugin's own attach logic (Godot's bogus `typeDefinition` support, inlay
-- hints) rather than run alongside it.
local shared = require('lsp')
local plugin_on_attach = vim.lsp.config.gdscript.on_attach

vim.lsp.config('gdscript', {
    capabilities = shared.capabilities,
    on_attach = function(client, buf_id)
        shared.on_attach(client, buf_id)
        if plugin_on_attach then
            plugin_on_attach(client, buf_id)
        end
    end,
})
