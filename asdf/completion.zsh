# Make asdf completions available in zsh. Assumes
# completion script is installed at path below.
if type asdf &>/dev/null; then
    export FPATH="${ASDF_DIR}/completions:${FPATH}"
fi
