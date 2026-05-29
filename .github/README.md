# kylejb's dotfiles

Supports macOS, Debian/Ubuntu, and Windows 11.

> [!Warning]
> Use at your own risk.

## Install

Script will download this repository to `~/.dotfiles` and will symlink the appropriate files to your home directory.

- Windows:

  ```ps1
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass;
  Invoke-Expression (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/kylejb/dotfiles/HEAD/installer.ps1")
  ```

- MacOS / Linux:

  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/kylejb/dotfiles/HEAD/installer.sh)"
  ```

Everything is configurable from this folder. The main file you'll want to change right off the bat is `zsh/zshrc.symlink`, which sets up a few paths that may differ on your particular machine.

## Managing your environment with `dot`

`dot` (in `bin/`, on your `$PATH` after install) is the single front door for
managing these dotfiles:

```
dot -i, --install     Install dotfiles (runs script/bootstrap)
dot -u, --update      git pull + run all topic update.sh scripts
dot -d, --defaults    Re-apply macOS defaults (macOS only)
dot -e, --edit        Open the dotfiles directory in $EDITOR
dot     --uninstall   Remove symlinks (does NOT remove installed packages)
dot -h, --help        Show usage
```

Run `dot -u` from time to time to keep your environment fresh. On Windows, use
`init.ps1` instead — `dot` will refuse to run there.

## Machine profiles

Each machine has a profile — `personal` or `work` — that lets tooling, git
identity, and secret handling differ per machine. Install prompts for it once
and writes the single word to `~/.config/dotfiles/profile` (untracked). It is
exported as `$DOTFILES_PROFILE` early in `zsh/zshenv.symlink`, so any script or
shell can gate on it.

Helpers live in `utils.sh`: `get_profile`, `is_personal`, `is_work`. The key
rule: **the `work` profile must never invoke 1Password (`op`)** — work uses
local secrets only.

## Structure

Everything is built around "topic" areas. If you're adding a new area to your
forked dotfiles — "Java", for instance — you can add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

### components

There are a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/install.sh**: Installs packages/tools (the heavy, occasional path). Run via `script/install` (and during a full `dot -i`). Use this for anything that fetches/builds software.
- **topic/apply.sh**: (Re-)renders and links config — the fast, frequent path with **no package installs**. Run via `dot -a` / `script/apply` (and during a full install). Use this for templated/generated configs (see `gnupg/`) and symlinking config into place (see `ai/`, `ssh/`). Prefer rendering (template → generated, gitignored file) over a raw symlink whenever an app rewrites its own config or it must vary per machine.
- **topic/update.sh**: Any file named `update.sh` is executed when you run `script/update`. To avoid being loaded automatically, its extension is `.sh`, not `.zsh`.
- **topic/\*.symlink**: Any file ending in `*.symlink` gets symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.

## Thanks

A decent amount of code stem or are inspired by [Juan Manual Orbegoso](https://github.com/JMOrbegoso)'s [dotfiles](https://github.com/JMOrbegoso/Dotfiles-for-Windows-11)
and [Zach Holman](https://github.com/holman)'s [dotfiles](https://github.com/holman/dotfiles).
