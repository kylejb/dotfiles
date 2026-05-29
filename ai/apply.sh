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

# Symlink $1 -> $2, but never clobber a real (non-symlink) file/dir at the
# target — that's local data. Refreshes an existing symlink. Creates parents.
safe_link() {
    item="$1"
    target="$2"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        printf '! %s already exists and is not a symlink... Skipping.\n' "$target"
        return 0
    fi

    mkdir -p "$(dirname "$target")"
    ln -sfn "$item" "$target"
    printf '==> linked %s -> %s\n' "$target" "$item"
}

# Link every top-level entry under $src into $dst. $3 is an optional
# space-separated list of basenames to skip (e.g. docs / merge-only dirs).
link_tree() {
    src="$1"
    dst="$2"
    skip="${3:-}"

    [ -d "$src" ] || return 0

    mkdir -p "$dst"
    for item in "$src"/* "$src"/.[!.]*; do
        [ -e "$item" ] || continue
        base="$(basename "$item")"
        case " $skip " in
        *" $base "*) continue ;;
        esac
        safe_link "$item" "$dst/$base"
    done
}

# Merge ai/codex/config.d/*.toml into ~/.codex/config.toml inside a managed
# block. Codex rewrites config.toml itself, so we never symlink it — we inject
# only our additive sections (e.g. [mcp_servers.*]) and leave the rest alone.
# Idempotent: re-running replaces the block. See ai/codex/README.md.
merge_codex_config() {
    src_dir="${DOTFILES}/ai/codex/config.d"
    target="$HOME/.codex/config.toml"
    begin='# >>> dotfiles:codex (managed — edit ai/codex/config.d/, run dot --apply) >>>'
    end='# <<< dotfiles:codex <<<'

    [ -d "$src_dir" ] || return 0

    # Collect fragments (real *.toml, excluding *.example templates).
    set --
    for f in "$src_dir"/*.toml; do
        [ -e "$f" ] || continue
        case "$f" in *.example) continue ;; esac
        set -- "$@" "$f"
    done
    [ "$#" -gt 0 ] || return 0 # nothing to merge

    mkdir -p "$(dirname "$target")"
    [ -f "$target" ] || : >"$target"

    tmp="$(mktemp)"
    # Drop any previous managed block, then append a fresh one.
    awk -v b="$begin" -v e="$end" '
        $0==b {inblock=1; next}
        $0==e {inblock=0; next}
        !inblock {print}
    ' "$target" >"$tmp"
    {
        printf '\n%s\n' "$begin"
        cat "$@"
        printf '%s\n' "$end"
    } >>"$tmp"
    mv "$tmp" "$target"
    printf '==> merged %d Codex config fragment(s) into %s\n' "$#" "$target"
}

printf '\nSetting up AI agent configs\n'
link_tree "${DOTFILES}/ai/claude" "$HOME/.claude"
# README.md is docs; config.d is merged (below), not symlinked.
link_tree "${DOTFILES}/ai/codex" "$HOME/.codex" "README.md config.d"

# Single source of truth for agent standards: Codex reads AGENTS.md, Claude
# reads CLAUDE.md — point both at the same tracked file.
safe_link "${DOTFILES}/ai/claude/CLAUDE.md" "$HOME/.codex/AGENTS.md"

merge_codex_config
