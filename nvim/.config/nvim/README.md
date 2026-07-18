# Neovim Configuration

This directory contains the configuration files for Neovim.

## Structure

- `init.lua`: The main entry point for the Neovim configuration. It loads other configuration files.
- `install-parsers.sh`: Installs treesitter parsers not bundled with Neovim core (used by the built-in treesitter highlighting set up in `core/autocmd.lua`).
- `lua/`: This directory contains modularized Lua configuration files.
    - `lua/plugins.lua`: Manages the installation and configuration of Neovim plugins using `mini.deps`. Each plugin's configuration is broken down into individual files within the `lua/plugins/` directory.
    - `lua/plugins/`: Contains individual configuration files for each Neovim plugin.
    - `lua/core/`: Contains core Neovim settings and keymaps.
        - `keymaps.lua`: Defines custom keybindings.
        - `options.lua`: Sets various Neovim options.
        - `autocmd.lua`: Autocommands (treesitter startup, float/border highlighting, etc).
    - `lua/lsp/`: Contains configurations for Language Server Protocol (LSP) clients. `lua/lsp/init.lua` dynamically loads every other file in this directory — the filename (minus `.lua`) is used as the LSP server name, so adding a new server is just adding `lua/lsp/<server_name>.lua` that returns a config table.
    - `lua/themes.lua`: Sets the colorscheme.
    - `lua/greek.lua`: Toggleable Greek keyboard input mode (`<leader>gr`).
    - `lua/local.lua` (gitignored, optional): Machine/employer-specific overrides such as AWS profile/region env vars. Copy `lua/local.lua.example` to `lua/local.lua` and customize; it's loaded optionally via `pcall(require, 'local')` in `init.lua` and never committed.
