# Dot Files 

Managed with GNU Stow 

## Setup 

1. Close repository to home directory under `.dotfiles`

```
git clone git@github.com:gataky/.dotfiles.git ~/.dotfiles
```

2. Create links 

```
find ~/.dotfiles/ -type d -depth 1 | awk -F '/' '{print $NF}' | grep -v '.git' | xargs -I{} stow -d ~/.dotfiles -R {}
```
