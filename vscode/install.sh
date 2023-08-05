#!/bin/sh -e

install_extensions() {
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

# Set up symlinks for settings, snippets, and keybindings
echo "Setting up VSCode. This may take a minute..."
for file in $(ls -A "$PWD/vscode" | grep --include -r -E '\.json|snippets'); do
    # shellcheck disable=3028
    if echo "$OSTYPE" | grep -iq 'darwin'; then
        ln -sv "$PWD/$file" "$HOME/Library/Application\ Support/Code/User/"
    elif echo "$OSTYPE" | grep -iq 'linux-gnu'; then
        ln -sv "$PWD/$file" "$HOME/.config/Code/User/"
    else
        echo "Unsupported OS detected. Skipping VSCode setup..."
    fi
done

install_extensions
