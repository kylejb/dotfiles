#!/bin/sh -e

echo "Not implemented..."

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
        warn "Run init.ps1 instead"
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
