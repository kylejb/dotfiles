#!/bin/sh -e

main() {
    case $(uname | tr '[:upper:]' '[:lower:]') in
	linux*)
		PLATFORM="linux"
		;;
	darwin*)
		PLATFORM="macos"
		;;
	msys*)
		PLATFORM="windows"
		warn "Run Windows.ps1 instead"
		exit 1
		;;
	*)
		error "Unknown platform – $(uname | tr '[:upper:]' '[:lower:]') is not supported"
		exit 1
		;;
	esac

    # Install
	case "${ACTION}" in
	install)
		heading "Installing kylejb/dotfiles"
		clone_dotfiles
		setup_config_files
		install_tools
		set_default_shell
		reminders
		completed "Enjoy your new environment!"
		;;
    update)
        # TODO: add support for updating/refreshing changes
        warn "This action is not yet supported"
        exit 1
        ;;
	uninstall)
		heading "Uninstalling kylejb/dotfiles"
		warn "This uninstall script does not remove packages/tools installed with apt, Chocolatey, or Homebrew"
		remove_dirs
		completed "Enjoy your clean environment!"
		;;
	*)
		error "Unknown ACTION (${ACTION}). If this was a bug, please report it: https://github.com/kylejb/dotfiles/issues/new"
		exit 1
		;;
	esac
}

#####################
# Utility Functions #
#####################

heading() {
	printf '\n%s\n' "${BOLD}${UNDERLINE}${BLUE}$*${NO_COLOR}"
}

info() {
	printf '%s\n' "${BOLD}${MAGENTA}==> $*${NO_COLOR}"
}

warn() {
	printf '%s\n' "${YELLOW}! $*${NO_COLOR}"
}

error() {
	printf '%s\n' "${RED}x $*${NO_COLOR}" >&2
}

completed() {
	printf '\n%s\n' "${GREEN}$*${NO_COLOR}"
}

has() {
	command -v "$1" 1>/dev/null 2>&1
}

get_os() {
  local os=''
	if [ $( echo "$OSTYPE" | grep 'darwin' ) ] ; then
    os='darwin'
  elif [ $( echo "$OSTYPE" | grep 'linux-gnu' ) ] ; then
    source /etc/os-release
    # Set os to ID_LIKE if this field exists
    # Else default to ID
    # ref. https://www.freedesktop.org/software/systemd/man/os-release.html#:~:text=The%20%2Fetc%2Fos%2Drelease,like%20shell%2Dcompatible%20variable%20assignments.
    os="${ID_LIKE:-$ID}"
  else
    os='unknown'
  fi

  # set os to env variable
  export DETECTED_OS="$os"

  # value to return
  echo "$DETECTED_OS"
}

# usage: write_line_to_file_if_not_exists "some_line" "/some/file"
write_line_to_file_if_not_exists() {
	local LINE="$1"
	local FILE="$2"

	info "Appending ${LINE} to ${FILE} if not exists"
	grep -qxF "$LINE" "$FILE" || echo "$LINE" | sudo tee -a "$FILE"
}

# usage: get_latest_release "kylejb/dotfiles"
github_repo_latest_release() {
	curl -fsSL "https://api.github.com/repos/$1/releases/latest" |    # Get latest release from GitHub API
		grep '"tag_name":' |                                          # Get tag line
		sed -E 's/.*"([^"]+)".*/\1/'                                  # get JSON value for release tag
}

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

setup_git() {
    title "Setting up Git"

    defaultName="Kyle J. Burda"
    defaultEmail="47502769+kylejb@users.noreply.github.com"
    defaultGithub="kylejb"
    defaultSigningkey="0x0"

    read -rp "Name [$defaultName] " name
    read -rp "Email [$defaultEmail] " email
    read -rp "Github username [$defaultGithub] " github
    read -rp "Signing key [$defaultSigningkey] " signingkey

    git config -f ~/.gitconfig-local user.name "${name:-$defaultName}"
    git config -f ~/.gitconfig-local user.email "${email:-$defaultEmail}"
    git config -f ~/.gitconfig-local user.signingkey "${signingkey:-$defaultSigningkey}"
    git config -f ~/.gitconfig-local github.user "${github:-$defaultGithub}"

    if [[ "$(uname)" == "Darwin" ]]; then
        git config --global credential.helper "osxkeychain"
    else
        warn "Did not set credential.helper"
    fi
}

get_linkables() {
    find -H "$DOTFILES" -maxdepth 3 -name '*.symlink'
}

setup_symlinks() {
    title "Creating symlinks"

    for file in $(get_linkables) ; do
        target="$HOME/.$(basename "$file" '.symlink')"
        if [ -e "$target" ]; then
            info "~${target#$HOME} already exists... Skipping."
        else
            info "Creating symlink for $file"
            ln -s "$file" "$target"
        fi
    done

    echo -e
    info "installing to ~/.config"
    if [ ! -d "$HOME/.config" ]; then
        info "Creating ~/.config"
        mkdir -p "$HOME/.config"
    fi

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

        echo -e
    info "installing to ~/.gnupg"
    if [ ! -d "$HOME/.gnupg" ]; then
        info "Creating ~/.gnupg"
        mkdir -p "$HOME/.gnupg"
    fi

    # TODO: run installers
}

# TODO: setup zsh, set shell, remove_dirs, and install os specific tools
