# TODO: Add script to prompt user for github email address and password

DOTFILES=$(cd $(dirname $0) && pwd)

# Create syslinks
# Using `-f` will override file, if file with same name exists.
ln -s -f $DOTFILES/.gitconfig ~/.gitconfig
