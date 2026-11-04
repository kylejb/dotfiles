#!/bin/sh
# set -e here (not just in the shebang) so fail-fast holds when run as
# `sh apply.sh`, which ignores shebang flags.
set -e

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# shellcheck source=/dev/null
. "${DOTFILES}/utils.sh"

cp "${DOTFILES}/gnupg/base.gpg-agent.conf" "${DOTFILES}/gnupg/gpg-agent.conf"

# Use whichever pinentry is on PATH (Homebrew or the distro package); with
# none, gpg-agent falls back to its built-in default.
if pinentry="$(command -v pinentry)"; then
  echo "pinentry-program $pinentry" >>"${DOTFILES}/gnupg/gpg-agent.conf"
else
  warn 'no pinentry on PATH; gpg-agent will use its default'
fi

info 'Setting up ~/.gnupg'
safe_link "$DOTFILES/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
safe_link "$DOTFILES/gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf"
