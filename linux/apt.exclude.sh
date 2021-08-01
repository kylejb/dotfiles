#!/usr/bin/env bash

. "$( pwd )/utils.exclude.sh"

PROMPT='[ APT Bootstrapper ]'

echo_with_prompt "Script assumes it is being run as root."

# Ensures latest packages and security updates are installed
apt update
apt upgrade -y

# Install git
apt install git -y

# Install GNUPG
apt install gnupg -y

# Using NeoVim in VSCode
apt install neovim -y

# Show directory structure with excellent formatting
apt install tree -y

###########################
# zsh setup
###########################
echo -e "⤵ Installing zsh..."
apt install zsh -y
echo -e "✅ Successfully installed zsh version: $(zsh --version)"
# Set up zsh tools
echo -e "⤵ Installing zsh plugins..."
apt install zsh-syntax-highlighting -y
apt install zsh-autosuggestions -y
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
chsh -s $(which zsh) $USER
echo -e "✅ Successfully modified the default shell"
###########################
# end zsh setup
###########################

# Install ohmyzsh plugins
git clone https://github.com/zsh-users/zsh-completions.git $HOME/.oh-my-zsh/custom/plugins/zsh-completions
echo -e "✅ Successfully installed ohmyzsh plugins: zsh-completions"

# Install starship dependencies
# apt install fonts-powerline -y
apt install fonts-firacode -y
# Install starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

# TODO: set up cron task
# Clean cache
apt clean
# TODO: Determine whether to symlink dotfiles or find an alternative approach
echo -e "🎉 Done! 🎉"
