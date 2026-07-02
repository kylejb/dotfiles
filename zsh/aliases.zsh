###############
#   System    #
###############

alias cls='clear'
alias reload!='source ~/.zshrc'

# Postgres (Homebrew data dir; resolved at call time)
if type pg_ctl &>/dev/null; then
    alias pg_start='pg_ctl -D "$(brew --prefix)/var/postgres" start'
    alias pg_stop='pg_ctl -D "$(brew --prefix)/var/postgres" stop'
fi
