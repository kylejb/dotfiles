#!/bin/bash

# Update and install basic packages
sudo apt update -y && sudo apt upgrade -y

# Check if WSL2
if [[ $(uname -r) =~ WSL ]]; then
  # check for gpg-agent.conf and create if not exists
  if [ ! -f ~/.gnupg/gpg-agent.conf ]; then
    if [ ! -d ~/.gnupg ]; then
      mkdir ~/.gnupg
    fi
    touch ~/.gnupg/gpg-agent.conf
  fi
  # set pinentry-program to use in gpg-agent.conf
  echo 'pinentry-program "/mnt/c/Program Files (x86)/GnuPG/bin/pinentry-basic.exe"' >> ~/.gnupg/gpg-agent.conf
  gpgconf --kill gpg-agent
fi

# Get name and email from .gitconfig
name=$(grep name ~/.gitconfig | awk '{print $3}')
email=$(grep email ~/.gitconfig | awk '{print $3}')

cat > ~/.gpg.conf <<EOF
Key-Type: eddsa
Key-Curve: ed25519
Key-Usage: sign
Subkey-Type: ecdh
Subkey-Curve: cv25519
Subkey-Usage: encrypt
Name-Real: $name
Name-Email: $email
Expire-Date: 0
%commit
EOF

# Generate gpg key
gpg --batch --gen-key ~/.gpg.conf
rm ~/.gpg.conf

# Get gpg key id
keyid=$(gpg --list-secret-keys --keyid-format LONG | grep sec | awk '{print $2}' | cut -d '/' -f 2)

# Export public key
gpg --armor --export $keyid > ~/.gnupg/$keyid.txt
pub=$(gpg --armor --export $keyid)

# Set key as default in git
git config --global user.signingkey $keyid
echo 'export GPG_TTY=$(tty)' >> ~/.bashrc

# Display public key
cat << EOM

######                        START INFO                        ######
This is your public key.

It is also saved in the following location:

~/.gnupg/$keyid.txt

$pub

When you are done run 'exec bash' to reload your bashrc.

######                         END INFO                         ######

EOM
