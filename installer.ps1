# First time installation for new Windows system.
# TODO: review paths and refactor
# TODO: review Setup.ps1 and merge

# function mklink {
#   cmd /c mklink $args
# # cmd /c mklink c:\path\to\symlink c:\target\file

# # must pass /d if path to is a directory
# # cmd /c mklink /d c:\path\to\symlink c:\target\directory
# }

# # powershell version
# function make-link ($target, $link) {
#   # Junction (for directory)
#   New-Item -Path $link -ItemType SymbolicLink -Value $target
# }

$DownloadResult = $FALSE;

try
{
    git | Out-Null
    git clone https://github.com/kylejb/dotfiles $HOME\.dotfiles
    $DownloadResult = $TRUE;
}
catch [System.Management.Automation.CommandNotFoundException] {
    $GitHubRepositoryUri = "https://github.com/${GitHubRepositoryAuthor}/${GitHubRepositoryName}/archive/refs/heads/main.zip";

    $DotfilesFolder = Join-Path -Path $HOME -ChildPath ".dotfiles";
    $ZipRepositoryFile = Join-Path -Path $DotfilesFolder -ChildPath "${GitHubRepositoryName}-main.zip";
    $DotfilesWorkFolder = Join-Path -Path $DotfilesFolder -ChildPath "${GitHubRepositoryName}-main"


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
    try {
        Invoke-WebRequest $GitHubRepositoryUri -O $ZipRepositoryFile;
        $DownloadResult = $TRUE;
    }
    catch [System.Net.WebException] {
        Write-Host "Error connecting to GitHub, check the internet connection or the repository url." -ForegroundColor "Red";
    }

    if ($DownloadResult) {
        Add-Type -AssemblyName System.IO.Compression.FileSystem;
        [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipRepositoryFile, $DotfilesFolder);
    }
}

# Run setup
Set-Location $HOME\.dotfiles
.\Setup.ps1
