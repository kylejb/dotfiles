#!/bin/sh -e

# Ensure latest packages and security updates are installed
sudo apt-get update && sudo apt-get upgrade -y

# Install git
if ! [ -x "$(command -v git)" ]; then
  echo '⤵ Installing git...'
  sudo apt-get install git -y
else
  echo "$(git --version) already installed"
fi

# Install GNUPG
if ! [ -x "$(command -v gpg)" ]; then
  echo '⤵ Installing gpg...'
  sudo apt-get install gpg -y
else
  echo "$(gpg --version) already installed"
fi

# Show directory structure with excellent formatting
sudo apt-get install tree -y

###########################
# zsh setup
###########################
# Install zsh
if ! [ -x "$(command -v zsh)" ]; then
  echo '⤵ Installing zsh...'
  sudo apt-get install zsh -y
else
  echo "$(zsh --version) already installed"
fi
echo '✅ Successfully installed zsh version: $(zsh --version)'
# Set up zsh tools
echo '⤵ Installing zsh plugins...'
sudo apt-get install zsh-syntax-highlighting -y
sudo apt-get install zsh-autosuggestions -y
echo '✅ Successfully installed zsh-autosuggestions, zsh-syntax-highlighting'
# Set the default shell
echo '⤵ Changing the default shell'
chsh -s "$(which zsh)" "${USER}"
echo '✅ Successfully modified the default shell'
###########################
# end zsh setup
###########################

# Install starship dependencies
echo '⤵ Installing fonts to support starship.rs...'
# apt install fonts-powerline -y
sudo apt-get install fonts-firacode -y
# Install starship
echo '⤵ Installing starship.rs...'
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

# Clean cache
sudo apt clean

# TODO: reconcile with WSL.ps1
# Check if WSL2
# if [[ $(uname -r) =~ WSL ]]; then
#   # check for gpg-agent.conf and create if not exists
#   if [ ! -f ~/.gnupg/gpg-agent.conf ]; then
#     if [ ! -d ~/.gnupg ]; then
#       mkdir ~/.gnupg
#     fi
#     touch ~/.gnupg/gpg-agent.conf
#   fi
#   # set pinentry-program to use in gpg-agent.conf
#   echo 'pinentry-program "/mnt/c/Program Files (x86)/GnuPG/bin/pinentry-basic.exe"' >> ~/.gnupg/gpg-agent.conf
#   gpgconf --kill gpg-agent
# fi

# TODO: reconcile approach with 1Pass, YK, and/or other.
# if [ -z "${NO_YUBIKEY}" ]; then
#   # Get name and email from .gitconfig
#   name=$(grep name ~/.gitconfig | awk '{print $3}')
#   email=$(grep email ~/.gitconfig | awk '{print $3}')

#   cat > ~/.gpg.conf <<EOF
#   Key-Type: eddsa
#   Key-Curve: ed25519
#   Key-Usage: sign
#   Subkey-Type: ecdh
#   Subkey-Curve: cv25519
#   Subkey-Usage: encrypt
#   Name-Real: $name
#   Name-Email: $email
#   Expire-Date: 0
#   %commit
# EOF

#   # Generate gpg key
#   gpg --batch --gen-key ~/.gpg.conf
#   rm ~/.gpg.conf

#   # Get gpg key id
#   keyid=$(gpg --list-secret-keys --keyid-format LONG | grep sec | awk '{print $2}' | cut -d '/' -f 2)

#   # Export public key
#   gpg --armor --export $keyid > ~/.gnupg/$keyid.txt
#   pub=$(gpg --armor --export $keyid)

#   # Set key as default in git
#   git config --global user.signingkey $keyid
#   echo 'export GPG_TTY=$(tty)' >> ~/.zshrc

#   # Display public key
#   cat << EOM

#   ######                        START INFO                        ######
#   This is your public key.

#   It is also saved in the following location:

#   ~/.gnupg/$keyid.txt

#   $pub

#   When you are done run 'exec zsh' to reload your zshrc.

#   ######                         END INFO                         ######

# EOM

# fi
