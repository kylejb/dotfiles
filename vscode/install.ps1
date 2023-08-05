function Set-VSCode-Configuration {
  $VSCodeSettingsPath = Join-Path -Path $env:appdata -ChildPath "Code" | Join-Path -ChildPath "User";
  $DotfilesVSCodeSettingsFolder = Join-Path -Path $DotfilesWorkFolder -ChildPath "VSCode";

  if (-not (Test-Path -Path $VSCodeSettingsPath)) {
    Write-Host "Configuring Visual Studio Code:" -ForegroundColor "Green";
    New-Item $VSCodeSettingsPath -ItemType directory;
  }

  Get-ChildItem -Path "${DotfilesVSCodeSettingsFolder}\*" -Include "*.json" -Recurse | Copy-Item -Destination $VSCodeSettingsPath;
}

# TODO: replace with Winget
choco install -y "vscode" --params "/NoDesktopIcon /NoQuicklaunchIcon /NoContextMenuFiles /NoContextMenuFolders";
Set-VSCode-Configuration;
refreshenv;
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
code --install-extension "ms-vscode.powershell";
code --install-extension "ms-vscode-remote.remote-containers";
code --install-extension "ms-vscode-remote.remote-wsl";
code --install-extension "prisma.prisma";
code --install-extension "rangav.vscode-thunder-client";
code --install-extension "svelte.svelte-vscode";
