#!/bin/sh
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for XCode Command Line Tools
if test ! "$(xcode-select -p)"; then
  echo "  Installing XCode Command Line Tools for you."
  xcode-select --install
fi

# Check for Homebrew
if test ! "$(command -v brew)"; then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# TODO: consider adding https://github.com/ogham/exa

# Make sure we’re using the latest Homebrew
brew update && brew upgrade

# ---------------------------------------------
# Tools I use often
# ---------------------------------------------

# Open source replacement for Apple's Terminal
brew install --cask iterm2

# Docker for containerization
brew install docker

# Pipx to manage global Python packages through venv
brew install pipx


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
brew install --cask font-fira-code-nerd-font
brew install --cask font-meslo-lg-nerd-font

brew install starship

# Remove outdated versions from the cellar
brew cleanup

# Update macOS Apps
echo "› softwareupdate -i -a"
softwareupdate -i -a

exit 0
