# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Every top-level
directory is a stow package mirroring its layout under `$HOME`.

## New machine setup

`install.sh` bootstraps a fresh macOS machine end to end: installs Homebrew,
brew packages (from the `Brewfile`), Oh My Zsh + plugins, Powerlevel10k, TPM,
asdf plugins, clones this repo to `~/.dotfiles` (over HTTPS — no SSH keys
needed yet), and stows every package. Run it directly, no manual clone needed
first:

```
curl -fsSL https://raw.githubusercontent.com/gataky/.dotfiles/main/install.sh | bash
```

Or, if you've already cloned the repo:

```
cd ~/.dotfiles
./install.sh
```

The script is idempotent — rerun it any time to pick up new Brewfile entries
or stow new packages. Afterward, set up your [local
overrides](#local-overrides) and switch the repo remote back to SSH once your
keys are in place:

```
git -C ~/.dotfiles remote set-url origin git@github.com:gataky/.dotfiles.git
```

## Packages

- `asdf` -> `~/.tool-versions`
- `git`  -> `~/.config/git/config`
- `nvim` -> `~/.config/nvim`
- `p10k` -> `~/.config/p10k.zsh`
- `tmux` -> `~/.config/tmux/tmux.conf`
- `zsh`  -> `~/.zshrc`

## Adding software

Add brew packages to the `Brewfile` and rerun `brew bundle` (or
`./install.sh`). Language runtimes go through asdf (`asdf install golang
latest`). Go binaries installed with `go install` land in `~/.local/bin`
(via `GOBIN`), which is already on PATH.

## Usage

```bash
cd ~/.dotfiles
stow */             # symlink everything
stow -D nvim        # unlink one package
stow -R nvim        # restow (after adding/removing files)
```

## Local overrides

Machine-specific values don't live in tracked files. Each package that
needs them ships a `.example` template — copy it, drop the `.example`
suffix, and fill in your values. The real file is gitignored and
loaded optionally, so the repo stays generic:

- `nvim/.config/nvim/lua/local.lua` (from `local.lua.example`)
- `zsh/.zshrc.local` (from `.zshrc.local.example`)
