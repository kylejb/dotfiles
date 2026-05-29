#!/bin/sh
set -e

# shellcheck disable=SC3046 source=/dev/null
. "${DOTFILES}/utils.sh"

if [ -f "${HOME}/.local/bin/mise" ]; then
  echo 'mise has already been installed'
else
  echo 'Installing mise'
  curl -fsSL https://mise.run | sh

  if command -v "${HOME}/.local/bin/mise"; then
    echo 'Successfully installed mise'
    exit 0
  fi
  echo 'Unable to locate mise after installation' 1>&2
  exit 1
fi

echo 'Installing shell completion'
if is_linux; then
  mise completion zsh  > /usr/local/share/zsh/site-functions/_mise
elif is_macos; then
  mise completion zsh  > "$(brew --prefix)/share/zsh/site-functions/_mise"
fi

echo 'Installing latest version of Go'
mise use -g go@latest

echo 'Installing system dependencies to build Node.js'
if is_linux; then
  sudo apt-get install gpg -y
elif is_macos; then
  brew install gpg
fi
echo 'Installing lts version of Node.js'
mise use -g node@lts

echo 'Installing latest version of Python'
mise use -g python@latest

echo 'Installing system dependencies to build Ruby'
if is_linux; then
  sudo apt-get install autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
elif is_macos; then
  brew install openssl@3 readline libyaml gmp autoconf
fi
echo 'Installing latest version of Ruby'
mise use -g ruby@latest

# echo 'Install latest version of Rust' # TODO: consider using ``rustup`` instead
# mise plugins install rust
# mise use -g rust@latest
