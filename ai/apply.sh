#!/bin/sh
#
# Apply shared AI agent configs.
#
# This is explicit on purpose: only files agents actually consume are linked,
# and live app-owned config is rendered into managed blocks. Repo docs stay in
# the repo. Never sync runtime/secret state (auth, sessions, history, caches,
# memories). See .gitignore.

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

strip_codex_managed_block() {
    source_file="$1"
    target_file="$2"
    end="$3"

    if [ -f "$source_file" ]; then
        awk -v e="$end" '
            /^# >>> dotfiles:codex / {inblock=1; next}
            $0==e {inblock=0; next}
            !inblock {print}
        ' "$source_file" >"$target_file"
    else
        : >"$target_file"
    fi
}

# Render ai/codex/config.toml plus optional config.local.toml into a managed
# block in ~/.codex/config.toml. Codex may rewrite the live file, so we preserve
# everything outside the dotfiles block and replace only that block.
render_codex_config() {
    target="$HOME/.codex/config.toml"
    begin='# >>> dotfiles:codex (managed by dot --apply) >>>'
    end='# <<< dotfiles:codex <<<'

    set --
    for f in "${DOTFILES}/ai/codex/config.toml" "${DOTFILES}/ai/codex/config.local.toml"; do
        [ -s "$f" ] || continue
        set -- "$@" "$f"
    done

    [ "$#" -gt 0 ] || [ -f "$target" ] || return 0

    mkdir -p "$(dirname "$target")"
    tmp="$(mktemp "${TMPDIR:-/tmp}/dotfiles.codex.XXXXXX")"
    strip_codex_managed_block "$target" "$tmp" "$end"

    if [ "$#" -gt 0 ]; then
        {
            printf '\n%s\n' "$begin"
            for f do
                cat "$f"
                printf '\n'
            done
            printf '%s\n' "$end"
        } >>"$tmp"
    fi

    mv "$tmp" "$target"
    if [ "$#" -gt 0 ]; then
        info "rendered $# Codex config source file(s) into ${target#"$HOME"}"
    else
        info "removed managed Codex config block from ${target#"$HOME"}"
    fi
}

title 'Setting up AI agent configs'

link_if_present "${DOTFILES}/ai/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link_if_present "${DOTFILES}/ai/AGENTS.md" "$HOME/.codex/AGENTS.md"
link_if_present "${DOTFILES}/ai/claude/settings.json" "$HOME/.claude/settings.json"
link_if_present "${DOTFILES}/ai/codex/prompts" "$HOME/.codex/prompts"

render_codex_config
