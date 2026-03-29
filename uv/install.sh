#!/bin/bash
set -o pipefail

# shellcheck disable=SC1091,SC3046
. "${DOTFILES}/utils.sh"

if ! command_exists uv; then
  echo 'Installing uv'
  curl -LsSf https://astral.sh/uv/install.sh | sh
  command_exists uv || { echo 'Unable to locate uv after installation' 1>&2; exit 1; }
  echo 'Successfully installed uv'
fi

echo 'Installing uv tools'
command_exists pre-commit || uv tool install pre-commit
command_exists ruff || uv tool install ruff
