#!/usr/bin/env bash
# One-time (or re-run-on-demand) installer for treesitter parsers and their
# highlight/indent/fold queries, for filetypes not bundled with Neovim core.
# Run manually: ./install-parsers.sh
#
# Neovim core already ships parsers+queries for: c, lua, markdown,
# markdown_inline, query, vim, vimdoc. Everything below is fetched here
# because core Neovim has no parser installer of its own. Nothing here is
# committed to the dotfiles repo -- both parsers (.so) and queries (.scm)
# land under Neovim's data dir ($XDG_DATA_HOME/nvim/site, on 'runtimepath'
# by default), like any other generated/downloaded artifact.
#
# Grammar revisions are pinned to match the query commit: for
# bash/go/javascript/python/typescript, both come from nvim-treesitter's
# lockfile.json + runtime/queries at the same commit (nvim-treesitter keeps
# those two in sync, so pulling them together guarantees the query files
# don't reference node types the pinned grammar doesn't have). javascript
# and typescript queries also `; inherits:` from ecma/jsx, which aren't
# parsers themselves and so have no PARSERS entry, only a QUERIES one.
# tmux isn't part of nvim-treesitter, so its queries come from its own
# repo's queries/ dir at the same tag as the parser instead.
# Bump the grammar revision and the query commit/tag together if you ever
# update a parser.
set -euo pipefail

if ! command -v tree-sitter >/dev/null 2>&1; then
    echo "error: tree-sitter CLI not found (brew install tree-sitter)" >&2
    exit 1
fi

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site"
PARSER_DIR="$DATA_DIR/parser"
QUERY_DIR="$DATA_DIR/queries"
mkdir -p "$PARSER_DIR" "$QUERY_DIR"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

NVIM_TREESITTER_COMMIT=24977147550d53589e53b874ec75e14e4fbc304e
NVIM_TREESITTER_QUERIES="https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/$NVIM_TREESITTER_COMMIT/runtime/queries"
TMUX_QUERIES="https://raw.githubusercontent.com/Freed-Wu/tree-sitter-tmux/0.1.0/queries"

# name url revision [subdir-within-repo]
PARSERS=(
    "bash       https://github.com/tree-sitter/tree-sitter-bash            0c46d792d54c536be5ff7eb18eb95c70fccdb232  ."
    "go         https://github.com/tree-sitter/tree-sitter-go              5e73f476efafe5c768eda19bbe877f188ded6144  ."
    "javascript https://github.com/tree-sitter/tree-sitter-javascript      6fbef40512dcd9f0a61ce03a4c9ae7597b36ab5c  ."
    "python     https://github.com/tree-sitter/tree-sitter-python          710796b8b877a970297106e5bbc8e2afa47f86ec  ."
    "tmux       https://github.com/Freed-Wu/tree-sitter-tmux               0.1.0                                      ."
    "typescript https://github.com/tree-sitter/tree-sitter-typescript      75b3874edb2dc714fb1fd77a32013d0f8699989f  typescript"
)

# name base-url files...
# (ecma/jsx are query-only namespaces `; inherits:`-ed by javascript/typescript,
# not real parsers, so they have no PARSERS entry above)
QUERIES=(
    "bash       $NVIM_TREESITTER_QUERIES/bash        highlights.scm injections.scm locals.scm folds.scm indents.scm"
    "go         $NVIM_TREESITTER_QUERIES/go          highlights.scm injections.scm locals.scm folds.scm indents.scm"
    "javascript $NVIM_TREESITTER_QUERIES/javascript  highlights.scm injections.scm locals.scm folds.scm indents.scm"
    "typescript $NVIM_TREESITTER_QUERIES/typescript  highlights.scm injections.scm locals.scm folds.scm indents.scm"
    "python     $NVIM_TREESITTER_QUERIES/python      highlights.scm injections.scm locals.scm folds.scm indents.scm"
    "ecma       $NVIM_TREESITTER_QUERIES/ecma        highlights.scm injections.scm locals.scm folds.scm indents.scm"
    "jsx        $NVIM_TREESITTER_QUERIES/jsx         highlights.scm injections.scm folds.scm indents.scm"
    "tmux       $TMUX_QUERIES                        highlights.scm injections.scm folds.scm"
)

for entry in "${PARSERS[@]}"; do
    read -r name url revision subdir <<<"$entry"
    echo "== $name (parser) =="

    repo_dir="$WORK_DIR/$name"
    git clone --quiet "$url" "$repo_dir"
    git -C "$repo_dir" checkout --quiet "$revision"

    build_dir="$repo_dir/$subdir"
    if [ ! -d "$build_dir/src" ]; then
        (cd "$build_dir" && tree-sitter generate)
    fi
    (cd "$build_dir" && tree-sitter build -o "$PARSER_DIR/$name.so")

    echo "installed $PARSER_DIR/$name.so"
done

for entry in "${QUERIES[@]}"; do
    read -r name base_url files <<<"$entry"
    echo "== $name (queries) =="

    lang_dir="$QUERY_DIR/$name"
    mkdir -p "$lang_dir"
    for file in $files; do
        curl -sL --fail -o "$lang_dir/$file" "$base_url/$file"
        echo "installed $lang_dir/$file"
    done
done

echo "done"
