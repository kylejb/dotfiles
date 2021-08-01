#!/usr/bin/bash

# Ensures latest packages and security updates are installed
sudo apt-get update
sudo apt-get -y upgrade

# Install GNUPG
sudo apt-get -y install gnupg

# Using NeoVim in VSCode
sudo apt-get -y install neovim

###########################
# zsh setup
###########################
echo -e "⤵ Installing zsh..."
sudo apt-get -y install zsh
echo -e "✅ Successfully installed zsh version: $(zsh --version)"
# Set up zsh tools
echo -e "⤵ Installing zsh plugins..."
sudo apt-get -y install zsh-syntax-highlighting
sudo apt-get -y install zsh-autosuggestions
echo -e "✅ Successfully installed zsh-autosuggestions, zsh-syntax-highlighting"
# Install ohmyzsh
PATH_TO_ZSH_DIR=$HOME/.oh-my-zsh
echo -e "Checking if .oh-my-zsh directory exists at $PATH_TO_ZSH_DIR..."
if [ -d $PATH_TO_ZSH_DIR ]
then
   echo -e "\n$PATH_TO_ZSH_DIR directory exists!\nSkipping installation of zsh tools.\n"
else
   echo -e "\n$PATH_TO_ZSH_DIR directory not found."
   echo -e "⤵ Configuring zsh tools in the $HOME directory..."
   (cd $HOME && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended)
   echo -e "✅ Successfully installed zsh tools"
fi
# Set the default shell
echo -e "⤵ Changing the default shell"
sudo chsh -s $(which zsh) $USER
echo -e "✅ Successfully modified the default shell"
###########################
# end zsh setup
###########################

# Install ohmyzsh plugins
git clone https://github.com/zsh-users/zsh-completions.git $HOME/.oh-my-zsh/custom/plugins/zsh-completions
echo -e "✅ Successfully installed ohmyzsh plugins: zsh-completions"

# Install starship dependencies
# sudo apt-get -y install fonts-powerline
sudo apt-get -y install fonts-firacode
# Install starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

# TODO: Determine whether to symlink dotfiles or find an alternative approach
echo -e "🎉 Done! 🎉"