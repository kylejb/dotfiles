if ! [ -x "$(command -v zsh)"]; then
    echo "Installing zsh..."
    # assumes CODESPACE=true
    sudo apt install zsh -y
else
    echo "$(zsh --version) already installed"
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

# Syslink `.zshrc` on codespace's home folder
# if `~/.zshrc`, the `-f` flag will replace existing file with new syslink
ln -s -f zsh/.zshrc ~/.zshrc

#? move or syslink?
# Syslink aliases and functions
ln -s -f zsh/aliases.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/aliases.zsh
ln -s -f zsh/functions.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/functions.zsh
