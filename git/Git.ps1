function Set-Git-Configuration {
  Write-Host "Configuring Git:" -ForegroundColor "Green";

  git config --global init.defaultBranch "main";
  git config --global user.name $Config.GitUserName;
  git config --global user.email $Config.GitUserEmail;
  git config --global gpg.program C:\\Program Files (x86)\\GnuPG\\bin\\gpg.exe;
  git config --global core.sshCommand C:/Windows/System32/OpenSSH/ssh.exe;

  Write-Host "Git was successfully configured." -ForegroundColor "Green";
}

choco install -y "git" --params "/NoAutoCrlf /WindowsTerminal /NoShellIntegration /SChannel";
Set-Git-Configuration;
