function Update-Ubuntu-Packages-Repository {
  Write-Host "Updating Ubuntu package repository:" -ForegroundColor "Green";
  wsl sudo apt --yes update;
}

function Update-Ubuntu-Packages {
  Write-Host "Upgrading Ubuntu packages:" -ForegroundColor "Green";
  wsl sudo apt --yes upgrade;
}

function Install-Ubuntu-Package {
  [CmdletBinding()]
  param(
    [Parameter(Position = 0, Mandatory = $TRUE)]
    [string]
    $PackageName
  )

  Write-Host "Installing ${PackageName} in Ubuntu:" -ForegroundColor "Green";
  wsl sudo apt install --yes --no-install-recommends $PackageName;
}

function Set-Git-Configuration-In-Ubuntu {
  Write-Host "Configuring Git in Ubuntu:" -ForegroundColor "Green";
  wsl git config --global init.defaultBranch "main";
  wsl git config --global user.name $Config.GitUserName;
  wsl git config --global user.email $Config.GitUserEmail;
  wsl git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe";
  wsl git config --list;
  Write-Host "Git was successfully configured in Ubuntu." -ForegroundColor "Green";
}

function Install-VSCode-Extensions-In-WSL {
  Write-Host "Installing Visual Studio Code extensions in WSL:" -ForegroundColor "Green";

  wsl code --install-extension aaron-bond.better-comments;
  wsl code --install-extension christian-kohler.path-intellisense;
  wsl code --install-extension dbaeumer.vscode-eslint;
  wsl code --install-extension eamodio.gitlens;
  wsl code --install-extension esbenp.prettier-vscode;
  wsl code --install-extension golang.go;
  wsl code --install-extension gruntfuggly.todo-tree;
  wsl code --install-extension jasonlhy.hungry-delete;
  wsl code --install-extension mhutchie.git-graph;
  wsl code --install-extension ms-python.python;
  wsl code --install-extension ms-python.vscode-pylance;
  wsl code --install-extension ms-toolsai.jupyter;
  wsl code --install-extension ms-vscode.powershell;
  wsl code --install-extension ms-vscode-remote.remote-containers;
  wsl code --install-extension ms-vscode-remote.remote-wsl;
  wsl code --install-extension prisma.prisma;
  wsl code --install-extension rangav.vscode-thunder-client;
  wsl code --install-extension svelte.svelte-vscode;
}

function Install-Asdf-In-Ubuntu {
  $AsdfWslPath = "~/.asdf"

  Write-Host "Installing asdf in Ubuntu:" -ForegroundColor "Green";

  wsl git clone https://github.com/asdf-vm/asdf.git $AsdfWslPath --branch v0.11.3;
}

# TODO: replace with asdf/install.sh
function Install-Asdf-Plugins-In-Ubuntu {
  Write-Host "Installing Go (latest) in Ubuntu:" -ForegroundColor "Green";
  wsl ~/.asdf/bin/asdf plugin add golang;
  wsl ~/.asdf/bin/asdf install golang latest;
  wsl ~/.asdf/bin/asdf global golang latest;

  Write-Host "Installing Node.js (latest) in Ubuntu:" -ForegroundColor "Green";
  wsl ~/.asdf/bin/asdf plugin add nodejs;
  wsl ~/.asdf/bin/asdf install nodejs latest;
  wsl ~/.asdf/bin/asdf global nodejs latest;

  Write-Host "Installing python (latest) in Ubuntu:" -ForegroundColor "Green";
  wsl ~/.asdf/bin/asdf plugin add python;
  wsl ~/.asdf/bin/asdf install python latest;
  wsl ~/.asdf/bin/asdf global python latest;

  Write-Host "Installing ruby (latest) in Ubuntu:" -ForegroundColor "Green";
  wsl ~/.asdf/bin/asdf plugin add ruby;
  wsl ~/.asdf/bin/asdf install ruby latest;
  wsl ~/.asdf/bin/asdf global ruby latest;

  Write-Host "Installing rust (latest) in Ubuntu:" -ForegroundColor "Green";
  wsl ~/.asdf/bin/asdf plugin add rust;
  wsl ~/.asdf/bin/asdf install rust latest;
  wsl ~/.asdf/bin/asdf global rust latest;
}

