#!/bin/sh -e

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

# Set up symlinks for settings, keybindings, and snippets.
echo "Setting up VSCode. This may take a minute..."

# Resolve the VS Code "User" config dir per OS.
if is_macos; then
    code_user="$HOME/Library/Application Support/Code/User"
elif is_linux; then
    code_user="$HOME/.config/Code/User"
else
    code_user=''
    echo 'Unsupported OS detected. Skipping VSCode setup...'
fi

if [ -n "$code_user" ]; then
    mkdir -p "$code_user"
    # Link each tracked config file to its OWN destination (not all to settings.json).
    for name in settings.json keybindings.json; do
        src="${DOTFILES}/vscode/$name"
        [ -e "$src" ] && ln -sfnv "$src" "$code_user/$name"
    done
    # Snippets directory, if present.
    [ -d "${DOTFILES}/vscode/snippets" ] && ln -sfnv "${DOTFILES}/vscode/snippets" "$code_user/snippets"
fi

install_extensions
