# Codex configs

Shareable Codex configuration, applied by `ai/apply.sh` (run via `dot --apply`).

## What lives here

| Path | How it's applied | Notes |
|------|------------------|-------|
| `prompts/` | symlinked → `~/.codex/prompts/` | custom prompts |
| `config.d/*.toml` | **merged** into `~/.codex/config.toml` | additive sections only (e.g. `[mcp_servers.*]`) |
| `config.d/*.toml.example` | not applied | committed templates to copy from |
| _(AGENTS.md)_ | symlinked → `~/.codex/AGENTS.md` | shared from `../claude/CLAUDE.md` (single source) |

`README.md` and `config.d/` are skipped by the symlink step on purpose.

## Why `config.toml` is merged, not symlinked

Codex rewrites `~/.codex/config.toml` itself (marketplaces, trusted projects,
TUI state, timestamps), so we never symlink or commit it wholesale — it stays
machine-local and gitignored. Instead, `apply` injects the concatenation of
`config.d/*.toml` into a **managed block** delimited by markers:

```
# >>> dotfiles:codex (managed — edit ai/codex/config.d/, run dot --apply) >>>
...your fragments...
# <<< dotfiles:codex <<<
```

Re-running `dot --apply` replaces that block (idempotent) and leaves Codex's
own sections untouched. If Codex ever regenerates the file and drops the block,
just `dot --apply` again. Only put **additive** sections in fragments — don't
duplicate keys Codex manages, or it'll be a TOML parse error.

Codex reads MCP servers (and the rest of its config) from `config.toml`, so the
merge approach is the one to use — `[mcp_servers.*]` fragments go in `config.d/`.

## Secrets (mixed)

- **Non-secret** definitions (command, args, public endpoints) → commit as
  `config.d/<name>.toml`.
- **Secret-bearing** fragments → `config.d/<name>.local.toml` (gitignored), or
  reference an env var the server reads at runtime. **Never commit raw keys.**
- The `work` machine cannot use 1Password — keep work secrets in local files,
  not `op://` references. See the repo README's profile/secret notes.

## Never synced

`config.toml` (wholesale), `auth.json`, `sessions/`, `history`, `memories/`,
`[marketplaces.*]`, `[projects.*]`, `[tui.*]` — all machine/runtime state.
