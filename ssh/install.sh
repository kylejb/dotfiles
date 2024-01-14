#!/usr/bin/env bash

set -e

# shellcheck source=/dev/null
. "${DOTFILES}/utils.sh"

src_dir="${DOTFILES}/ssh"
target_dir="${HOME}/.ssh"

cp "${src_dir}/base-config" "${src_dir}/config"

DETECTED_OS="$(get_os)"

case $(hostname) in
W-*)
    info "Work environment detected. Applying ssh configurations for ${DETECTED_OS}..."
    if [[ "$DETECTED_OS" == 'linux-gnu' ]]; then
        # shellcheck disable=SC2016,SC2028
        echo 'Include $DOTFILES/ssh/linux.base-config\n' | cat - "${src_dir}/config" >tmp_config && mv tmp_config "${src_dir}/config"
    elif [[ "$DETECTED_OS" == 'darwin' ]]; then
        # shellcheck disable=SC2016,SC2028
        echo 'Include $DOTFILES/ssh/macos.base-config\n' | cat - "${src_dir}/config" >tmp_config && mv tmp_config "${src_dir}/config"
    fi
    ;;
*)
    info "Applying default ssh configurations..."
    ;;
esac

info "installing to ~/.ssh"
ssh_config="${src_dir}/config"
target="${target_dir}/config"
if [ -e "$target" ]; then
    # shellcheck disable=SC2295
    info "~${target#$HOME} already exists... Skipping."
else
    info "Creating symlink for $ssh_config"
    ln -s "$ssh_config" "$target"
fi
