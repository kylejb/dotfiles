#!/bin/sh -e

echo "Script assumes it is being run as root."

# Ensures latest packages and security updates are installed
sudo apt-get update
sudo apt-get upgrade -y

# Install git
if ! [ -x "$(command -v git)"]; then
    echo "⤵ Installing git..."
    sudo apt-get install git -y
else
    echo "$(git --version) already installed"
fi


# Install GNUPG
if ! [ -x "$(command -v gpg)" ]; then
    echo "⤵ Installing gpg..."
    sudo apt-get install gpg -y
else
    echo "$(gpg --version) already installed"
fi

# Show directory structure with excellent formatting
apt install tree -y

###########################
# zsh setup
###########################
# Install zsh
if ! [ -x "$(command -v zsh)" ]; then
    echo "⤵ Installing zsh..."
    sudo apt-get install zsh -y
else
    echo "$(zsh --version) already installed"
fi
echo "✅ Successfully installed zsh version: $(zsh --version)"
# Set up zsh tools
echo "⤵ Installing zsh plugins..."
sudo apt-get install zsh-syntax-highlighting -y
sudo apt-get install zsh-autosuggestions -y
echo "✅ Successfully installed zsh-autosuggestions, zsh-syntax-highlighting"
# Set the default shell
echo "⤵ Changing the default shell"
chsh -s $(which zsh) $USER
echo "✅ Successfully modified the default shell"
###########################
# end zsh setup
###########################

# Install starship dependencies
echo "⤵ Installing fonts to support starship.rs..."
# apt install fonts-powerline -y
sudo apt-get install fonts-firacode -y
# Install starship
echo "⤵ Installing starship.rs..."
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

# Clean cache
apt clean
echo "🎉 Done! 🎉"
