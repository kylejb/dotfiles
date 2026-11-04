# Bespoke POSIX sh over a third-party dotfiles manager

**Status:** accepted

We manage these dotfiles with hand-written POSIX `sh` — our own symlinking
(`safe_link`), template→render (`gnupg`), OS detection, and
profile gating — rather than adopting a dedicated manager. We evaluated
`chezmoi` explicitly and declined: keeping **zero external runtime dependencies**
and full, transparent control of the machinery is a hard value for this repo at
this time.

## Considered options

- **chezmoi** — would subsume most of the bespoke `sh` (~779 lines at the time) and, decisively,
  replace the separate ~258-line PowerShell layer by applying one source of truth
  natively on Windows. Rejected: introduces a third-party dependency and tool
  lock-in we don't want to take on now.
- **GNU stow / nix home-manager** — same third-party-dependency objection; stow
  also doesn't handle templating or profiles, home-manager pulls in all of Nix.

## Consequences

- Symlink, template, OS-detection, and profile logic is ours to maintain and test
  across macOS, Linux, and Windows.
- Windows cannot share the `sh` implementation for free; it needs either a parallel
  implementation or a POSIX shell (Git Bash/MSYS2) to run the same scripts. See the
  follow-up decision on Windows execution.
- Revisit if cross-platform maintenance cost outgrows the value of zero-dependency.
