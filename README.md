# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a stow package mirroring its layout under `$HOME`.

## New machine setup

`install.sh` bootstraps a fresh macOS machine end to end: installs Homebrew,
brew packages, Oh My Zsh + plugins, Powerlevel10k, TPM, asdf plugins, clones
this repo to `~/.dotfiles` if it isn't there yet, and stows all three
packages. Run it directly, no manual clone needed first:

```
curl -fsSL https://raw.githubusercontent.com/gataky/.dotfiles/main/install.sh | bash
```

Or, if you've already cloned the repo:

```
cd ~/.dotfiles
./install.sh
```

Afterward, set up your [local overrides](#local-overrides) — the script
doesn't create these for you, since they're personal/employer-specific.

## Packages

- `nvim` -> `~/.config/nvim`
- `zsh`  -> `~/.zshrc`
- `tmux` -> `~/.tmux.conf`

## Usage

```bash
cd ~/.dotfiles
stow nvim zsh tmux   # symlink everything
stow -D nvim         # unlink one package
stow -R nvim         # restow (after adding/removing files)
```

## Local overrides

Machine-specific values don't live in tracked files. Each package that
needs them ships a `.example` template — copy it, drop the `.example`
suffix, and fill in your values. The real file is gitignored and
loaded optionally, so the repo stays generic:

- `nvim/.config/nvim/lua/local.lua` (from `local.lua.example`)
- `zsh/.zshrc.local` (from `.zshrc.local.example`)
