#!/bin/sh
# set -e here (not just in the shebang) so fail-fast holds when run as
# `sh apply.sh`, which ignores shebang flags.
set -e

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# shellcheck disable=SC3046 source=/dev/null
. "${DOTFILES}/utils.sh"

cp "${DOTFILES}/gnupg/base.gpg-agent.conf" "${DOTFILES}/gnupg/gpg-agent.conf"

if is_macos; then
  echo "pinentry-program /opt/homebrew/bin/pinentry" | tee -a "${DOTFILES}/gnupg/gpg-agent.conf" >/dev/null
elif is_linux; then
  echo "pinentry-program /usr/local/bin/pinentry-curse" | tee -a "${DOTFILES}/gnupg/gpg-agent.conf" >/dev/null
else
  error "Unknown platform – $(uname -s) is not supported"
fi

#pinentry-program /usr/local/bin/pinentry-curses    # used in Debian
#pinentry-program /usr/bin/pinentry-gnome3          # used in Fedora
#pinentry-program /usr/local/bin/pinentry-mac       # used in macOS (intel)
#pinentry-program /opt/homebrew/bin/pinentry-mac    # used in macOS (silicon)
#pinentry-program /usr/bin/pinentry-tty
#pinentry-program /usr/bin/pinentry-gtk-2
#pinentry-program /usr/bin/pinentry-x11

info 'Setting up ~/.gnupg'
safe_link "$DOTFILES/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
safe_link "$DOTFILES/gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf"
