#!/usr/bin/env bash
# One-time (or re-run-on-demand) installer for treesitter parsers not bundled
# with Neovim core. Run manually: ./install-parsers.sh
#
# Neovim core already ships parsers+queries for: c, lua, markdown,
# markdown_inline, query, vim, vimdoc. Everything below is vendored here
# because core Neovim has no parser installer of its own.
#
# Revisions are pinned to match the .scm query files vendored under
# ./queries/<lang>/, which were copied from nvim-treesitter at those same
# revisions. Bump both together if you ever update a parser.
set -euo pipefail

if ! command -v tree-sitter >/dev/null 2>&1; then
    echo "error: tree-sitter CLI not found (brew install tree-sitter)" >&2
    exit 1
fi

PARSER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/parser"
mkdir -p "$PARSER_DIR"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

# name url revision [subdir-within-repo]
PARSERS=(
    "bash       https://github.com/tree-sitter/tree-sitter-bash            a06c2e4415e9bc0346c6b86d401879ffb44058f7  ."
    "go         https://github.com/tree-sitter/tree-sitter-go              2346a3ab1bb3857b48b29d779a1ef9799a248cd7  ."
    "javascript https://github.com/tree-sitter/tree-sitter-javascript      58404d8cf191d69f2674a8fd507bd5776f46cb11  ."
    "python     https://github.com/tree-sitter/tree-sitter-python          v0.25.0                                    ."
    "tmux       https://github.com/Freed-Wu/tree-sitter-tmux               75d1b995b0c23400ac8e49db757a2e0386f9fa8f  ."
    "typescript https://github.com/tree-sitter/tree-sitter-typescript      75b3874edb2dc714fb1fd77a32013d0f8699989f  typescript"
)

for entry in "${PARSERS[@]}"; do
    read -r name url revision subdir <<<"$entry"
    echo "== $name =="

    repo_dir="$WORK_DIR/$name"
    git clone --quiet "$url" "$repo_dir"
    git -C "$repo_dir" checkout --quiet "$revision"

    build_dir="$repo_dir/$subdir"
    (cd "$build_dir" && tree-sitter build -o "$PARSER_DIR/$name.so")

    echo "installed $PARSER_DIR/$name.so"
done

echo "done"
