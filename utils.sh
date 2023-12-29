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
    #
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
    echo "\n${FMT_BLUE}$1${FMT_RESET}"
    echo "${FMT_BOLD}==============================${FMT_RESET}\n"
}

error() {
    echo "${FMT_RED}Error: ${FMT_RESET}$1"
    # shellcheck disable=SC2317
    exit 1
}

warning() {
    echo "${FMT_YELLOW}Warning: ${FMT_RESET}$1"
}

info() {
    echo "${FMT_BLUE}Info: ${FMT_RESET}$1"
}

success() {
    echo "${FMT_GREEN}$1${FMT_RESET}"
}

#####################
# Utility Functions #
#####################

heading() {
    printf '\n%s\n' "${FMT_BOLD}${UNDERLINE}${BLUE}$*${NO_COLOR}"
}

info() {
    printf '%s\n' "${FMT_BOLD}${FMT_BLUE}==> $*${NO_COLOR}"
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

# shellcheck disable=SC1091,SC3028,SC3043,SC3046
get_os() {
    local os=''
    if echo "$OSTYPE" | grep -iq 'darwin'; then
        os='darwin'
    elif echo "$OSTYPE" | grep -iq 'linux-gnu'; then
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

get_os
setup_color
