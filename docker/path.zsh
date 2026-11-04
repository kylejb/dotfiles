# Docker Desktop CLI tools, when installed per-user.
if [ -d "$HOME/.docker/bin" ]; then
    export PATH="$PATH:$HOME/.docker/bin"
fi
