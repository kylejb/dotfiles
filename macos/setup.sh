#!/bin/sh
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! "$(command -v brew)"; then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# TODO: add Brewfile
# if [ -f "${HOME}/.Brewfile" ]; then
# 		log_info "Installing Homebrew packages/casks and apps from the Mac App Store"
# 		brew bundle install --global
# fi

# TODO: consider adding https://github.com/ogham/exa

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# ---------------------------------------------
# Basic Utilities
# ---------------------------------------------

# Core Utils
# brew install coreutils

# ---------------------------------------------
# Tools I use often
# ---------------------------------------------

# Pipx to manage global Python packages through venv
brew install pipx

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

# Install Nerd Fonts for IDE
brew tap homebrew/cask-fonts
brew install font-fira-code-nerd-font
brew install font-meslo-lg-nerd-font

brew install starship

# Remove outdated versions from the cellar
brew cleanup

# The Brewfile handles Homebrew-based app and library installs, but there may
# still be updates and installables in the Mac App Store.
echo "› sudo softwareupdate -i -a"
sudo softwareupdate -i -a

exit 0
