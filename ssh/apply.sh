#!/bin/sh

set -e

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# shellcheck source=/dev/null
. "${DOTFILES}/utils.sh"

src_dir="${DOTFILES}/ssh"
target_dir="${HOME}/.ssh"

cp "${src_dir}/base-config" "${src_dir}/config"

if is_personal; then
    info "Personal environment detected. Applying ssh configurations for $(get_os)..."
    if is_linux; then
        printf "Include %s/ssh/linux.personal-config\n" "$DOTFILES" | cat - "${src_dir}/config" >tmp_config && mv tmp_config "${src_dir}/config"
    elif is_macos; then
        printf "Include %s/ssh/macos.personal-config\n" "$DOTFILES" | cat - "${src_dir}/config" >tmp_config && mv tmp_config "${src_dir}/config"
    fi
else
    info "No personal profile. Applying default ssh configurations for $(get_os)..."
fi

info "installing to ~/.ssh"
ssh_config="${src_dir}/config"
safe_link "$ssh_config" "${target_dir}/config"
