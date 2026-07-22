# Define a clean location for the zcompdump cache
export ZSH_COMPDUMP="$HOME/.cache/zcompdump-$HOST-$ZSH_VERSION"
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.local/share/oh-my-zsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"

export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/share/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$HOME/.local/share/npm/bin:$PATH"

export LANG=en_US.UTF-8
export EDITOR=nvim
export ENABLE_LSP_TOOLS=1
export SHELL_SESSIONS_DISABLE=1

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/Library/Caches"
export XDG_DATA_HOME="$HOME/.local/share"

export ASDF_DATA_DIR="$HOME/.local/share/asdf"
export CLAUDE_CONFIG_DIR="$HOME/.local/share/claude"
export OLLAMA_MODELS="$HOME/.local/share/ollama/models"
export HISTFILE="$HOME/.cache/zsh/history"
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"

# How many lines of history to keep in memory (Histsize) and in the file (Savehist)
export HISTSIZE=10000
export SAVEHIST=10000

[[ ! -f ~/.config/p10k.zsh ]] || source ~/.config/p10k.zsh

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet


# Optional machine/employer-specific overrides (gitignored, see .zshrc.local.example)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

alias ll="ls -l"
alias la="ls -la"
alias vim=nvim

# Tell compinit to load from and save to the new path
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

# Share history *upon exit*, not constantly
# This is the key setting for per-session history fidelity
setopt NO_SHARE_HISTORY
# Save history to file
setopt INC_APPEND_HISTORY
# Add history to history file *when a shell exits*
setopt APPEND_HISTORY
# Keep the history file synched with the current session's commands
# This ensures history is added to the *current session's memory* immediately
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

eval "$(direnv hook zsh)"
eval "$(fzf --zsh)"
eval "$(brew shellenv)"
eval "$(zoxide init --cmd cd zsh)"
