#!/bin/bash

. "$( pwd )/utils.exclude.sh"

PROMPT='[ Bootstrap ]'

source .exports

init () {
    echo_with_prompt "Making a Projects folder in $PATH_TO_PROJECTS if it doesn't already exist"
	mkdir -p "$PATH_TO_PROJECTS"
	echo_with_prompt "Making a Playground folder in $PATH_TO_PLAYGROUND if it doesn't already exist"
	mkdir -p "$PATH_TO_PLAYGROUND"
	echo_with_prompt "Making a Playground folder in $PATH_TO_JOURNAL if it doesn't already exist"
	mkdir -p "$PATH_TO_JOURNAL"
}

# TODO: Delete symlinks to deleted files

link () {
    for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|\.gitmodules|.*.md' ) ; do
        # Silently ignore errors here because the files may already exist
        ln -sv "$PWD/$file" "$HOME" || true
    done
}

# TODO: Rewrite this to check for os=unknown, use the execute_func_with_prompt wrapper, etc
install_tools () {
  local os=$(get_os)
	if [ "$os" = 'darwin' ] ; then
    echo_with_prompt "Detected OS macOS"
		echo_with_prompt "This utility will install useful utilities using Homebrew"
		echo_with_prompt "Proceed? (y/n)"
		read resp
		# TODO: Add regex here?
		if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
			echo_with_prompt "Installing useful stuff using brew. This may take a while..."
			sh macOS/homebrew.exclude.sh
		else
			echo_with_prompt "Brew installation cancelled by user"
		fi
	else
		echo_with_prompt "Skipping installations using Homebrew because MacOS was not detected..."
	fi

	if [ "$os" = 'debian' ] ; then
    echo_with_prompt "Detected OS $os"
		echo_with_prompt "This utility will install useful utilities using apt (this has been tested on Debian buster)"
		echo_with_prompt "Proceed? (y/n)"
		read resp
		# TODO - regex here?
		if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
			echo_with_prompt "Installing useful stuff using apt. This may take a while..."
			sh Linux/apt.exclude.sh
		else
			echo_with_prompt "Apt installation cancelled by user"
		fi
	else
		echo_with_prompt "Skipping installations using apt because Debian/Linux was not detected..."
	fi
}

bootstrap_vim() {
    # TODO: Consider sourcing this file
  " $( pwd )/vim.bootstrap.exclude.sh"
}

bootstrap_crontab() {
    # TODO: Consider sourcing this file
    "$( pwd )/crontab.bootstrap.exclude.sh"
}

# TODO: Improve bootstrap process
init
execute_func_with_prompt link "symlink everything"
install_tools
# execute_func_with_prompt bootstrap_vim "bootstrap vim with plugins and the like"
# execute_func_with_prompt bootstrap_crontab "bootstrap the crontab"

# Hack to make sure this script always exits successfully
true
