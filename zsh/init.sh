#!/usr/bin/env zsh

###############
# Initialize  #
###############

# Protect against non-zsh execution
[ -n "$ZSH_VERSION" ] || {
  printf "Cannot load dotfiles in non-zsh environment."
  return 1
}

# If DOTFILES is not defined, use the current script's directory.
[[ -z "$DOTFILES" ]] && export DOTFILES="${${(%):-%x}:a:h}"

###############
#     ZSH     #
###############

if [[ "$OSTYPE" == (darwin|freebsd)* ]]; then
  # this is a good alias, it works by default just using $LSCOLORS
  ls -l . &>/dev/null && alias ll='ls -l'
  ls -G . &>/dev/null && alias ls='ls -G'
  ls -A . &>/dev/null && alias la='ls -A'
  ls -lAh . &>/dev/null && alias l='ls -lAh'

  # only use coreutils ls if there is a dircolors customization present ($LS_COLORS or .dircolors file)
  # otherwise, gls will use the default color scheme which is ugly af
  if $(gls &>/dev/null); then
    [[ -n "$LS_COLORS" || -f "$HOME/.dircolors" ]] && gls --color -d . &>/dev/null && alias ls='gls -F --color=tty'
    [[ -n "$LS_COLORS" || -f "$HOME/.dircolors" ]] && gls --color -d . &>/dev/null && alias l='gls -lAh --color=tty'
    [[ -n "$LS_COLORS" || -f "$HOME/.dircolors" ]] && gls --color -d . &>/dev/null && alias ll='gls -l --color=tty'
    [[ -n "$LS_COLORS" || -f "$HOME/.dircolors" ]] && gls --color -d . &>/dev/null && alias la='gls -A --color=tty'
  fi
fi

# enable diff color if possible.
if command diff --color . . &>/dev/null; then
  alias diff='diff --color'
fi

# all of our zsh files
typeset -U config_files
config_files=($DOTFILES/**/*.zsh)

# load the path files
for path_file in ${(M)config_files:#*/path.zsh}
do
  source $path_file
done

# load everything but path and completion files
for file in ${${config_files:#*/completion.zsh:#*/path.zsh}}
do
  source $file
done

# load every completion after autocomplete loads
for completion_file in ${(M)config_files:#*/completion.zsh}
do
  source $completion_file
done

autoload -Uz compinit
compinit
# autoload -U compaudit compinit zrecompile

# load plugins
export ZPLUGDIR="$XDG_CACHE_HOME/zsh/plugins"
[[ -d "$ZPLUGDIR" ]] || mkdir -p "$ZPLUGDIR"
# array containing plugin information (managed by zfetch)
typeset -A plugins

zfetch zsh-users/zsh-autosuggestions
zfetch zsh-users/zsh-history-substring-search
zfetch zsh-users/zsh-syntax-highlighting # must be last
