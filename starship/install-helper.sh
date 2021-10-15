DOTFILES=$(cd $(dirname $0) && pwd)

# Create syslinks
# Using `-f` will override file, if file with same name exists.
ln -s -f $DOTFILES/starship.toml $HOME/.config/starship.toml
