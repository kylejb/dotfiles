# Global agent standards

Shared, cross-project instructions for AI coding agents. This file is symlinked
to `~/.claude/CLAUDE.md` (Claude Code) and `~/.codex/AGENTS.md` (Codex), so keep
it tool-agnostic. Project-specific guidance lives in each repo's own
`CLAUDE.md`/`AGENTS.md` and takes precedence.

## Working style

- Be direct and concise. Lead with the answer; keep preamble short.
- Push back when I'm wrong or an approach is questionable — I'd rather be
  corrected than agreed with. Flag over-engineering.
- Verify before asserting. Check the code/docs/git rather than guessing, and
  say so when something is unconfirmed.
- Explain trade-offs for non-trivial decisions; don't just pick silently.
- Prefer reuse and simplicity over new abstractions. Minimize dependencies.
- Match the surrounding code's style, naming, and conventions.
- When you change something, test/verify it actually works before calling it
  done. Report failures plainly with output.

## Environment

- Primary: macOS (personal + work laptops). Also Linux/WSL2 and a Windows 11
  desktop — prefer portable solutions across all of them.
- Shell: zsh (interactive). Dotfiles live in `~/.dotfiles`.
- Toolchain: `mise` (go/node/python/ruby), `uv` (Python tools), Homebrew,
  `gh`, VS Code, `starship`.
- Shell scripting: POSIX `sh` for setup/portable scripts (validate with
  `dash`), zsh for the interactive layer.

## Constraints

- **The work machine cannot use 1Password.** Never assume `op` is present or
  shell out to it unless the machine profile is `personal`. Work uses local
  secrets only.

## Git

- Conventional Commits (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`…).
- Branch off `main` for changes; don't commit or push unless I ask.
- Keep commits focused and reviewable.

## Building AI applications

- Default to the latest, most capable Claude models.
- Include prompt caching in Anthropic SDK apps.

<!-- TODO (refine): primary languages/domains I work in; anything agents should
     avoid touching; preferred test/lint commands; review expectations. -->
