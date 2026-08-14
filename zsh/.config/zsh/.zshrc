# Homebrew first, so the custom PATH entries below take priority over it.
# Full path, not `brew shellenv` — brew isn't on the default PATH, so this
# must not depend on ~/.zprofile or install order.
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

autoload -U compinit; compinit
source ~/.local/share/fzf-tab/fzf-tab.plugin.zsh

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Optional machine/employer-specific overrides (gitignored, see .zshrc.local.example)
[[ -f "$HOME/.config/zsh/.zshrc.local" ]] && source "$HOME/.config/zsh/.zshrc.local"

export LANG=en_US.UTF-8
export EDITOR=nvim
export ENABLE_LSP_TOOLS=1
export SHELL_SESSIONS_DISABLE=1
export HISTSIZE=10000
export SAVEHIST=10000

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/Library/Caches"
export XDG_DATA_HOME="$HOME/.local/share"

export ASDF_DATA_DIR="$HOME/.local/share/asdf"
export CLAUDE_CONFIG_DIR="$HOME/.config/claude"
export OLLAMA_MODELS="$HOME/.local/share/ollama/models"
export HISTFILE="$HOME/.cache/zsh/history"
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"

# `go install` drops binaries here instead of asdf's per-version dir, so PATH
# doesn't need to change on every Go upgrade (and no `go env` fork at startup)
export GOBIN="$HOME/.local/bin"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$HOME/.local/share/npm/bin:$PATH"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

alias vim=nvim
alias ls="eza" # ls
alias la='eza -lbF --all --git' # list, size, type, git
alias lg='eza -lbGd --git --sort=modified' # long list, modified date sort
alias lt='eza --long --git --tree --level=3'

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
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
