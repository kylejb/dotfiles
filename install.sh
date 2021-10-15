#!/usr/bin/env bash
# Dotfile installation entry point for codespaces
# TODO: Refactor for multi-env use.

set -eux

SCRIPT_NAME=${1:-"install.sh"}
DOTFILES=$(cd $(dirname $0) && pwd)

echo -e "${SCRIPT_NAME} start: $(date)"

set +u
if [ $CODESPACES ]; then
  echo -e "Updating container dependencies..."
  /bin/sh $DOTFILES/codespaces/apt.sh
fi
set -u


echo -e "Running installers..."
for helper in $(find . -name "*install-helper.sh"); do
  sh -c "${helper}"
done

## Starship
# starship requires a Nerd Font (e.g., Fira Code Nerd Font)
sudo apt-get -y install fonts-firacode
# install starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

echo -e '🏁 Installed! 🏁'
