#!/bin/sh -eo

asdf update
asdf plugin update --all

# TODO: only replace latest with latest by plugin

# Update pip
pip3_check=$(pip3 list | grep "available")
[ -z "$pip_check" ] || pip3 install --upgrade pip

# Update npm
npm i -g npm@latest

# Update Ruby & gems
# gem update —-system
# gem update
# gem cleanup
