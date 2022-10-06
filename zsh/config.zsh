export LSCOLORS="Gxfxcxdxbxegedabagacad"
export CLICOLOR=true

fpath=($ZSH/functions $fpath)
autoload -U $ZSH/functions/*(:t)
autoload -U compinit && compinit

# Directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt auto_cd			                            # Don't need to use `cd`
setopt extendedglob                                 # Enable extended globbing
setopt longlistjobs                                 # Display PID when using jobs
setopt nobeep                                       # Never beep

# History
setopt APPEND_HISTORY                               # Adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY             # Adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS                         # Don't record dupes in history
setopt HIST_REDUCE_BLANKS

# Better history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search          # Up
bindkey "^[[B" down-line-or-beginning-search        # Down

# Terminal navigation
bindkey "^[[1;5C" forward-word                      # [Ctrl-right]  - forward one word
bindkey "^[[1;5D" backward-word                     # [Ctrl-left]   - backward one word
bindkey '^[^[[C' forward-word                       # [Ctrl-right]  - forward one word
bindkey '^[^[[D' backward-word                      # [Ctrl-left]   - backward one word
bindkey '^[[1;3D' beginning-of-line                 # [Alt-left]    - beginning of line
bindkey '^[[1;3C' end-of-line                       # [Alt-right]   - end of line
bindkey '^[[5D' beginning-of-line                   # [Alt-left]    - beginning of line
bindkey '^[[5C' end-of-line                         # [Alt-right]   - end of line
bindkey '^?' backward-delete-char                   # [Backspace]   - delete backward
if [[ "${terminfo[kdch1]}" != "" ]]; then
    bindkey "${terminfo[kdch1]}" delete-char        # [Delete]      - delete forward
else
    bindkey "^[[3~" delete-char                     # [Delete]      - delete forward
    bindkey "^[3;5~" delete-char
    bindkey "\e[3~" delete-char
fi
bindkey "^A" vi-beginning-of-line
bindkey -M viins "^F" vi-forward-word               # [Ctrl-f]      - move to next word
bindkey -M viins "^E" vi-add-eol                    # [Ctrl-e]      - move to end of line
bindkey "^J" history-beginning-search-forward
bindkey "^K" history-beginning-search-backward
