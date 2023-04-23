$GitHubRepositoryUri = "https://github.com/${GitHubRepositoryAuthor}/${GitHubRepositoryName}/archive/refs/heads/main.zip";

$DotfilesFolder = Join-Path -Path $HOME -ChildPath ".dotfiles";
$ZipRepositoryFile = Join-Path -Path $DotfilesFolder -ChildPath "${GitHubRepositoryName}-main.zip";
$DotfilesWorkFolder = Join-Path -Path $DotfilesFolder -ChildPath "${GitHubRepositoryName}-main"

$DownloadResult = $FALSE;

# Request custom values
$ComputerName = Read-Host -Prompt "Input the new computer name here";
$GitUserName = Read-Host -Prompt "Input your Git user name here";
$GitUserEmail = Read-Host -Prompt "Input your Git user email here";

$ValidDisks = Get-PSDrive -PSProvider "FileSystem" | Select-Object -ExpandProperty "Root";
do {
  Write-Host "Choose the location of your development workspace:" -ForegroundColor "Green";
  Write-Host $ValidDisks -ForegroundColor "Green";
  $WorkspaceDisk = Read-Host -Prompt "Please choose one of the available disks";
}
while (-not ($ValidDisks -Contains $WorkspaceDisk));

# Create Dotfiles folder
if (Test-Path $DotfilesFolder) {
  Remove-Item -Path $DotfilesFolder -Recurse -Force;
}
New-Item $DotfilesFolder -ItemType directory;

# Download Dotfiles repository as Zip
Try {
  Invoke-WebRequest $GitHubRepositoryUri -O $ZipRepositoryFile;
  $DownloadResult = $TRUE;
}
catch [System.Net.WebException] {
  Write-Host "Error connecting to GitHub, check the internet connection or the repository url." -ForegroundColor "Red";
}

if ($DownloadResult) {
  Add-Type -AssemblyName System.IO.Compression.FileSystem;
  [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipRepositoryFile, $DotfilesFolder);
  Invoke-Expression (Join-Path -Path $DotfilesWorkFolder -ChildPath "Setup.ps1");
}

####

# Add needed modules
Import-Module "~\.dotfiles\pwsh\Modules\Core-Functions\Core-Functions.psm1"
Import-Module "~\.dotfiles\pwsh\Modules\Install-Fonts\Install-Fonts.psm1"

# Install Oh My Posh
# https://ohmyposh.dev/docs/installation/windows
winget install JanDeDobbeleer.OhMyPosh -s winget

# Install fonts
$dir = "~\Downloads\Fonts"
If(!(test-path $dir)) {New-Item -ItemType Directory -Force -Path $dir}
Start-BitsTransfer "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip" $dir\FiraCode.zip
Expand-Archive -Path $dir\FiraCode.zip -DestinationPath $dir
Get-ChildItem -Path $dir  *.ttf | ForEach-Object { Remove-Item -Path $_.FullName }
Get-ChildItem -Path $dir  Fura* | ForEach-Object { Remove-Item -Path $_.FullName }
Get-ChildItem -Path $dir  *Mono* | ForEach-Object { Remove-Item -Path $_.FullName }
Get-ChildItem -Path $dir  -Exclude "*Windows Compatible.otf" | ForEach-Object { Remove-Item -Path $_.FullName }
Install-FontsFromDir $dir
Remove-ItemSafely $dir

# Delete exising profiles
Remove-ItemSafely ~\Documents\WindowsPowerShell
Remove-ItemSafely ~\Documents\PowerShell

# Get My Documents location
$docs = [Environment]::GetFolderPath('MyDocuments')

# Symlink profile to locations
New-Item -ItemType Junction -Path "$docs\WindowsPowerShell\" -Target (Get-Item '~\.dotfiles\pwsh').FullName
New-Item -ItemType Junction -Path "$docs\PowerShell\" -Target (Get-Item '~\.dotfiles\pwsh').FullName
