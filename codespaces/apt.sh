#!/bin/sh

set -eux

sudo apt-get update
sudo apt-get -y upgrade
rm ~/.zshrc
