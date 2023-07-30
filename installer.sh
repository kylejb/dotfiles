#!/bin/sh -e
#
# First time installation for new systems

# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"

# shellcheck disable=SC1091,SC3046
. utils.sh

#####################
#  Core Functions   #
#####################

clone_dotfiles() {
    # local
    # DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
    # ZSH="${ZSH:-$DOTFILES/zsh}"

    # # github
    # REPO=${REPO:-kylejb/dotfiles}
    # SOURCE=${SOURCE:-https://github.com/${REPO}}
    # REMOTE=${REMOTE:-${SOURCE}.git}
    # BRANCH=${BRANCH:-main}

    # # curl and wget options
    # TARBALL="$SOURCE/tarball/${BRANCH}"
    # TAR_CMD="tar -xzv -C "$DOTFILES" --strip-components=1 --exclude='{.github}'"

    # command_exists() {
    # command -v "$@" >/dev/null 2>&1
    # }

    # if command_exists "git"; then
    # CMD="git clone $REMOTE $DOTFILES"
    # elif command_exists "curl"; then
    # CMD="curl --output-dir "${DOTFILES}" -#L $TARBALL | $TAR_CMD"
    # elif command_exists "wget"; then
    # CMD="wget --directory-prefix=${DOTFILES} --no-check-certificate -O - $TARBALL | $TAR_CMD"
    # fi

    # if [ -z "$CMD" ]; then
    # echo "No git, curl or wget available. Aborting."
    # else
    # echo "Installing dotfiles..."
    # mkdir -p "$DOTFILES"
    # eval "$CMD"

    # # TODO: invoke other setup scripts
    # cd ${DOTFILES}
    # fi
    heading "Clone kylejb/doftiles"
    git clone "https://github.com/kylejb/dotfiles.git" "${HOME}/.dotfiles" || true
}

# TODO: add check for valid install before setting up
setup_shell() {
    title 'Configuring shell'

    [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"
    if ! grep "$zsh_path" /etc/shells; then
        info "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        info "default shell changed to $zsh_path"
    fi
}

setup_git() {
    if [ -f "$HOME/.gitconfig.local" ]; then
        info "Detected local git configuration. Skipping Git setup..."
        return 0
    fi
    title "Setting up Git"

    defaultName="Kyle J. Burda"
    defaultEmail="47502769+kylejb@users.noreply.github.com"
    defaultGithub="kylejb"
    defaultSigningkey="0x0"

    read -rp "Name [$defaultName] " name
    read -rp "Email [$defaultEmail] " email
    read -rp "Github username [$defaultGithub] " github
    read -rp "Signing key [$defaultSigningkey] " signingkey

    git config -f ~/.gitconfig.local user.name "${name:-$defaultName}"
    git config -f ~/.gitconfig.local user.email "${email:-$defaultEmail}"
    git config -f ~/.gitconfig.local user.signingkey "${signingkey:-$defaultSigningkey}"
    git config -f ~/.gitconfig.local github.user "${github:-$defaultGithub}"
    git config -f ~/.gitconfig.local commit.gpgsign true

    if [[ "$(get_os)" == 'darwin' ]]; then
        git config -f ~/.gitconfig.local credential.helper "osxkeychain"
    else
        warn "Did not set credential.helper"
    fi
}

get_linkables() {
    find -H "$DOTFILES" -maxdepth 3 -name '*.symlink'
}

setup_symlinks() {
    title "Creating symlinks"

    for file in $(get_linkables); do

        target="$HOME/.$(basename "$file" '.symlink')"
        if [ -e "$target" ]; then
            info "~${target#$HOME} already exists... Skipping."
        else
            info "Creating symlink for $file"
            ln -s "$DOTFILES/$file" "$target"
        fi
    done

    info "installing to ~/.config"

    config_files=$(find "$DOTFILES/config" -maxdepth 1 2>/dev/null)
    for config in $config_files; do
        target="$HOME/.config/$(basename "$config")"
        if [ -e "$target" ]; then
            info "~${target#$HOME} already exists... Skipping."
        else
            info "Creating symlink for $config"
            ln -s "$config" "$target"
        fi
    done
}

setup_shell
setup_git
setup_symlinks
# TODO: setup zsh, set shell, remove_dirs, install os specific tool(s), and refactor
