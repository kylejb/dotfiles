# Source this first since it contains the locations of directories needed by funcitons
source "$HOME/.exports"
source "$HOME/.functions"
source "$HOME/.aliases"

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

## Enables local changes – must be last line
[ -f ".zprofile.local" ] && source ".zprofile.local"
