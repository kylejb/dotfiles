#!/usr/bin/env bash

SCRIPT_NAME=${1:-"install.sh"}

set -x

echo "${SCRIPT_NAME} start: $(date)"

set -e

echo "Updating container dependencies..."
# Update container
sudo apt update
sudo apt upgrade -y

echo "Running installers..."
for helper in $(find . -name "*install-helper.sh"); do
  sh -c "${helper}"
done

echo ''
echo '🏁 Installed! 🏁'
