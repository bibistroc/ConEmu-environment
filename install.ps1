# requires -v 3
$urlOfTheme = "https://raw.githubusercontent.com/bibistroc/ConEmu-environment/master/Theme/HonukaiAlt.psm1"

# check for powershell version
if(($PSVersionTable.PSVersion.Major) -lt 3) {
    Write-Output "PowerShell 3 or greater is required to use this profile."
    Write-Output "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
    exit
}


# check for execution policy:
if((Get-ExecutionPolicy) -gt 'RemoteSigned' -or (Get-ExecutionPolicy) -eq 'ByPass') {
    Write-Output "PowerShell requires an execution policy of 'RemoteSigned' to configure this profile."
    Write-Output "To make this change please run:"
    Write-Output "'Set-ExecutionPolicy RemoteSigned -scope CurrentUser'"
    exit
}

function Show-Exit {
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

function Install-Conemu {
	Write-Host "This script is not run from ConEmu."
	Write-Host "If you have ConEmu installed, quit now and run this script from it."
	$installConemu = Read-Host -Prompt "Do you want to install ConEmu? [Y/q]"
	if ($installConemu -like "y" -or $installConemu -eq "") {
        # Installation script from https://conemu.github.io/en/AutoInstall.html
        Start-Process powershell `
            -ArgumentList "-Command iex ((new-object net.webclient).DownloadString('https://conemu.github.io/install.ps1'))" `
            -Wait

        Write-Host "ConEmu installed"
        Write-Host "You can start ConEmu and run this script again from it to continue."
        Show-Exit
	} else {
        Write-Host "ConEmu is required for this to work properly."
        Write-Host "If you want to use it, you can run this script again."
        Show-Exit
    }
}

function Install-Git {
    Write-Host "Git is not installed."
    $installGit = Read-Host -Prompt "Do you want to install it? [Y/n]"
    if ($installGit -like "y" -or $installGit -eq "") {
        Write-Host "In order to install git, an external script will be run."
        Write-Host "If you want to inspect the script, you can find it here: "
        Write-Host "http://r.gbarbu.eu/installgit"
        Write-Host "Press [ENTER] to continue or [CTRL+C] to cancel."
        Read-Host
        Write-Host "Starting installing"
        Start-Process powershell `
            -ArgumentList "-Command iwr r.gbarbu.eu/installgit -UseBasicParsing | iex" `
            -Wait `
            -Verb RunAs

        Write-Host "Git installed"

        # Reset environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + 
                    [System.Environment]::GetEnvironmentVariable("Path","User")
    } else {
        Write-Host "Git is required for this to work properly."
        Write-Host "If you want to use it, you can run this script again."
        Show-Exit 
    }
}

# check for prerequisites
try {
	IsConEmu | Out-Null
} catch {
	Install-Conemu
}

try {
    git | Out-Null
} catch {
    Install-Git
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
