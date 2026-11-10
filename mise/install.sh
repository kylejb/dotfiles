#!/bin/sh
set -e

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# shellcheck source=/dev/null
. "${DOTFILES}/utils.sh"

if command -v mise >/dev/null 2>&1 || [ -x "${HOME}/.local/bin/mise" ]; then
  echo 'mise has already been installed'
else
  echo 'Installing mise'
  curl -fsSL https://mise.run | sh

  if [ ! -x "${HOME}/.local/bin/mise" ]; then
    echo 'Unable to locate mise after installation' 1>&2
    exit 1
  fi
  echo 'Successfully installed mise'
fi

# Ensure the (possibly freshly installed) binary is on PATH for the mise calls
# below — a fresh install lands it at ~/.local/bin/mise but doesn't reload PATH.
export PATH="${HOME}/.local/bin:${PATH}"

echo 'Installing shell completion'
if is_linux; then
  # /usr/local/share is root-owned; use sudo so set -e doesn't abort as non-root
  sudo mkdir -p /usr/local/share/zsh/site-functions
  mise completion zsh | sudo tee /usr/local/share/zsh/site-functions/_mise >/dev/null
elif is_macos; then
  mise completion zsh > "$(brew --prefix)/share/zsh/site-functions/_mise"
fi

echo 'Installing system dependencies to build Node.js'
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get install -y gpg
elif is_macos; then
  brew install gpg
else
  echo 'No apt-get and not macOS; skipping system deps (install gpg manually).'
fi
echo 'Installing system dependencies to build Ruby'
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get install -y autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
elif is_macos; then
  brew install openssl@3 readline libyaml gmp autoconf
else
  echo 'No apt-get and not macOS; skipping Ruby build deps (install manually).'
fi

# Versions live in config/mise/config.toml, linked as the global config.
echo 'Installing tools from the mise config'
mise install
