#!/bin/sh

set -e

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# shellcheck source=/dev/null
. "${DOTFILES}/utils.sh"

src_dir="${DOTFILES}/ssh"
target_dir="${HOME}/.ssh"

cp "${src_dir}/base-config" "${src_dir}/config"

if is_work; then
    info "Work environment detected. Applying default ssh configurations for $(get_os)..."
else
    info "Personal environment detected. Applying ssh configurations for $(get_os)..."
    if is_linux; then
        printf "Include %s/ssh/linux.personal-config\n" "$DOTFILES" | cat - "${src_dir}/config" >tmp_config && mv tmp_config "${src_dir}/config"
    elif is_macos; then
        printf "Include %s/ssh/macos.personal-config\n" "$DOTFILES" | cat - "${src_dir}/config" >tmp_config && mv tmp_config "${src_dir}/config"
    fi
fi

info "installing to ~/.ssh"
ssh_config="${src_dir}/config"
safe_link "$ssh_config" "${target_dir}/config"
