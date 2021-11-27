#!/bin/sh
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(command -v brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# TODO: add Brewfile
# if [ -f "${HOME}/.Brewfile" ]; then
# 		log_info "Installing Homebrew packages/casks and apps from the Mac App Store"
# 		brew bundle install --global
# fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# ---------------------------------------------
# Basic Utilities
# ---------------------------------------------

# Core Utils
brew install coreutils

# ---------------------------------------------
# Programming Languages and Frameworks
# ---------------------------------------------

# NodeJS
brew install node

# Python 3
brew install python

# ---------------------------------------------
# Tools I use often
# ---------------------------------------------

# Pipx to manage global Python packages through venv
brew install pipx

# Yarn - an alternative to npm
brew install yarn

# Docker for containerization
brew install docker

# Show directory structure with excellent formatting
brew install tree

# tmux
# brew install tmux

# ---------------------------------------------
# Misc
# ---------------------------------------------

# Zsh
brew install zsh

# The Fire Code font
# https://github.com/tonsky/FiraCode
# This method of installation is
# not officially supported, might install outdated version
# Change font in terminal preferences
brew tap caskroom/fonts
brew cask install font-fira-code

# Remove outdated versions from the cellar
brew cleanup

# The Brewfile handles Homebrew-based app and library installs, but there may
# still be updates and installables in the Mac App Store.
echo "› sudo softwareupdate -i -a"
sudo softwareupdate -i -a

exit 0
