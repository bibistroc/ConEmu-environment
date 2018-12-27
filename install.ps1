# requires -v 3
$urlOfTheme = "https://raw.githubusercontent.com/bibistroc/ConEmu-environment/master/Theme/HonukaiAlt.psm1"

# check for powershell version
if(($PSVersionTable.PSVersion.Major) -lt 3) {
    Write-Output "PowerShell 3 or greater is required to use this profile."
    Write-Output "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
    break
}


# check for execution policy:
if((Get-ExecutionPolicy) -gt 'RemoteSigned' -or (Get-ExecutionPolicy) -eq 'ByPass') {
    Write-Output "PowerShell requires an execution policy of 'RemoteSigned' to configure this profile."
    Write-Output "To make this change please run:"
    Write-Output "'Set-ExecutionPolicy RemoteSigned -scope CurrentUser'"
    break
}

# checking for required powershell modules
Write-Host "Checking for required powershell modules"
if (-not (Get-Module -name posh-git)) {
    Install-Module posh-git -Scope CurrentUser -Force -SkipPublisherCheck
} else {
    Write-Host "posh-git module is installed"
}
if (-not (Get-Module -name oh-my-posh)) {
    Install-Module oh-my-posh -Scope CurrentUser -Force -SkipPublisherCheck
} else {
    Write-Host "oh-my-posh module is installed"
}
if (-not (Get-Module -name posh-docker)) {
    Install-Module posh-docker -Scope CurrentUser -Force -SkipPublisherCheck
} else {
    Write-Host "posh-docker module is installed"
}

# check for psreadline module (optional)
if (-not (Get-Command "Set-PSReadlineKeyHandler" -errorAction SilentlyContinue)) {
    Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
}

# checking for powershell profile file and create it if needed
if (-not (Test-Path -Path $PROFILE )) {
    New-Item -Type File -Path $PROFILE -Force
} else {
    Write-Host "Powershell profile found."
    $delProfile = Read-Host -Prompt 'Do you want to replace it? [Y/n]'
    if ($delProfile -eq 'y' -or $delProfile -eq 'Y') {
        Rename-Item -Path $PROFILE -NewName "$PROFILE.bak" -Force
    }
}

# adding HonukaiAlt theme
Import-Module posh-git
Import-Module oh-my-posh
$ohMyPoshModulePath = (Get-Item (Get-Module -name oh-my-posh).Path).Directory.FullName
$themeFileName = "$ohMyPoshModulePath/Themes/HonokaiAlt.psm1"
Invoke-WebRequest -Uri $urlOfTheme -OutFile $themeFileName


# append profile information
Add-Content -Path $PROFILE -Value ""
Add-Content -Path $PROFILE -Value "Import-Module posh-git"
Add-Content -Path $PROFILE -Value "Import-Module oh-my-posh"
Add-Content -Path $PROFILE -Value "Import-Module posh-docker"
Add-Content -Path $PROFILE -Value "Set-PSReadlineKeyHandler -Key Tab -Function Complete"
Add-Content -Path $PROFILE -Value "Set-Theme HonokaiAlt"

Write-Host "Please restart your shell to see the changes"

. $PROFILE

Clear-Host
