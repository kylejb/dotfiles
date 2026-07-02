# Codex configs

Shareable Codex configuration, applied by `ai/apply.sh` through `dot --apply`.

## What lives here

| Path | How it's applied | Notes |
|------|------------------|-------|
| `../AGENTS.md` | symlinked to `~/.codex/AGENTS.md` | shared agent instructions |
| `prompts/` | symlinked to `~/.codex/prompts/` | custom prompts |
| `config.toml` | rendered into `~/.codex/config.toml` | committed, non-secret config |
| `config.local.toml` | rendered after `config.toml` | gitignored, machine-local config |
| `config.toml.example` | not applied | template to copy from |

`README.md` is repo documentation only. It is never linked into `~/.codex`.

## Managed config block

Codex may rewrite `~/.codex/config.toml` with local runtime/project/TUI state, so
the dotfiles repo does not symlink that live file. Instead, `dot --apply`
preserves everything outside a managed block and replaces only the block:

```toml
# Codex-owned or local unmanaged content

# >>> dotfiles:codex (managed by dot --apply) >>>
# rendered from ai/codex/config.toml and ai/codex/config.local.toml
# <<< dotfiles:codex <<<
```

Rules:

- Do not edit inside the managed block in `~/.codex/config.toml`; it is replaced
  by `dot --apply`.
- Put shared non-secret config in `ai/codex/config.toml`.
- Put machine-local or secret-bearing config in `ai/codex/config.local.toml`.
- Leave Codex-owned runtime settings outside the block.
- Avoid defining the same TOML table/key both inside and outside the managed
  block; this script intentionally does not validate duplicates yet.

## Secrets

- Commit only non-secret definitions, such as commands, args, and public
  endpoints.
- Keep raw tokens and machine-local config in `config.local.toml` or have tools
  read environment variables exported from local shell config.
- The `work` machine cannot use 1Password. Keep work secrets in local files, not
  `op://` references. See the repo README's profile/secret notes.

## Never synced

`auth.json`, `sessions/`, `history`, `memories/`, `[projects.*]`, `[tui.*]`,
and other Codex runtime state should stay in the live config outside the managed
block or in ignored runtime files.
