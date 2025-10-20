#!/bin/bash
# Dotfiles Installation Script
# This script installs all dependencies needed for the dotfiles configuration

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check OS
check_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    print_status "Detected OS: $OS"
}

# Function to install Homebrew (macOS)
install_homebrew() {
    if [[ "$OS" == "macos" ]]; then
        if ! command_exists brew; then
            print_status "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # Add Homebrew to PATH for Apple Silicon Macs
            if [[ $(uname -m) == "arm64" ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            print_success "Homebrew installed successfully"
        else
            print_status "Homebrew already installed"
        fi
    fi
}

# Function to install system packages
install_system_packages() {
    print_status "Installing system packages..."

    if [[ "$OS" == "macos" ]]; then
        # Install core packages via Homebrew
        brew_packages=(
            "asdf"
            "bat"
            "direnv"
            "fd"
            "fzf"
            "git"
            "htop"
            "httpie"
            "jq"
            "just"
            "neovim"
            "ripgrep"
            "tldr"
            "tmux"
            "tree"
            "yq"
            "zoxide"
            "zsh"
        )

        for package in "${brew_packages[@]}"; do
            if ! brew list "$package" >/dev/null 2>&1; then
                print_status "Installing $package..."
                brew install "$package"
            else
                print_status "$package already installed"
            fi
        done

        # Install additional tools
        brew install --cask visual-studio-code
        brew install --cask iterm2

    elif [[ "$OS" == "linux" ]]; then
        # For Linux, you might want to add package manager detection
        print_warning "Linux package installation not implemented yet"
        print_warning "Please install the following packages manually:"
        echo "  - git, zsh, tmux, neovim, fzf, zoxide, direnv, asdf"
    fi
}

# Function to install Oh My Zsh
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed successfully"
    else
        print_status "Oh My Zsh already installed"
    fi
}

# Function to install Oh My Zsh plugins
install_zsh_plugins() {
    print_status "Installing Oh My Zsh plugins..."

    # zsh-autosuggestions
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    fi

    # zsh-syntax-highlighting
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    fi

    print_success "Zsh plugins installed successfully"
}

# Function to install Powerlevel10k theme
install_powerlevel10k() {
    if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
        print_status "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
        print_success "Powerlevel10k theme installed successfully"
    else
        print_status "Powerlevel10k theme already installed"
    fi
}

# Function to install Tmux Plugin Manager
install_tpm() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        print_status "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        print_success "TPM installed successfully"
    else
        print_status "TPM already installed"
    fi
}

# Function to install Neovim dependencies
install_neovim_deps() {
    print_status "Installing Neovim dependencies..."

    # Create necessary directories
    mkdir -p "$HOME/.local/share/nvim/site/pack/deps/start"
    mkdir -p "$HOME/.config/nvim"

    # Install language servers and formatters via Mason (will be done when Neovim first runs)
    print_status "Neovim dependencies will be installed on first run via Mason"
}

# Function to install ASDF plugins
install_asdf_plugins() {
    if command_exists asdf; then
        print_status "Installing ASDF plugins..."

        # Add plugins
        asdf plugin add golang || true
        asdf plugin add python || true
        asdf plugin add nodejs || true
        asdf plugin add ruby   || true
        asdf plugin add dasel https://github.com/asdf-community/asdf-dasel.git || true

        print_success "ASDF plugins installed successfully"
    else
        print_warning "ASDF not found, skipping plugin installation"
    fi
}

# Function to set up git configuration
setup_git() {
    print_status "Setting up git configuration..."

    # Set up the dotfiles repository
    if [[ ! -d "$HOME/.cfg" ]]; then
        git clone --bare https://github.com/yourusername/dotfiles.git "$HOME/.cfg"
        git --git-dir="$HOME/.cfg" --work-tree="$HOME" checkout
        git --git-dir="$HOME/.cfg" --work-tree="$HOME" config --local status.showUntrackedFiles no
    fi

    print_success "Git configuration set up successfully"
}

# Function to finalize installation
finalize_installation() {
    print_status "Finalizing installation..."

    # Make zsh the default shell
    if [[ "$SHELL" != "/bin/zsh" ]] && [[ "$SHELL" != "/usr/bin/zsh" ]]; then
        print_status "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        print_warning "Please restart your terminal or run 'exec zsh' to use zsh"
    fi

    # Install tmux plugins
    if command_exists tmux; then
        print_status "Installing tmux plugins..."
        tmux new-session -d
        tmux send-keys -t 0 "source ~/.tmux.conf" Enter
        tmux send-keys -t 0 "prefix + I" Enter
        tmux kill-session
    fi

    print_success "Installation completed successfully!"
    echo
    echo "Next steps:"
    echo "1. Restart your terminal or run 'exec zsh'"
    echo "2. Run 'p10k configure' to set up your Powerlevel10k theme"
    echo "3. Open Neovim to install LSP servers and other dependencies"
    echo "4. Customize your configuration as needed"
    echo
    echo "Your dotfiles are now ready to use!"
}

# Main installation function
main() {
    echo "=========================================="
    echo "    Dotfiles Installation Script"
    echo "=========================================="
    echo

    check_os
    install_homebrew
    install_system_packages
    install_oh_my_zsh
    install_zsh_plugins
    install_powerlevel10k
    install_tpm
    install_neovim_deps
    install_asdf_plugins
    setup_git
    finalize_installation
}

# Run main function
main "$@"
