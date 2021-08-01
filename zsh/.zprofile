## A handy function to open your zprofile from any directory
function zp {
  $EDITOR ~/.dotfiles/.zprofile
}

## Environment Variables
## =====================
  ## Library Paths
  ## These variables tell your shell where they can find certain
  ## required libraries so other programs can reliably call the variable name
  ## instead of a hardcoded path.
  export GPG_TTY=$(tty)

  ## Configurations
    ## GIT_MERGE_AUTO_EDIT
    ## This variable configures git to not require a message when you merge.
    export GIT_MERGE_AUTOEDIT='no'

## Editors
  ## Tells your shell that when a program requires various editors, use VSCode.
  export EDITOR="code"
  export GIT_EDITOR="code --w"

## Helpful Functions
## =====================

## A function to CD into the desktop from anywhere
## so you just type desktop.
function desktop {
  cd /Users/$USER/Desktop/$@
}
## A function to easily grep for a matching process
## USE: psg postgres
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

## A function to extract correctly any archive based on extension
## USE: extract imazip.zip
##      extract imatar.tar
# function extract () {
#     if [ -f $1 ] ; then
#         case $1 in
#             *.tar.bz2)  tar xjf $1      ;;
#             *.tar.gz)   tar xzf $1      ;;
#             *.bz2)      bunzip2 $1      ;;
#             *.rar)      rar x $1        ;;
#             *.gz)       gunzip $1       ;;
#             *.tar)      tar xf $1       ;;
#             *.tbz2)     tar xjf $1      ;;
#             *.tgz)      tar xzf $1      ;;
#             *.zip)      unzip $1        ;;
#             *.Z)        uncompress $1   ;;
#             *)          echo "'$1' cannot be extracted via extract()" ;;
#         esac
#     else
#         echo "'$1' is not a valid file"
#     fi
# }

# Aliases
# =====================
  # LS
  alias l='ls -lah'

  ## Git
  # alias gcl="git clone"
  # alias gst="git status"
  # alias gl="git pull"
  # alias gp="git push"
  # alias gd="git diff | subl"
  # alias gc="git commit -v"
  # alias gca="git commit -v -a"
  # alias gb="git branch"
  # alias gba="git branch -a"
  # alias gcam="git commit -am"
  # alias gbb="git branch -b"

  ## Postgres
  alias pg_start="pg_ctl -D /usr/local/var/postgres start"
  alias pg_stop="pg_ctl -D /usr/local/var/postgres stop"

  alias mongod_start="mongod --config /usr/local/etc/mongod.conf --fork"

## Postgres
# export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH


## Final Configurations and Plugins
## =====================
  # Git Bash Completion
  # Will activate bash git completion if installed
  # via homebrew
  # if [ -f `brew --prefix`/etc/bash_completion ]; then
  #   . `brew --prefix`/etc/bash_completion
  # fi
