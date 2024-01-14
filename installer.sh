#!/bin/sh -e
#
# First time installation for new systems

# Default settings
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
export ZSH="${ZSH:-$DOTFILES/zsh}"

# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"

if [ ! -d "$DOTFILES" ]; then
    echo "Installing kylejb/dotfiles"
    git clone "${REMOTE}" "${DOTFILES}" || true

    # shellcheck source=/dev/null
    . "${DOTFILES}/script/bootstrap"
fi
