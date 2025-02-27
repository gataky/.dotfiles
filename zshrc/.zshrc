
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH


alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rg='rg --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vim=nvim
alias tree='tree -I node_modules'

export PATH=/opt/homebrew/bin:$PATH

export AWS_DEFAULT_PROFILE=zillow-dev
export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export MANWIDTH=120
export PROMPT_DIRTRIM=2
export PYTHONDONTWRITEBYTECODE=1
export SHELL=/bin/bash
export VISUAL=nvim

export FZF_BASE=/usr/local/bin/fzf
export FZF_DEFAULT_COMMAND='rg -. --files --follow -g "!{node_modules/*,.git/*,.direnv/*}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GITLAB_API_TOKEN=vYDQ5WtohbimU2miy8CX


autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# =================================================

alias z3d='export env=z3d; python3 ~/scripts/change_env.py'
alias sso='aws --profile conv-ai sso login'
alias ssos='aws --profile zillow-qa sso login'
alias ssop='aws --profile zillow-prod sso login'
