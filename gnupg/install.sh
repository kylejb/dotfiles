#!/bin/sh -e

cp ${DOTFILES}/gnupg/base.gpg-agent.conf ${DOTFILES}/gnupg/gpg-agent.conf

case "$DETECTED_OS" in
  darwin)
    echo "pinentry-program /opt/homebrew/bin/pinentry-mac" | tee -a ${DOTFILES}/gnupg/gpg-agent.conf > /dev/null
    ;;
  linux-gnu)
    echo "pinentry-program /usr/local/bin/pinentry-curse" | tee -a ${DOTFILES}/gnupg/gpg-agent.conf > /dev/null
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
