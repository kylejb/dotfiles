#!/bin/sh -e
#
# Symlink shared AI agent configs into place.
#
# This is content-driven: it links whatever exists under ai/claude/ and
# ai/codex/ in the repo into ~/.claude and ~/.codex respectively. Only
# declarative, shareable config belongs in the repo — never runtime/secret
# state (auth, sessions, history, caches, memories). See .gitignore.

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# shellcheck source=/dev/null
. "${DOTFILES}/utils.sh" >/dev/null 2>&1 || true

# Link every top-level entry under $src into $dst.
# Skips (with a warning) any target that already exists as a real (non-symlink)
# file or directory, so we never clobber local data. Refreshes existing symlinks.
link_tree() {
    src="$1"
    dst="$2"

    [ -d "$src" ] || return 0

    mkdir -p "$dst"
    for item in "$src"/* "$src"/.[!.]*; do
        [ -e "$item" ] || continue
        target="$dst/$(basename "$item")"

        if [ -e "$target" ] && [ ! -L "$target" ]; then
            printf '! %s already exists and is not a symlink... Skipping.\n' "$target"
            continue
        fi

        ln -sfn "$item" "$target"
        printf '==> linked %s -> %s\n' "$target" "$item"
    done
}

printf '\nSetting up AI agent configs\n'
link_tree "${DOTFILES}/ai/claude" "$HOME/.claude"
link_tree "${DOTFILES}/ai/codex" "$HOME/.codex"
