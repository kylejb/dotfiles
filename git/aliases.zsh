alias gb='git branch'
alias gc='git commit'
# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'
alias ge='git-edit-new'
alias gl='git pull --prune'
alias gp='git push origin HEAD' # or, alias gp="git push"
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gac='git add -A && git commit -m'
alias gca='git commit -a'
alias gcb='git copy-branch-name'
alias gco='git checkout'

alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
