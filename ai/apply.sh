#!/bin/sh
#
# Apply shared AI agent configs.
#
# This is explicit on purpose: only files agents actually consume are linked.
# Repo docs stay in the repo. Never sync runtime/secret state (auth, sessions,
# history, caches, memories). See .gitignore.

# set -e here (not just the shebang) so fail-fast holds when run as `sh apply.sh`.
set -e

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# shellcheck source=/dev/null
. "${DOTFILES}/utils.sh"

link_if_present() {
    src="$1"
    target="$2"

    [ -e "$src" ] || return 0
    safe_link "$src" "$target"
}

title 'Setting up AI agent configs'

link_if_present "${DOTFILES}/ai/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link_if_present "${DOTFILES}/ai/AGENTS.md" "$HOME/.codex/AGENTS.md"
for skill in "${DOTFILES}"/ai/skills/*/; do
    [ -d "$skill" ] || continue
    safe_link "${skill%/}" "$HOME/.claude/skills/$(basename "$skill")"
done

# Drop links to skills that no longer exist; links from elsewhere stay.
for link in "$HOME"/.claude/skills/*; do
    if [ -L "$link" ] && [ ! -e "$link" ] && is_dotfiles_link "$link"; then
        info "Removing stale skill link ~${link#"$HOME"}"
        rm "$link"
    fi
done
