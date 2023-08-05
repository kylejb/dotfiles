
# Load helpers
Write-Host "Loading helpers:" -ForegroundColor "Green";
$DotfilesHelpers = Get-ChildItem -Path "${DotfilesHelpersFolder}\*" -Include *.ps1 -Recurse;
foreach ($DotfilesHelper in $DotfilesHelpers) {
  . $DotfilesHelper;
};

foreach($file in Get-Linkables) {
 # TODO: consider symlink files here or rework approach for all systems
}

# TODO: add after WSL2 is installed
# Set-Workspace-Folder-Windows;
# Set-Workspace-Folder-Ubuntu;
