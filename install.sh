#!/bin/bash
# Dotfiles bootstrap script (macOS only).
#
# Safe to run repeatedly — every step is idempotent. Designed to work on a
# completely fresh machine via:
#
#   curl -fsSL https://raw.githubusercontent.com/gataky/.dotfiles/main/install.sh | bash

set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_URL="https://github.com/gataky/.dotfiles.git"

# These must match the values exported in zsh/.zshrc — if they drift, tools
# get installed somewhere the shell never looks (the classic "asdf plugins
# vanished after restart" failure).
export ASDF_DATA_DIR="$HOME/.local/share/asdf"
export ZSH="$HOME/.local/share/oh-my-zsh"

BLUE='\033[0;34m' GREEN='\033[0;32m' YELLOW='\033[1;33m' NC='\033[0m'
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Clone a repo only if the destination doesn't exist yet.
clone_if_missing() {
    local url=$1 dest=$2
    if [[ -d "$dest" ]]; then
        info "$(basename "$dest") already present"
    else
        info "Cloning $(basename "$dest")..."
        git clone --depth=1 "$url" "$dest"
    fi
}

# --- Homebrew --------------------------------------------------------------
# Put brew on THIS script's PATH regardless of how the machine got it.
# .zshrc does the same dance, so nothing here depends on ~/.zprofile.
ensure_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            info "Installing Homebrew..."
            # NONINTERACTIVE: no "press enter to continue" prompt, which would
            # otherwise swallow script text when run via `curl | bash`.
            NONINTERACTIVE=1 /bin/bash -c \
                "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            eval "$([[ -x /opt/homebrew/bin/brew ]] \
                && /opt/homebrew/bin/brew shellenv \
                || /usr/local/bin/brew shellenv)"
        fi
    fi
    success "Homebrew ready: $(command -v brew)"
}

# --- Dotfiles repo ----------------------------------------------------------
# HTTPS, not SSH — a fresh machine has no SSH keys yet. Switch the remote
# back to SSH later if you prefer pushing over SSH.
ensure_repo() {
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        info "Cloning dotfiles repository..."
        git clone "$DOTFILES_URL" "$DOTFILES_DIR"
    else
        info "Dotfiles repository already present at $DOTFILES_DIR"
    fi
}

install_packages() {
    info "Installing brew packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    success "Brew packages installed"
}

# --- Zsh ecosystem ----------------------------------------------------------
install_oh_my_zsh() {
    if [[ ! -d "$ZSH" ]]; then
        info "Installing Oh My Zsh..."
        # KEEP_ZSHRC: don't let the installer write its own ~/.zshrc — ours
        # comes from stow. CHSH/RUNZSH: no prompts, no shell swap mid-script.
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        info "Oh My Zsh already installed"
    fi

    clone_if_missing https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH/custom/plugins/zsh-autosuggestions"
    clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting \
        "$ZSH/custom/plugins/zsh-syntax-highlighting"
    clone_if_missing https://github.com/romkatv/powerlevel10k \
        "$ZSH/custom/themes/powerlevel10k"
    success "Oh My Zsh + plugins + theme ready"
}

# --- Stow -------------------------------------------------------------------
stow_dotfiles() {
    info "Stowing dotfiles..."
    cd "$DOTFILES_DIR"

    # Every top-level directory is a stow package — no list to keep in sync.
    local packages=()
    for dir in */; do
        packages+=("${dir%/}")
    done

    # Stow refuses to link over existing real files. Any pre-existing,
    # non-symlink file that collides with a package's contents gets moved
    # aside first so the run doesn't abort partway through.
    #
    # The -ef guard matters: stow "folds" directories into a single symlink,
    # so $target can be the repo file itself reached through a symlinked
    # parent dir (-L on the leaf says no). Moving that would rip the file
    # out of this repo.
    local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
    local backed_up=false
    for pkg in "${packages[@]}"; do
        while IFS= read -r -d '' file; do
            local rel="${file#"$pkg"/}"
            local target="$HOME/$rel"
            if [[ -e "$target" && ! -L "$target" && ! "$target" -ef "$file" ]]; then
                warn "Existing $target found, backing up"
                mkdir -p "$backup_dir/$(dirname "$rel")"
                mv "$target" "$backup_dir/$rel"
                backed_up=true
            fi
        done < <(find "$pkg" -type f -print0)
    done
    if [[ "$backed_up" == true ]]; then
        warn "Pre-existing dotfiles backed up to $backup_dir"
    fi

    stow --restow "${packages[@]}"
    success "Stowed: ${packages[*]}"
}

# --- asdf -------------------------------------------------------------------
# Runs after stow so ~/.tool-versions (if tracked) is in place.
install_asdf() {
    info "Installing asdf plugins..."
    local plugins=(golang python nodejs ruby uv)
    for plugin in "${plugins[@]}"; do
        asdf plugin add "$plugin" 2>/dev/null || true
    done
    asdf plugin add dasel https://github.com/asdf-community/asdf-dasel.git 2>/dev/null || true

    if [[ -f "$HOME/.tool-versions" ]]; then
        info "Installing tool versions from ~/.tool-versions (this can take a while)..."
        (cd "$HOME" && asdf install)
    else
        warn "No ~/.tool-versions found — run 'asdf install <tool> <version>' as needed"
    fi
    success "asdf ready (data dir: $ASDF_DATA_DIR)"
}

# --- Treesitter parsers -------------------------------------------------------
# Skipped when parsers are already present — the script rebuilds everything
# from scratch (clones six grammar repos), so it's only worth running on a
# fresh machine. Rerun it manually to update pinned parsers.
install_treesitter_parsers() {
    local parser_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/parser"
    if [[ -d "$parser_dir" && -n "$(ls -A "$parser_dir" 2>/dev/null)" ]]; then
        info "Treesitter parsers already present — rerun nvim/.config/nvim/install-parsers.sh to update"
    else
        info "Installing treesitter parsers (this can take a while)..."
        "$DOTFILES_DIR/nvim/.config/nvim/install-parsers.sh"
    fi
}

# --- tmux -------------------------------------------------------------------
install_tmux_plugins() {
    local tpm="$HOME/.local/state/tmux-plugin-manager"
    clone_if_missing https://github.com/tmux-plugins/tpm "$tpm"
    info "Installing tmux plugins..."
    "$tpm/bin/install_plugins" || warn "tmux plugin install failed — run '$tpm/bin/install_plugins' manually"
}

# --- Finish -----------------------------------------------------------------
finalize() {
    # Runtime dirs .zshrc expects (history lives here).
    mkdir -p "$HOME/.cache/zsh" "$HOME/.local/bin"

    echo
    success "Installation complete!"
    echo
    if [[ "$SHELL" != */zsh ]]; then
        # Never run chsh inside the script: it prompts for a password on
        # stdin, and under `curl | bash` stdin is the script itself.
        warn "Your login shell is $SHELL — run 'chsh -s /bin/zsh' to switch"
    fi
    echo "Next steps:"
    echo "1. Restart your terminal (or run 'exec zsh')"
    echo "2. Set up local overrides (see README: zsh/.zshrc.local.example, nvim local.lua.example)"
    echo "3. Open Neovim once to let Mason install LSP servers"
}

main() {
    echo "=========================================="
    echo "    Dotfiles Installation Script"
    echo "=========================================="
    echo

    ensure_homebrew
    ensure_repo
    install_packages
    install_oh_my_zsh
    stow_dotfiles
    install_asdf
    install_treesitter_parsers
    install_tmux_plugins
    finalize
}

main "$@"
