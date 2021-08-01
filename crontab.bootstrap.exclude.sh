#!/bin/bash

# Add all the cronjobs listed here to the existing crontab

# TODO: Ensure that you don't add a cron that already exists

. "$( pwd )/utils.exclude.sh"

PROMPT='[ Cron Bootstrapper ]'

crons=(
    # Automatically push the latest in my dotfiles to main
    "0 12 * * MON cd $HOME/dotfiles && git push origin"
    # Remove all directories that have a file called '.autoremove' on the first of every month
    # Primary use case for this is to mark a playground directory for autoremoval
    '0 0 1 * * rm -r $( find $HOME -name '.autoremove' -exec dirname {} \; 2>/dev/null ) 2>/dev/null'
)

add_to_crontab() {
    ## FYI:
    # content in paranthesis executes in a subshell
    # redirection to /dev/null is needed to avoid the "No crontab for user..." error message
    # ref: https://stackoverflow.com/questions/4880290/how-do-i-create-a-crontab-through-a-script
    (crontab -l 2>/dev/null ; echo_crons) | crontab -
}

add_to_crontab

echo_with_prompt "Updated the crontab!"

echo_crons() {
    # The ${myarray{@} syntax expands to all the elements in the array
    for cron in "${crons[@]}" ; do
        echo "$cron"
    done
}