function Install-OhMyZsh-In-Ubuntu {
  $DotfilesOhMyZshInstallerPath = Join-Path -Path $DotfilesWorkFolder -ChildPath "WSL" | Join-Path -ChildPath "ohmyzsh.sh";

  Invoke-WebRequest -o $DotfilesOhMyZshInstallerPath https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh;

  $WslOhMyZshInstallerPath = wsl wslpath $DotfilesOhMyZshInstallerPath.Replace("\", "\\");

  Write-Host "Installing Oh My Zsh in Ubuntu:" -ForegroundColor "Green";

  wsl bash $WslOhMyZshInstallerPath --unattended;
}

function Install-Zsh-Autosuggestions {
  $ZshAutosuggestionsWslPath = "~/.oh-my-zsh/custom/plugins/zsh-autosuggestions";

  Write-Host "Installing Zsh-Autosuggestions in Ubuntu:" -ForegroundColor "Green";

  wsl rm -rf $ZshAutosuggestionsWslPath;

  wsl git clone https://github.com/zsh-users/zsh-autosuggestions $ZshAutosuggestionsWslPath;
}

function Install-OhMyZsh-Theme-In-Ubuntu {
  $DotfilesOhMyZshThemePath = Join-Path -Path $DotfilesWorkFolder -ChildPath "WSL" | Join-Path -ChildPath "paradox.zsh-theme";
  $WslOhMyZshThemePath = wsl wslpath $DotfilesOhMyZshThemePath.Replace("\", "\\");

  Write-Host "Installing Paradox theme for Oh My Zsh in Ubuntu:" -ForegroundColor "Green";

  wsl cp -R $WslOhMyZshThemePath ~/.oh-my-zsh/custom/themes;
}

function Install-OhMyZsh-Functions-In-Ubuntu {
  $DotfilesOhMyZshFunctionsPath = Join-Path -Path $DotfilesWorkFolder -ChildPath "WSL" | Join-Path -ChildPath "custom-actions.sh";
  $WslOhMyZshFunctionsPath = wsl wslpath $DotfilesOhMyZshFunctionsPath.Replace("\", "\\");

  Write-Host "Installing custom alias and functions for Oh My Zsh in Ubuntu:" -ForegroundColor "Green";

  wsl mkdir -p ~/.oh-my-zsh/custom/functions;

  wsl cp -R $WslOhMyZshFunctionsPath ~/.oh-my-zsh/custom/functions;
}

function Set-OhMyZsh-Configuration-In-Ubuntu {
  # TODO: update zsh folder to be compatabile with WSL2 and fix pathing
  $DotfilesZshrcPath = Join-Path -Path $DotfilesWorkFolder -ChildPath "WSL" | Join-Path -ChildPath ".zshrc";
  $WslZshrcPath = wsl wslpath $DotfilesZshrcPath.Replace("\", "\\");

  Write-Host "Configuring Zsh in Ubuntu:" -ForegroundColor "Green";

  wsl cp -R $WslZshrcPath ~;
}

function Set-Zsh-As-Default-In-Ubuntu {
  Write-Host "Changing default shell to Zsh in Ubuntu:" -ForegroundColor "Green";

  $WslZshPath = wsl which zsh;
  wsl sudo chsh -s $WslZshPath;

  # Change just for a user: sudo chsh -s $WslZshPath $USER_NAME;
}

# TODO: replace with Winget
choco install -y "wsl2" --params "/Version:2 /Retry:true";
choco install -y "wsl-ubuntu-2004" --params "/InstallRoot:true" --execution-timeout 3600;

Update-Ubuntu-Packages-Repository;
Update-Ubuntu-Packages;

Install-Ubuntu-Package -PackageName "curl";
Install-Ubuntu-Package -PackageName "git";
Install-Ubuntu-Package -PackageName "zsh";
Install-Ubuntu-Package -PackageName "make";
Install-Ubuntu-Package -PackageName "g++";
Install-Ubuntu-Package -PackageName "gcc";

Set-Git-Configuration-In-Ubuntu;

Install-VSCode-Extensions-In-WSL;

Install-Asdf-In-Ubuntu;
Install-Asdf-Plugins-In-Ubuntu

Install-OhMyZsh-In-Ubuntu;
Install-OhMyZsh-Theme-In-Ubuntu;
Install-OhMyZsh-Functions-In-Ubuntu;
Set-OhMyZsh-Configuration-In-Ubuntu;
Set-Zsh-As-Default-In-Ubuntu;
