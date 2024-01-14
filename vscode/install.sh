#!/bin/sh -e

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

# Set up symlinks for settings, snippets, and keybindings
echo "Setting up VSCode. This may take a minute..."
# shellcheck disable=SC2010
for file in $(ls -A "${DOTFILES}/vscode" | grep --include -r -E '\.json|snippets'); do
    # shellcheck disable=3028
    if echo "$OSTYPE" | grep -iq 'darwin'; then
        ln -svf "${DOTFILES}/vscode/$file" "$HOME/Library/Application Support/Code/User/settings.json"
    elif echo "$OSTYPE" | grep -iq 'linux-gnu'; then
        ln -svf "${DOTFILES}/vscode/$file" "$HOME/.config/Code/User/$file"
    else
        echo 'Unsupported OS detected. Skipping VSCode setup...'
    fi
done

install_extensions
