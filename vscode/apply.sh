#!/bin/sh
# Link VS Code user config (settings, keybindings, snippets) into place.

set -e

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# shellcheck source=/dev/null
. "${DOTFILES}/utils.sh"

if is_macos; then
    code_user="$HOME/Library/Application Support/Code/User"
elif is_linux; then
    code_user="$HOME/.config/Code/User"
else
    warn 'Unsupported OS. Skipping VS Code config...'
    exit 0
fi

for name in settings.json keybindings.json snippets; do
    [ -e "${DOTFILES}/vscode/$name" ] || continue
    safe_link "${DOTFILES}/vscode/$name" "$code_user/$name"
done
