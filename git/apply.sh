#!/bin/sh
# Render the per-machine git config (identity + commit signing) by profile.
#
# config/git is dir-linked to ~/.config/git, so this writes the file that
# config/git/config already includes (~/.config/git/config.local). The file is
# the user-owned per-machine escape hatch: it is created once and never
# overwritten — hand edits always win. Delete it and re-run `dot -a` to
# regenerate.
#
# set -e here (not just the shebang) so fail-fast holds when run as
# `sh apply.sh`, which ignores shebang flags.
set -e

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# shellcheck source=/dev/null
. "${DOTFILES}/utils.sh"

target="${DOTFILES}/config/git/config.local"

if [ -e "$target" ]; then
    info "config/git/config.local exists — not overwriting (delete it and re-run dot -a to regenerate)"
    exit 0
fi

if is_personal; then
    if is_macos; then
        op_sign='/Applications/1Password.app/Contents/MacOS/op-ssh-sign'
    else
        op_sign='/opt/1Password/op-ssh-sign'
    fi

    cat >"$target" <<EOF
[user]
  name = Kyle J. Burda
  email = 47502769+kylejb@users.noreply.github.com
  signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRTdve9JQMSdN66HIQ76D0RrTswAfiC0JrR/cKJ4xqf
[github]
  user = kylejb
[commit]
  gpgsign = true
[gpg]
  format = ssh
[gpg "ssh"]
  program = "${op_sign}"
EOF
    info "rendered personal git identity + 1Password ssh signing into config/git/config.local"
else
    # Work machines cannot use 1Password: no op-ssh-sign, no op:// references.
    # Signing stays off until a local key is configured by hand.
    cat >"$target" <<'EOF'
[user]
  name = Kyle J. Burda
  useConfigOnly = true
  # TODO: set your work email
  # email = work-email@example.com
  # To sign with a local key instead of 1Password:
  # signingkey = ~/.ssh/id_ed25519.pub
[commit]
  gpgsign = false
EOF
    warn "rendered work git config stub into config/git/config.local — edit it to set your work email"
fi
