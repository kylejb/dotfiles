#!/bin/sh -e

# shellcheck disable=SC1091,SC3046
. utils.sh

src_dir="${DOTFILES:-$HOME/.dotfiles}/ssh"
target_dir="${HOME}/.ssh"

cp "${src_dir}/base-config" "${src_dir}/config"

DETECTED_OS="$(get_os)"

case $(hostname) in
W-*)
    info "Work environment detected. Applying ssh configurations for ${DETECTED_OS}..."
    if [[ "$DETECTED_OS" == 'linux-gnu' ]]; then
        echo 'Include $DOTFILES/ssh/linux.base-config\n' | cat - "${src_dir}/config" >tmp_config && mv tmp_config "${src_dir}/config"
    elif [[ "$DETECTED_OS" == 'darwin' ]]; then
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
    info "~${target#$HOME} already exists... Skipping."
else
    info "Creating symlink for $ssh_config"
    ln -s "$ssh_config" "$target"
fi
