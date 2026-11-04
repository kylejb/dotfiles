#!/bin/sh -e

command_exists() {
    command -v "$@" >/dev/null 2>&1
}

user_can_sudo() {
    # Check if sudo is installed
    command_exists sudo || return 1
    # The following command has 3 parts:
    #
    # 1. Run `sudo` with `-v`. Does the following:
    #    • with privilege: asks for a password immediately.
    #    • without privilege: exits with error code 1 and prints the message:
    #      Sorry, user <username> may not run sudo on <hostname>
    #
    # 2. Pass `-n` to `sudo` to tell it to not ask for a password. If the
    #    password is not required, the command will finish with exit code 0.
    #    If one is required, sudo will exit with error code 1 and print the
    #    message:
    #    sudo: a password is required
    #
    # 3. Check for the words "may not run sudo" in the output to really tell
    #    whether the user has privileges or not. For that we have to make sure
    #    to run `sudo` in the default locale (with `LANG=`) so that the message
    #    stays consistent regardless of the user's locale.

    # shellcheck disable=SC1007
    ! LANG= sudo -n -v 2>&1 | grep -q 'may not run sudo'
}

# The [ -t 1 ] check only works when the function is not called from
# a subshell (like in `$(...)` or `(...)`, so this hack redefines the
# function at the top level to always return false when stdout is not
# a tty.
if [ -t 1 ]; then
    is_tty() {
        true
    }
else
    is_tty() {
        false
    }
fi

setup_color() {
    # Only use colors if connected to a terminal
    if ! is_tty; then
        FMT_RED=""
        FMT_GREEN=""
        FMT_YELLOW=""
        FMT_BLUE=""
        FMT_BOLD=""
        FMT_RESET=""
        return
    fi

    FMT_RED=$(printf '\033[31m')
    FMT_GREEN=$(printf '\033[32m')
    FMT_YELLOW=$(printf '\033[33m')
    FMT_BLUE=$(printf '\033[34m')
    FMT_BOLD=$(printf '\033[1m')
    FMT_RESET=$(printf '\033[0m')
}

#####################
# Logging           #
#####################

title() {
    printf "\n%s%s%s\n" "${FMT_BLUE}" "$1" "${FMT_RESET}"
    printf "%s%s%s\n\n" "${FMT_BOLD}" "==============================" "${FMT_RESET}"
}

success() {
    echo "${FMT_GREEN}$1${FMT_RESET}"
}

info() {
    printf '%s\n' "${FMT_BOLD}${FMT_BLUE}==> $*${FMT_RESET}"
}

warn() {
    printf '%s\n' "${FMT_YELLOW}! $*${FMT_RESET}"
}

error() {
    printf '%s\n' "${FMT_RED}x $*${FMT_RESET}" >&2
    exit 1
}

#####################
# Links             #
#####################

# True when $1 is a symlink owned by this dotfiles repo.
is_dotfiles_link() {
    _idl_target="$1"
    [ -L "$_idl_target" ] || return 1

    _idl_link="$(readlink "$_idl_target")" || return 1
    case "$_idl_link" in
    "$DOTFILES" | "$DOTFILES"/*) return 0 ;;
    /*) return 1 ;;
    esac

    _idl_dir="$(dirname "$_idl_target")"
    _idl_link_dir="$(dirname "$_idl_link")"
    _idl_link_base="$(basename "$_idl_link")"
    _idl_abs="$(
        cd "$_idl_dir" 2>/dev/null &&
            cd "$_idl_link_dir" 2>/dev/null &&
            printf '%s/%s' "$(pwd -P)" "$_idl_link_base"
    )" || return 1

    case "$_idl_abs" in
    "$DOTFILES" | "$DOTFILES"/*) return 0 ;;
    *) return 1 ;;
    esac
}

# Symlink $1 -> $2, but never clobber a real file/dir or external symlink at
# the target — that's local data. Refreshes only dotfiles-owned symlinks.
# Shared by setup_symlinks and the topic appliers (ai/gnupg/ssh).
safe_link() {
    _sl_src="$1"
    _sl_target="$2"

    if [ -L "$_sl_target" ]; then
        if ! is_dotfiles_link "$_sl_target"; then
            warn "~${_sl_target#"$HOME"} is a symlink outside \$DOTFILES... skipping"
            return 0
        fi
    elif [ -e "$_sl_target" ]; then
        warn "~${_sl_target#"$HOME"} exists and is not a symlink... skipping"
        return 0
    fi

    mkdir -p "$(dirname "$_sl_target")"
    ln -sfn "$_sl_src" "$_sl_target"
    info "linked ~${_sl_target#"$HOME"} -> $_sl_src"
}

####################
# OS detection     #
####################
#
# POSIX-safe (uname-based, no $OSTYPE). Prefer the predicates at call sites.

is_macos() { [ "$(uname -s)" = 'Darwin' ]; }
is_linux() { [ "$(uname -s)" = 'Linux' ]; }

# Platform family: macos | linux | unknown
get_os() {
    case "$(uname -s)" in
    Darwin) echo 'macos' ;;
    Linux) echo 'linux' ;;
    *) echo 'unknown' ;;
    esac
}

# True on Debian, Ubuntu, and their derivatives (Mint, Pop!_OS, Raspbian, ...),
# which name debian or ubuntu in ID or ID_LIKE.
is_debian_family() {
    is_linux && [ -r /etc/os-release ] || return 1
    # shellcheck source=/dev/null
    case " $(. /etc/os-release && echo "${ID:-} ${ID_LIKE:-}") " in
    *' debian '* | *' ubuntu '*) return 0 ;;
    esac
    return 1
}

#####################
# Machine profile   #
#####################
#
# The profile distinguishes machines (e.g. 'personal' vs 'work') so that
# tooling, git identity, and secret handling can differ. The single source of
# truth is a one-word file readable from both POSIX sh and zsh. The
# DOTFILES_PROFILE env var (exported early by zsh/zshenv.symlink) wins if set.

# Path to the profile file (honors XDG).
profile_file() {
    echo "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/profile"
}

# Echo the active profile, or nothing if unset.
get_profile() {
    if [ -n "${DOTFILES_PROFILE:-}" ]; then
        echo "$DOTFILES_PROFILE"
    elif [ -r "$(profile_file)" ]; then
        cat "$(profile_file)"
    fi
}

is_personal() {
    [ "$(get_profile)" = 'personal' ]
}

is_work() {
    [ "$(get_profile)" = 'work' ]
}

# Prompt for and persist the profile if it is not already set.
setup_profile() {
    if [ -n "$(get_profile)" ]; then
        info "Detected profile: $(get_profile). Skipping profile setup..."
        return 0
    fi

    title 'Choose a machine profile'
    info 'personal = full setup incl. 1Password; work = no 1Password, local secrets only'

    profile=''
    while [ "$profile" != 'personal' ] && [ "$profile" != 'work' ]; do
        printf 'Profile [personal/work]: '
        read -r profile
    done

    file="$(profile_file)"
    mkdir -p "$(dirname "$file")"
    echo "$profile" >"$file"
    export DOTFILES_PROFILE="$profile"
    success "Profile set to '$profile' ($file)"
}

setup_color
