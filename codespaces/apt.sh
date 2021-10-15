#!/bin/sh

set -eux

sudo apt-get -u update
sudo apt-get -y install zsh

rm ~/.zshrc
