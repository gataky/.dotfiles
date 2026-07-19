# Neovim Configuration

This directory contains the configuration files for Neovim.

## Structure

Plugins are grouped by function rather than one-file-per-plugin. Each top-level
`lua/*.lua` file uses `mini.deps` (`add`/`now`/`later`) to install and configure
everything for that function, and `init.lua` requires them directly.

- `init.lua`: The main entry point. Loads core settings, then the functional
  modules below (in dependency order: `ui` first so the colorscheme applies
  before anything renders, `completion` before `lsp` since LSP capabilities
  read `mini.completion`), then `lsp`.
- `install-parsers.sh`: Installs treesitter parsers not bundled with Neovim core (used by the built-in treesitter highlighting set up in `core/autocmd.lua`).
- `lua/core/`: Core Neovim settings and keymaps.
    - `options.lua`: Sets various Neovim options.
    - `keymaps.lua`: Defines custom keybindings.
    - `autocmd.lua`: Autocommands (treesitter startup, float/border highlighting, etc).
    - `greek.lua`: Toggleable Greek keyboard input mode (`<leader>gr`).
- `lua/ui.lua`: Look and feel.
    - `sainnhe/gruvbox-material` — colorscheme
    - `mini.statusline`, `mini.tabline`, `mini.icons` — statusline/tabline/icons
    - `mini.notify`, `mini.hipatterns` — notifications, FIXME/TODO/HACK/NOTE highlighting
    - `mini.indentscope`, `mini.cursorword` — indent guide, word-under-cursor highlight
    - `catgoose/nvim-colorizer.lua` — highlights color codes (e.g. `#ebdbb2`) in their own color
- `lua/editing.lua`: Text editing helpers.
    - `mini.surround`, `mini.pairs`, `mini.comment`, `mini.align` — surround/auto-pairs/comment/align
    - `mini.jump`, `mini.jump2d` — motion helpers
    - `mini.basics`, `mini.bufremove`, `mini.trailspace` — base option defaults, buffer close, trailing whitespace
- `lua/completion.lua`: In-buffer completion.
    - `mini.completion`, `mini.fuzzy`
- `lua/git.lua`: Git integration.
    - `mini.git` — git status/blame integration
    - `NeogitOrg/neogit` — git porcelain UI (`<leader>gg`)
    - `sindrets/diffview.nvim` — diff/merge-conflict viewer
- `lua/navigation.lua`: Finding files and moving around.
    - `nvim-telescope/telescope.nvim` — fuzzy finder (`<C-p>`, `<leader>sw`, `<leader>sg`, `<leader>gf`)
    - `nvim-neo-tree/neo-tree.nvim` — file tree (`<leader>e`)
    - `alexghergh/nvim-tmux-navigation` — seamless vim/tmux pane navigation (`<C-h/j/k/l>`)
- `lua/testing.lua`: Test running.
    - `nvim-neotest/neotest` (+ `neotest-python`) — run/inspect tests (`<leader>tn/tf/to/ts`)
- `lua/http.lua`: HTTP client.
    - `mistweaverco/kulala.nvim` — send/inspect HTTP, GraphQL, gRPC, WebSocket requests from `.http`/`.rest` files (`<leader>r*`); only loaded once a matching buffer is opened
- `lua/lang.lua`: Filetype/language extras.
    - `MeanderingProgrammer/render-markdown.nvim` — in-buffer markdown rendering
- `lua/lsp/`: Language Server Protocol clients and tooling. `lua/lsp/init.lua` sets up `mason.nvim` (LSP/formatter/linter installer) and `conform.nvim` (formatting), then dynamically loads every other file in this directory — the filename (minus `.lua`) is used as the LSP server name, so adding a new server is just adding `lua/lsp/<server_name>.lua` that returns a config table.
- `lua/local.lua` (gitignored, optional): Machine/employer-specific overrides such as AWS profile/region env vars. Copy `lua/local.lua.example` to `lua/local.lua` and customize; it's loaded optionally via `pcall(require, 'local')` in `init.lua` and never committed.
