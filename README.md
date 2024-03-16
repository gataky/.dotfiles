# Dot Files 

Managed with GNU Stow 

## Setup 

1. Close repository to home directory under `.dotfiles`

```
git clone git@github.com:gataky/.dotfiles.git ~/.dotfiles
```

2. Create links 

```
find . -type d -depth 1 -not -path '*/.*' | sed -r 's|./(.*)|\1|' | xargs -I{} stow -d ~/.dotfiles -R {}
```
