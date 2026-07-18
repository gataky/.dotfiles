# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a stow package mirroring its layout under `$HOME`.

## Packages

- `nvim`    -> `~/.config/nvim`
- `zsh`     -> `~/.zshrc`
- `tmux`    -> `~/.tmux.conf`
- `scripts` -> `~/.local/bin`

## Usage

```
cd ~/.dotfiles
stow nvim zsh tmux scripts   # symlink everything
stow -D nvim                 # unlink one package
stow -R nvim                 # restow (after adding/removing files)
```
