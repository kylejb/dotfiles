#!/usr/bin/env bash
# Dotfile installation entry point for codespaces

set -e

CODESPACE_DOTFILES=$(cd "$(dirname "$0")" && pwd)

echo "Preparing codespace environment..."

echo "Updating container dependencies..."
sudo apt-get update

echo "Setting up shell environment..."
rm ~/.zshrc

if ! [ -x "$(command -v zsh)" ]; then
    echo -e "Installing zsh..."
    sudo apt-get -y install zsh
else
    echo -e "$(zsh --version) already installed"
fi

# Set zsh as default shell
sudo chsh -s "$(which zsh)"

if ! [ -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    # Install zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

    # Install zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

# Create syslinks
# Using `-f` will override file, if file with same name exists.
ln -s -f "${CODESPACE_DOTFILES}/gitconfig.codespace" ~/.gitconfig
ln -s -f "${CODESPACE_DOTFILES}/zshrc.codespace" ~/.zshrc
ln -s -f "${CODESPACE_DOTFILES}/aliases" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/aliases.zsh"
ln -s -f "${CODESPACE_DOTFILES}/functions" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/functions.zsh"

echo "Setting up starship..."
# ## Starship
# # starship requires a Nerd Font (e.g., Fira Code Nerd Font)
sudo apt-get -y install fonts-firacode
# install starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

ln -fs "${CODESPACE_DOTFILES}/starship.toml" "${HOME}/.config/starship.toml"

echo '🏁 Installed! 🏁'
