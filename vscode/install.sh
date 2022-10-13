install_extensions() {
    code --install-extension "aaron-bond.better-comments";
    code --install-extension "christian-kohler.path-intellisense";
    code --install-extension "dbaeumer.vscode-eslint";
    code --install-extension "eamodio.gitlens";
    code --install-extension "esbenp.prettier-vscode";
    code --install-extension "golang.go";
    code --install-extension "gruntfuggly.todo-tree";
    code --install-extension "jasonlhy.hungry-delete";
    code --install-extension "mhutchie.git-graph";
    code --install-extension "ms-python.python";
    code --install-extension "ms-python.vscode-pylance";
    code --install-extension "ms-toolsai.jupyter";
    code --install-extension "ms-vscode-remote.remote-containers";
    code --install-extension "prisma.prisma";
    code --install-extension "rangav.vscode-thunder-client";
    code --install-extension "svelte.svelte-vscode";
}

# TODO: verify file/folder goes to right place based on OS
if [ $( echo "$OSTYPE" | grep 'darwin' ) ] ; then

    echo "Setting up VSCode. This may take a while..."

    # Set up symlinks for settings, snippets, and keybindings
    for file in $( ls -A $PWD/vscode | grep --include -r -E '\.json|snippets') ; do
        ln -sv "$PWD/$file" "$HOME/Library/Application\ Support/Code/User/"
    done

    # TODO: test and refactor
    install_extensions
else
    echo "Skipping VSCode setup because macOS was not detected..."
fi
