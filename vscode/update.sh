#!/bin/sh

update_extensions() {
    echo "Updating VSCode extensions..."

    code --install-extension "aaron-bond.better-comments"
    code --install-extension "christian-kohler.path-intellisense"
    code --install-extension "dbaeumer.vscode-eslint"
    code --install-extension "eamodio.gitlens"
    code --install-extension "esbenp.prettier-vscode"
    code --install-extension "golang.go"
    code --install-extension "gruntfuggly.todo-tree"
    code --install-extension "jasonlhy.hungry-delete"
    code --install-extension "mhutchie.git-graph"
    code --install-extension "ms-vscode-remote.remote-containers"
    code --install-extension "prisma.prisma"
}

update_extensions
