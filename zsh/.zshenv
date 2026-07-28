# Make direnv apply even in non-interactive/one-shot shells (e.g. `zsh -c "..."`).
# ~/.zshrc's direnv hook only re-exports on precmd (before an interactive prompt is
# drawn), which never fires for one-shot `-c` invocations, so tools that spawn those
# don't pick up per-directory .envrc files. ~/.zshenv is sourced on every zsh
# invocation, so this covers that case; ~/.zshrc's hook still handles normal
# interactive `cd`-driven updates.
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv export zsh 2>/dev/null)"
fi
