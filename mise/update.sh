#!/bin/bash

mise self-update -y
mise up

# update Ruby gems
gem update --system
gem update
gem cleanup

# update Node.js package manager
corepack enable
npm i -g npm@latest

# update global Python packages
command -v pipx && pipx reinstall-all
