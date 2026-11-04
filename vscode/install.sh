#!/bin/sh

set -e

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# shellcheck source=/dev/null
. "${DOTFILES}/utils.sh"

install_extensions() {
    code --force --install-extension "aaron-bond.better-comments"
    code --force --install-extension "christian-kohler.path-intellisense"
    code --force --install-extension "dbaeumer.vscode-eslint"
    code --force --install-extension "eamodio.gitlens"
    code --force --install-extension "esbenp.prettier-vscode"
    code --force --install-extension "golang.go"
    code --force --install-extension "gruntfuggly.todo-tree"
    code --force --install-extension "jasonlhy.hungry-delete"
    code --force --install-extension "mhutchie.git-graph"
    code --force --install-extension "ms-vscode-remote.remote-containers"
}

# Settings are linked by vscode/apply.sh; this only installs extensions.
echo "Installing VSCode extensions. This may take a minute..."
install_extensions
