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

brew install --cask iterm2
brew install --cask visual-studio-code

brew install docker
brew install pipx
brew install starship
# brew install tmux
brew install tree
brew install zsh

# ---------------------------------------------
# Misc
# ---------------------------------------------

# Nerd Fonts for IDEs
brew install --cask font-fira-code-nerd-font
brew install --cask font-meslo-lg-nerd-font

# Remove outdated versions from the cellar
brew cleanup

# Update macOS Apps
echo "› softwareupdate -i -a"
softwareupdate -i -a

exit 0
