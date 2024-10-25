#!/bin/sh -e

# shellcheck disable=SC1091,SC3046
. ${DOTFILES}/utils.sh

cp "${DOTFILES}/gnupg/base.gpg-agent.conf" "${DOTFILES}/gnupg/gpg-agent.conf"

case "$DETECTED_OS" in
darwin)
  echo "pinentry-program /opt/homebrew/bin/pinentry" | tee -a "${DOTFILES}/gnupg/gpg-agent.conf" >/dev/null
  ;;
linux-gnu)
  echo "pinentry-program /usr/local/bin/pinentry-curse" | tee -a "${DOTFILES}/gnupg/gpg-agent.conf" >/dev/null
  ;;
*)
  error "Unknown platform – $(uname | tr '[:upper:]' '[:lower:]') is not supported"
  exit 1
  ;;
esac

#pinentry-program /usr/local/bin/pinentry-curses    # used in Debian
#pinentry-program /usr/bin/pinentry-gnome3          # used in Fedora
#pinentry-program /usr/local/bin/pinentry-mac       # used in macOS (intel)
#pinentry-program /opt/homebrew/bin/pinentry-mac    # used in macOS (silicon)
#pinentry-program /usr/bin/pinentry-tty
#pinentry-program /usr/bin/pinentry-gtk-2
#pinentry-program /usr/bin/pinentry-x11

info 'Setting up ~/.gnupg'
if [ ! -d ~/.gnupg ]; then
  mkdir "$HOME/.gnupg"
fi

gpg_agent_source="$DOTFILES/gnupg/gpg-agent.conf"
gpg_agent_target="$HOME/.gnupg/gpg-agent.conf"
if [ -e "$gpg_agent_target" ]; then
  info "~${gpg_agent_target#$HOME} already exists... Skipping."
else
  info "Creating symlink for $gpg_agent_source"
  ln -s "$gpg_agent_source" "$gpg_agent_target"
fi

gpg_conf_source="$DOTFILES/gnupg/gpg.conf"
gpg_conf_target="$HOME/.gnupg/gpg.conf"
if [ -e "$gpg_conf_target" ]; then
  info "~${gpg_conf_target#$HOME} already exists... Skipping."
else
  info "Creating symlink for $gpg_conf_source"
  ln -s "$gpg_conf_source" "$gpg_conf_target"
fi
