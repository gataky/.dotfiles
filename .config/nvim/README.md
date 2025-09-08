# Neovim Configuration

This directory contains the configuration files for Neovim.

## Structure

- `init.lua`: The main entry point for the Neovim configuration. It loads other configuration files.
- `lua/`: This directory contains modularized Lua configuration files.
    - `lua/plugins.lua`: Manages the installation and configuration of Neovim plugins using `mini.deps`. Each plugin's configuration is now broken down into individual files within the `lua/plugins/` directory.
    - `lua/core/`: Contains core Neovim settings and keymaps.
        - `keymaps.lua`: Defines custom keybindings.
        - `options.lua`: Sets various Neovim options.
    - `lua/lsp/`: Contains configurations for Language Server Protocol (LSP) clients. Each file typically configures a specific LSP server.
    - `lua/plugins/`: Contains individual configuration files for each Neovim plugin.