#!/bin/sh

# shellcheck disable=SC1091,SC3046
. "${DOTFILES}/utils.sh"

grab_latest_installed() {
    local plugin_name="${1}"
    asdf list "${plugin_name}" | tail -n 1 | sed 's/*//g' | xargs | tr -d '[:space:]'
}

update_asdf() {
    echo "Updating asdf..."
    asdf update
    asdf plugin update --all
}

update_plugin_package_manager() {
    local plugin_name="${1}"

    case "${plugin_name}" in
    nodejs)
        npm i -g npm@latest
        corepack enable
        ;;
    python)
        pip3_check=$(pip3 list | grep "available")
        [ -z "$pip_check" ] || pip3 install --upgrade pip

        pipx reinstall-all
        ;;
    ruby)
        gem update —-system
        gem update
        gem cleanup
        ;;
    *)
        info "No known dependency managers to update for ${plugin_name}. If this was a bug, please report it: https://github.com/kylejb/dotfiles/issues/new"
        ;;
    esac
}

upsert_latest_plugin() {
    local plugin_name="${1}"

    local latest_version="$(asdf latest $plugin_name)"
    local installed_version="$(grab_latest_installed $plugin_name)"

    echo "[${plugin_name}:${installed_version}] – latest: ${latest_version}"
    if [ "${latest_version}" = "${installed_version}" ]; then
        echo "Latest version (${latest_version}) already installed for ${plugin_name}"
        return
    fi

    echo "Updating ${plugin_name} to ${latest_version}..."
    asdf uninstall "${plugin_name}" "${installed_version}"

    asdf install "${plugin_name}" "${latest_version}"
    asdf global "${plugin_name}" "${latest_version}"
}

upsert_latest_plugins() {
    for plugin in $(asdf plugin list); do
        upsert_latest_plugin $plugin
        update_plugin_package_manager $plugin
    done

    asdf reshim
}

update_asdf
upsert_latest_plugins
