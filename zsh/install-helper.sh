if ! [ -x "$(command -v zsh)"]; then
    echo -e "Installing zsh..."
    sudo apt-get -y install zsh
else
    echo -e "$(zsh --version) already installed"
fi

# Set zsh as default shell
sudo chsh -s $(which zsh)

if ! [ -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    # Install zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    # Install zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

DOTFILES=$(cd $(dirname $0) && pwd)

# Create syslinks
# Using `-f` will override file, if file with same name exists.
ln -s -f $DOTFILES/.zshrc ~/.zshrc
ln -s -f $DOTFILES/aliases.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/aliases.zsh
ln -s -f $DOTFILES/functions.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/functions.zsh
