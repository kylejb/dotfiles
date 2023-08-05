# Make Homebrew’s completions available in zsh.
if type brew &>/dev/null; then
    export FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
