#!/bin/sh

update_extensions() {
    echo "Updating VSCode extensions..."

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

update_extensions
