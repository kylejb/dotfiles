Write-Host "Welcome to Dotfiles for Microsoft Windows 11" -ForegroundColor "Yellow";
Write-Host "Please don't use your device while the script is running." -ForegroundColor "Yellow";

$GitHubRepositoryAuthor = "kylejb";
$GitHubRepositoryName = "dotfiles";
$DotfilesFolder = Join-Path -Path $HOME -ChildPath ".dotfiles";
$DotfilesHelpersFolder = Join-Path -Path $DotfilesWorkFolder -ChildPath "Helpers";
# TODO: remove?
$DotfilesWorkFolder = Join-Path -Path $DotfilesFolder -ChildPath "${GitHubRepositoryName}-main" | Join-Path -ChildPath "src";
$DotfilesConfigFile = Join-Path -Path $DotfilesFolder -ChildPath "${GitHubRepositoryName}-main" | Join-Path -ChildPath "config.json";
# end

# Load helpers
Write-Host "Loading helpers:" -ForegroundColor "Green";
$DotfilesHelpers = Get-ChildItem -Path "${DotfilesHelpersFolder}\*" -Include *.ps1 -Recurse;
foreach ($DotfilesHelper in $DotfilesHelpers) {
  . $DotfilesHelper;
};

# Save user configuration in persistence
Set-Configuration-File -DotfilesConfigFile $DotfilesConfigFile -ComputerName $ComputerName -GitUserName $GitUserName -GitUserEmail $GitUserEmail -WorkspaceDisk $WorkspaceDisk;

# Load user configuration from persistence
$Config = Get-Configuration-File -DotfilesConfigFile $DotfilesConfigFile;

# Set alias for HKEY_CLASSES_ROOT
Set-PSDrive-HKCR;

# Register the script to start after reboot
# Register-DotfilesScript-As-RunOnce;

# Run scripts
# Invoke-Expression (Join-Path -Path $DotfilesWorkFolder -ChildPath "windows" | Join-Path -ChildPath "Chocolatey.ps1");
Invoke-Expression (Join-Path -Path $DotfilesWorkFolder -ChildPath "git" | Join-Path -ChildPath "Git.ps1");
Invoke-Expression (Join-Path -Path $DotfilesWorkFolder -ChildPath "vscode" | Join-Path -ChildPath "VSCode.ps1");
Invoke-Expression (Join-Path -Path $DotfilesWorkFolder -ChildPath "windows" | Join-Path -ChildPath "WindowsTerminal" | Join-Path -ChildPath "WindowsTerminal.ps1");
Invoke-Expression (Join-Path -Path $DotfilesWorkFolder -ChildPath "linux" | Join-Path -ChildPath "WSL.ps1");
Invoke-Expression (Join-Path -Path $DotfilesWorkFolder -ChildPath "docker" | Join-Path -ChildPath "Docker.ps1");
Invoke-Expression (Join-Path -Path $DotfilesWorkFolder -ChildPath "windows" | Join-Path -ChildPath "Workspace.ps1");
Invoke-Expression (Join-Path -Path $DotfilesWorkFolder -ChildPath "windows" | Join-Path -ChildPath "SystemSettings.ps1");

# Clean
# Unregister script from RunOnce
# Remove-DotfilesScript-From-RunOnce;

Write-Host "Deleting Desktop shortcuts:" -ForegroundColor "Green";
Remove-Desktop-Shortcuts;

Write-Host "Cleaning Dotfiles workspace:" -ForegroundColor "Green";
Remove-Item $DotfilesFolder -Recurse -Force -ErrorAction SilentlyContinue;

Write-Host "The process has finished." -ForegroundColor "Yellow";

Write-Host "Restarting the PC in 10 seconds..." -ForegroundColor "Green";
Start-Sleep -Seconds 10;
Restart-Computer;
