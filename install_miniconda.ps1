# PowerShell script to download and install Miniconda on Windows

$MinicondaUrl = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
$DownloadPath = "$env:USERPROFILE\Downloads\Miniconda3-latest-Windows-x86_64.exe"

Write-Host "Downloading Miniconda installer..."
Invoke-WebRequest -Uri $MinicondaUrl -OutFile $DownloadPath

Write-Host "Download complete. Starting Miniconda installer..."
Start-Process -FilePath $DownloadPath -ArgumentList "/InstallationType=JustMe", "/AddToPath=1", "/RegisterPython=0", "/S", "/D=$env:USERPROFILE\Miniconda3" -Wait

Write-Host "Miniconda installation completed."

Write-Host "Please restart your PowerShell or command prompt to refresh environment variables."
