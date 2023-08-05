# kylejb's dotfiles

Supports macOS, Debian/Ubuntu, and Windows 11.

> **Warning**
> Use at your own risk.

## Install

Script will download this repository to `~/.dotfiles` and will symlink the appropriate files to your home directory.

* Windows:

    ```ps1
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass;
    Invoke-Expression (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/kylejb/dotfiles/HEAD/installer.ps1")
    ```

* MacOS / Linux:

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/kylejb/dotfiles/HEAD/installer.sh)"
    ```

Everything is configurable from this folder. The main file you'll want to change right off the bat is zsh/zshrc.symlink, which sets up a few paths that may differ on your particular machine.

## Update

`dot` is a simple script that installs some dependencies, sets sane macOS defaults, and so on. Tweak this script, and occasionally run dot from time to time to keep your environment fresh and up-to-date. You can find this script in `bin/`.

## Structure

Everything is built around "topic" areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
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
- **topic/install.sh**: Any file named `install.sh` is executed when you run `script/install`. To avoid being loaded automatically, its extension is `.sh`, not `.zsh`.
- **topic/update.sh**: Any file named `update.sh` is executed when you run `script/update`. To avoid being loaded automatically, its extension is `.sh`, not `.zsh`.
- **topic/\*.symlink**: Any file ending in `*.symlink` gets symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.

## Thanks

A decent amount of code stem or are inspired by [Juan Manual Orbegoso](https://github.com/JMOrbegoso)'s [dotfiles](https://github.com/JMOrbegoso/Dotfiles-for-Windows-11)
and [Zach Holman](https://github.com/holman)'s [dotfiles](https://github.com/holman/dotfiles).
