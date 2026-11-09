# Windows setup: install WSL with Ubuntu. Everything else runs inside WSL through
# the normal Linux install, so there is no separate PowerShell implementation.
#
# Not yet tested on a real Windows machine. Run from an elevated PowerShell.

$ErrorActionPreference = "Stop";

wsl --install -d Ubuntu;
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE; }

Write-Host "Restart if prompted, open Ubuntu, then run the macOS / Linux install from the README." -ForegroundColor "Green";
