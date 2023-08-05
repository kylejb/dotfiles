<#
	.SYNOPSIS
		Install Open Text and True Type Fonts

	.DESCRIPTION
		This script will install OTF and TTF fonts that exist in the same directory as the script.
#>

<#
	.SYNOPSIS
		Install the font

	.DESCRIPTION
		This function will attempt to install the font by copying it to the c:\windows\fonts directory and then registering it in the registry. This also outputs the status of each step for easy tracking.

	.PARAMETER FontFile
		Name of the Font File to install

	.EXAMPLE
		PS C:\> Install-Font -FontFile $value1

	.NOTES
		Additional information about the function.
#>
Function Install-Font {
	param	([Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][System.IO.FileInfo]$FontFile)

	# Get Font Name from the File's Extended Attributes
	$oShell = new-object -com shell.application
	$Folder = $oShell.namespace($FontFile.DirectoryName)
	$Item = $Folder.Items().Item($FontFile.Name)
	$FontName = $Folder.GetDetailsOf($Item, 21)
	try {
		switch ($FontFile.Extension) {
			".ttf" {$FontName = $FontName + [char]32 + '(TrueType)'}
			".otf" {$FontName = $FontName + [char]32 + '(OpenType)'}
		}
		$Copy = $true
		Write-Host ('Copying' + [char]32 + $FontFile.Name + '.....') -NoNewline
		Copy-Item -Path $fontFile.FullName -Destination ("C:\Windows\Fonts\" + $FontFile.Name) -Force
		# Test if font is copied over
		If ((Test-Path ("C:\Windows\Fonts\" + $FontFile.Name)) -eq $true) {
			Write-Host ('Success') -Foreground Yellow
		} else {
			Write-Host ('Failed') -ForegroundColor Red
		}
		$Copy = $false
		# Test if font registry entry exists
        # TODO: confirm -Path in Windows 11
		If ($null -ne (Get-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -ErrorAction SilentlyContinue)) {
			# Test if the entry matches the font file name
			If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {
				Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry.....') -NoNewline
				Write-Host ('Success') -ForegroundColor Yellow
			} else {
				$AddKey = $true
                # TODO: confirm -Path in Windows 11
				Remove-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Force
				Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry.....') -NoNewline
                # TODO: confirm -Path in Windows 11
                New-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.Name -Force -ErrorAction SilentlyContinue | Out-Null
                # TODO: confirm -Path in Windows 11
                If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {
					Write-Host ('Success') -ForegroundColor Yellow
				} else {
					Write-Host ('Failed') -ForegroundColor Red
				}
				$AddKey = $false
			}
		} else {
			$AddKey = $true
			Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry.....') -NoNewline
            # TODO: confirm -Path in Windows 11
            New-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.Name -Force -ErrorAction SilentlyContinue | Out-Null
            # TODO: confirm -Path in Windows 11
            If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {
				Write-Host ('Success') -ForegroundColor Yellow
			} else {
				Write-Host ('Failed') -ForegroundColor Red
			}
			$AddKey = $false
		}

	} catch {
		If ($Copy -eq $true) {
			Write-Host ('Failed') -ForegroundColor Red
			$Copy = $false
		}
		If ($AddKey -eq $true) {
			Write-Host ('Failed') -ForegroundColor Red
			$AddKey = $false
		}
		write-warning $_.exception.message
	}
	Write-Host
}

Function Install-FontsFromDir {
  param([Parameter(Mandatory = $true)][string]$Path)

  foreach ($FontItem in (Get-ChildItem -Path $Path | Where-Object {($_.Name -like '*.ttf') -or ($_.Name -like '*.OTF')})) {
    Install-Font -FontFile $FontItem
  }
}

Export-ModuleMember -Function Install-Font
Export-ModuleMember -Function Install-FontsFromDir
