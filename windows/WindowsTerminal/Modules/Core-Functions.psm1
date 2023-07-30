Function Remove-ItemSafely {
  param([Parameter(Mandatory = $true)][string]$path)

  if (Test-Path $path) {
      Remove-Item $path -Force -Recurse -ErrorAction SilentlyContinue
  }
}

Function grep($regex, $dir) {
  if ( $dir ) {
    Get-ChildItem $dir | select-string $regex
    return
  }
  $input | select-string $regex
}

Function touch($file) {
  "" | Out-File $file -Encoding ASCII
}

Function wgs([string]$searchTerm) {
  winget search $searchTerm
}

Function Set-NetworkTypes {
  $conns = Get-NetConnectionProfile

  foreach ($conn in $conns) {
      if ($conn.NetworkCategory -eq "Public") {
          $name = $conn.Name
          $confirm = Read-Host "Would you like to switch connection - $name - to Private? (y | n)"
          if ($confirm -eq "y") {
              Set-NetConnectionProfile -Name $name -NetworkCategory Private
          }
      }
  }
}

Function Enable-HyperV {
  Write-Output "Enabling Hyper V..." `n
  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
}

Function Disable-HyperV {
  Write-Output "Disabling Hyper V..." `n
  Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -NoRestart
}

# Restart Windows Explorer Process
Function Restart-Explorer {
  Write-Output "Restarting Explorer process..."
  Stop-Process -processname explorer
}

# Restart Computer
Function Restart-Computer {
  Write-Output "Restarting PC..."
  shutdown -r -t 0
}

Export-ModuleMember -Function Remove-ItemSafely
Export-ModuleMember -Function grep
Export-ModuleMember -Function touch
Export-ModuleMember -Function wgs
Export-ModuleMember -Function Set-NetworkTypes
Export-ModuleMember -Function Enable-HyperV
Export-ModuleMember -Function Disable-HyperV
Export-ModuleMember -Function Restart-Explorer
Export-ModuleMember -Function Restart-Computer
