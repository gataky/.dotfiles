# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

export LANG=en_US.UTF-8
export EDITOR=nvim
export ENABLE_LSP_TOOLS=1

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/Library/Caches"
export XDG_DATA_HOME="$HOME/.local/share"

# Optional machine/employer-specific overrides (gitignored, see .zshrc.local.example)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

alias ll="ls -l"
alias la="ls -la"
alias vim=nvim

eval "$(zoxide init --cmd cd zsh)"
eval "$(direnv hook zsh)"
eval "$(fzf --zsh)"
. $(brew --prefix asdf)/libexec/asdf.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

# How many lines of history to keep in memory (Histsize) and in the file (Savehist)
HISTSIZE=10000
SAVEHIST=10000
