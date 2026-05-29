#!/bin/sh -e

runSetup() {
    # Ask for the administrator password upfront
    sudo -v

    # Keep-alive: update existing `sudo` timestamp until the script has finished
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
}

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
        FMT_RAINBOW=""
        FMT_RED=""
        FMT_GREEN=""
        FMT_YELLOW=""
        FMT_BLUE=""
        FMT_BOLD=""
        FMT_RESET=""
        NO_COLOR=""
        return
    fi

    if command_exists supports_truecolor && supports_truecolor; then
        FMT_RAINBOW="
      $(printf '\033[38;2;255;0;0m')
      $(printf '\033[38;2;255;97;0m')
      $(printf '\033[38;2;247;255;0m')
      $(printf '\033[38;2;0;255;30m')
      $(printf '\033[38;2;77;0;255m')
      $(printf '\033[38;2;168;0;255m')
      $(printf '\033[38;2;245;0;172m')
    "
    else
        FMT_RAINBOW="
      $(printf '\033[38;5;196m')
      $(printf '\033[38;5;202m')
      $(printf '\033[38;5;226m')
      $(printf '\033[38;5;082m')
      $(printf '\033[38;5;021m')
      $(printf '\033[38;5;093m')
      $(printf '\033[38;5;163m')
    "
    fi

    FMT_RED=$(printf '\033[31m')
    FMT_GREEN=$(printf '\033[32m')
    FMT_YELLOW=$(printf '\033[33m')
    FMT_BLUE=$(printf '\033[34m')
    FMT_BOLD=$(printf '\033[1m')
    FMT_RESET=$(printf '\033[0m')
    NO_COLOR=$(printf '\033[0m')
}

title() {
    printf "\n%s%s%s\n" "${FMT_BLUE}" "$1" "${FMT_RESET}"
    printf "%s%s%s\n\n" "${FMT_BOLD}" "==============================" "${FMT_RESET}"
}

warning() {
    echo "${FMT_YELLOW}Warning: ${FMT_RESET}$1"
}

success() {
    echo "${FMT_GREEN}$1${FMT_RESET}"
}

#####################
# Utility Functions #
#####################

heading() {
    printf '\n%s\n' "${FMT_BOLD}${FMT_BLUE}$*${FMT_RESET}"
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

completed() {
    printf '\n%s\n' "${FMT_GREEN}$*${FMT_RESET}"
}

has() {
    command -v "$1" 1>/dev/null 2>&1
}

####################
# OS detection     #
####################
#
# Standardized, POSIX-safe (uname-based, no $OSTYPE) helpers used everywhere
# OS-specific behavior is needed. Prefer the predicates at call sites:
#   is_macos / is_linux / is_wsl
# get_os returns the platform family; get_distro the Linux distro id.

is_macos() { [ "$(uname -s)" = 'Darwin' ]; }
is_linux() { [ "$(uname -s)" = 'Linux' ]; }

# True on Windows Subsystem for Linux (WSL1/WSL2).
is_wsl() {
    is_linux || return 1
    [ -r /proc/version ] && grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null
}

# Platform family: macos | linux | unknown
get_os() {
    case "$(uname -s)" in
    Darwin) echo 'macos' ;;
    Linux) echo 'linux' ;;
    *) echo 'unknown' ;;
    esac
}

# Linux distribution id (debian, ubuntu, alpine, fedora, ...); empty elsewhere.
get_distro() {
    is_linux || return 0
    if [ -r /etc/os-release ]; then
        # shellcheck source=/dev/null
        . /etc/os-release
        echo "${ID:-}"
    fi
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
