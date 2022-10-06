###############
#   System    #
###############

alias cls='clear'
alias l='ls -lah'
alias reload!='source ~/.zshrc'

# Postgres
alias pg_start="pg_ctl -D /usr/local/var/postgres start"
alias pg_stop="pg_ctl -D /usr/local/var/postgres stop"

# MongoDB
alias mongod_start="mongod --config /usr/local/etc/mongod.conf --fork"
