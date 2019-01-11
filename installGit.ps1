$installerLocation = "https://github.com/git-for-windows/git/releases/latest/"

# Check for powershell version
if(($PSVersionTable.PSVersion.Major) -lt 3) {
    Write-Output "PowerShell 3 or greater is required to use this script to install git."
    Write-Output "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
    break
}

# Detect architecture
$envArch = $ENV:PROCESSOR_ARCHITECTURE
$detectedArch

switch ($envArch) {
    { @("AMD64", "IA64") -contains $_ } {
        $detectedArch = "64"
    }
    Default {
        $detectedArch = "86"
    }
}
Write-Host "Detected $detectedArch architecture"

# Get installer url
$artifactLinks = (Invoke-WebRequest -Uri $installerLocation -UseBasicParsing).Links
$artifactSearchString = "*/git-*$detectedArch-bit.exe"
$artifactUrl = ($artifactLinks | Where-Object { $_.href -like $artifactSearchString }).href
$artifactDownloadUrl = "https://github.com/$artifactUrl"

# Download installer
Write-Host "Downloading git installer. Please wait ..."
$artifactDownloadPath = Join-Path $env:TEMP "gitinstaller.exe"
$installerWebClient = New-Object System.Net.WebClient
$installerWebClient.DownloadFile($artifactDownloadUrl, $artifactDownloadPath)
Write-Host "Downloaded git installer into: $artifactDownloadPath"

Write-Host "Installing git. This will take a while. Please wait"
Start-Process -FilePath "$artifactDownloadPath" -ArgumentList "/VERYSILENT","/SUPPRESSMSGBOXES","/NORESTART","/NOCANCEL","/SP-","/LOG","/GitAndUnixToolsOnPath","/NoAutoCrlf" -Wait
Write-Host "Installation finished."

# Reset environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + 
            [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Script finished. You can start using git."