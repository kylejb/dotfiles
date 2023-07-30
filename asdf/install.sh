#!/bin/sh -e

# shellcheck disable=SC1091,SC3046
. utils.sh

set -o pipefail

asdf_plugin_setup() {
	local plugin_name="${1}"
	local plugin_url="${2}"
	local plugin_version="${3}"

	echo "Installing ${plugin_name} via asdf"

	# if nodejs
	# install nodejs deps
	if [[ "${plugin_name}" == 'nodejs' && ! -x "$(command -v gpg)" ]]; then
	    if [[ "$DETECTED_OS" == 'linux-gnu' ]]; then
			sudo apt-get install gpg -y
		elif [[ "$DETECTED_OS" == 'darwin' ]]; then
			brew install gpg
		else
			echo 'Script only supports macOS and Ubuntu'
		fi
	fi

	# if python
	# install python deps
	if [[ "${plugin_name}" == 'python' ]]; then
	    if [[ "$DETECTED_OS" == 'linux-gnu' ]]; then
			sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev \
			libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
			libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
		# TODO: add support for Fedora
		# elif [ -n "fedora" ]; then
		# 	dnf install make gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
		elif [[ "$DETECTED_OS" == 'darwin' ]]; then
			echo "brew install deps"
			# brew install openssl readline sqlite3 xz zlib tcl-tk
		else
			echo 'Script only supports macOS and Ubuntu'
		fi
	fi

	# TODO: fix so a more precise check of output is performed
	asdf plugin add "${plugin_name}" "${plugin_url}" || true
	# status_code=$(asdf plugin add "${plugin_name}")
	# if [ "$status_code" -eq 0 ] || [ "$status_code" -eq 2 ]; then
	#     log_success "asdf plugin ${plugin_name} is installed"
	# else
	#     log_failure_and_exit "asdf plugin add ${plugin_name} encountered an error during operation. Run this command manually to debug the issue."
	# fi

	asdf install "${plugin_name}" "${plugin_version}" || true
	asdf global "${plugin_name}" "$(asdf list "${plugin_name}" | tail -n 1 | xargs echo)"
	echo "Successfully installed ${plugin_name} via asdf"
}

# asdf
if [ -d "${HOME}/.asdf" ]; then
    # success
	echo 'asdf already exists'
else
    # info
	echo 'Installing asdf'
	git clone https://github.com/asdf-vm/asdf.git "${HOME}/.asdf"

	[ -d "${HOME}/.asdf" ] || {
        # failure and exit
		echo 'Could not find .asdf' 1>&2
        exit 1
	}
    # success
	echo 'Successfully installed asdf'
	exit 0
fi

# asdf-plugins if config provided
initial_asdf_plugin_list="${DOTFILES}/asdf/initial-asdf-plugins.txt"
if [ -f "$initial_asdf_plugin_list" ]; then
	installed_nodejs=''
	while read -r p || [ -n "$p" ]; do
		plugin_name="$(cut -d ' ' -f1 <<<"$p")"
		plugin_url="$(cut -d ' ' -f2 <<<"$p")"
		plugin_version="$(cut -d ' ' -f3 <<<"$p")"
		asdf_plugin_setup "$plugin_name" "$plugin_url" "$plugin_version"
		if [ "$plugin_name" = 'nodejs' ]; then
			installed_nodejs='true'
		fi
	done <"$initial_asdf_plugin_list"

	if [ $installed_nodejs = 'true' ]; then
		corepack enable
		asdf reshim
	fi
fi
