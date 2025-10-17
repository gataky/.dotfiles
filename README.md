# Dotfiles Installation Script

This repository contains a comprehensive installation script that sets up all the dependencies needed for your dotfiles configuration on a new computer.

## What This Script Installs

### Core Tools
- **Homebrew** (macOS package manager)
- **Git** - Version control
- **Zsh** - Shell
- **Oh My Zsh** - Zsh framework
- **Powerlevel10k** - Zsh theme
- **Tmux** - Terminal multiplexer
- **Neovim** - Text editor

### Development Tools
- **ASDF** - Version manager for multiple languages
- **Node.js** - JavaScript runtime
- **Python** - Python interpreter
- **Go** - Go programming language
- **Rust** - Rust programming language

### Zsh Plugins
- **zsh-autosuggestions** - Fish-like autosuggestions
- **zsh-syntax-highlighting** - Syntax highlighting

### Tmux Plugins
- **TPM** - Tmux Plugin Manager
- **tmux-yank** - Copy/paste integration
- **tmux-power** - Powerline status bar

### Neovim Setup
- **mini.nvim** - Plugin manager
- **LSP support** - Language Server Protocol
- **Treesitter** - Syntax highlighting
- **Telescope** - Fuzzy finder
- **Various plugins** for development workflow

### Additional Tools
- **fzf** - Fuzzy finder
- **zoxide** - Smart cd replacement
- **direnv** - Directory-based environment variables
- **ripgrep** - Fast grep replacement
- **bat** - Better cat
- **exa** - Better ls
- **htop** - Process viewer

## Prerequisites

- macOS (primary support) or Linux
- Internet connection
- Administrator privileges (for some installations)

## Quick Start

1. **Clone this repository:**
   ```bash
   git clone git@github.com:gataky/.dotfiles.git ~/.cfg
   cd ~/.cfg
   alias config='/usr/bin/git --git-dir=$HOME/.cfg/.git --work-tree=$HOME'
   config checkout 2>&1 | egrep "^\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
   config checkout
   ```

2. **Make the script executable:**
   ```bash
   chmod +x ~/.config/dotfiles/install.sh
   ```

3. **Run the installation script:**
   ```bash
   ./.config/dotfiles/install.sh
   ```

## What the Script Does

1. **Detects your operating system**
2. **Installs Homebrew** (macOS)
3. **Installs system packages** via package manager
4. **Sets up Oh My Zsh** with plugins and theme
5. **Installs Tmux Plugin Manager**
6. **Sets up Neovim** with dependencies
7. **Installs language managers** (ASDF, Rust, Go)
8. **Installs development tools** (Python packages, Node.js packages)
9. **Configures git** for dotfiles management
10. **Finalizes the setup** (shell changes, plugin installations)

## Post-Installation Steps

After running the script, you should:

1. **Restart your terminal** or run `exec zsh`
2. **Configure Powerlevel10k** by running `p10k configure`
3. **Open Neovim** to install LSP servers and other dependencies
4. **Customize your configuration** as needed

## Manual Installation (Alternative)

If you prefer to install things manually or the script fails, you can install the core dependencies:

### macOS
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install core packages
brew install git zsh tmux neovim fzf zoxide direnv asdf

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Troubleshooting

### Common Issues

1. **Permission denied errors**: Make sure you have administrator privileges
2. **Homebrew not found**: The script will install it automatically
3. **Zsh not found**: The script will install it via Homebrew
4. **Symlink errors**: Existing files will be backed up to `~/.dotfiles_backup`

### Getting Help

- Check the script output for specific error messages
- Ensure you have internet connectivity
- Verify you have sufficient disk space
- Check that your system meets the minimum requirements

## Customization

The script is designed to be easily customizable. You can:

- Modify the `brew_packages` array to add/remove packages
- Add new installation functions for additional tools
- Customize the symlink creation process
- Modify the post-installation steps

## License

This project is open source and available under the [MIT License](LICENSE).
