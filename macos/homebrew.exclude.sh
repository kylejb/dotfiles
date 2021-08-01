#!/bin/sh
#
# Homebrew (macOS only)
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

. "$( pwd )/utils.exclude.sh"

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you..."
  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
  	echo_with_prompt "Something went wrong. Are you not on MacOS? Exiting..." && exit 1
fi

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
