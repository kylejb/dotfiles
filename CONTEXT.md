# Dotfiles

A cross-platform (macOS, Linux, Windows through WSL2) personal environment managed as
bespoke POSIX `sh` — see [ADR 0001](docs/adr/0001-bespoke-posix-sh-over-dotfiles-manager.md).

## Language

**Topic**:
A self-contained subdirectory owning one area of the environment (e.g. `gnupg`,
`ssh`, `ai`). May carry any of three lifecycle scripts, discovered by name.

**Installer** (`install.sh`):
A topic's package/tool provisioning step — heavy, run once. Stops at its first
error. A failed installer stops bootstrap before shell and config setup.
_Avoid_: setup, provision.

**Applier** (`apply.sh`):
A topic's config render-and-link step — fast, idempotent, no package installs.
Stops at its first error.
_Avoid_: link step, sync.

**Updater** (`update.sh`):
A topic's refresh step. Best-effort: one failing step doesn't stop the next.

**Runner**:
A top-level `script/` orchestrator — `script/install`, `script/apply`,
`script/update` — that runs one lifecycle script across all topics. A failing
topic is reported and the rest still run; the runner fails if any did.

**Profile**:
A machine's identity class — `personal` or `work` — read from
`~/.config/dotfiles/profile`. Gates tooling, git identity, and secret handling.
The `work` profile must never invoke 1Password.
_Avoid_: environment, machine type.

**Self-contained script**:
A script that sets its own `DOTFILES` fallback and sources `utils.sh` itself, so
it runs correctly whether invoked by a runner or standalone.
