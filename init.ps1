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
