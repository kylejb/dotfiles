function Set-Git-Configuration {
  Write-Host "Configuring Git:" -ForegroundColor "Green";

  # git config --global user.name $Config.GitUserName;
  # git config --global user.email $Config.GitUserEmail;
  git config --global gpg.program C:\\Program Files (x86)\\GnuPG\\bin\\gpg.exe;
  git config --global core.sshCommand C:/Windows/System32/OpenSSH/ssh.exe;

  Write-Host "Git was successfully configured." -ForegroundColor "Green";
}

$GIT_CONFIG_DIR=$HOME\.config\git
New-Item -Path $GIT_CONFIG_DIR -ItemType Directory

# TODO: finish backing up for error handling
# del /F /Q %GIT_CONFIG_DIR%\config.bak >NUL 2>&1
# del /F /Q %GIT_CONFIG_DIR%\attributes.bak >NUL 2>&1
# del /F /Q %GIT_CONFIG_DIR%\ignore.bak >NUL 2>&1
# move /Y %GIT_CONFIG_DIR%\config %GIT_CONFIG_DIR%\config.bak >NUL 2>&1
# move /Y %GIT_CONFIG_DIR%\attributes %GIT_CONFIG_DIR%\attributes.bak >NUL 2>&1
# move /Y %GIT_CONFIG_DIR%\ignore %GIT_CONFIG_DIR%\ignore.bak >NUL 2>&1

New-Item -ItemType Junction -Path "$GIT_CONFIG_DIR\config" -Target (Get-Item '~\.dotfiles\git\gitconfig.symlink').FullName
New-Item -ItemType Junction -Path "$GIT_CONFIG_DIR\ignore" -Target (Get-Item '~\.dotfiles\git\gitignore.symlink').FullName

# TODO: restore previously backed up files, if error occurs
# if not exist %GIT_CONFIG_DIR%\config (
# echo ERROR:Installation failed.
# move /Y %GIT_CONFIG_DIR%\config.bak %GIT_CONFIG_DIR%\config >NUL 2>&1
# move /Y %GIT_CONFIG_DIR%\attributes.bak %GIT_CONFIG_DIR%\attributes >NUL 2>&1
# move /Y %GIT_CONFIG_DIR%\ignore.bak %GIT_CONFIG_DIR%\ignore >NUL 2>&1
# )

# if exists
# TODO: set dynamically based on OS without complicating `git` flow
# Set-Git-Configuration;
