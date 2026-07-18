# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a stow package mirroring its layout under `$HOME`.

## Packages

- `nvim` -> `~/.config/nvim`
- `zsh`  -> `~/.zshrc`
- `tmux` -> `~/.tmux.conf`

## Usage

```
cd ~/.dotfiles
stow nvim zsh tmux   # symlink everything
stow -D nvim         # unlink one package
stow -R nvim         # restow (after adding/removing files)
```

## Local overrides

Machine/employer-specific values (AWS profiles, SSO prefixes, etc.) don't
live in tracked files. Each package that needs them ships a `.example`
template — copy it, drop the `.example` suffix, and fill in your values.
The real file is gitignored and loaded optionally, so the repo stays
generic:

- `nvim/.config/nvim/lua/local.lua` (from `local.lua.example`)
- `zsh/.zshrc.local` (from `.zshrc.local.example`)
