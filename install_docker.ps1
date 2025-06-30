# PowerShell script to install Docker Desktop on Windows

Write-Host "Starting Docker Desktop installation..."

# Download Docker Desktop installer
$installerUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
$installerPath = "$env:TEMP\DockerDesktopInstaller.exe"

Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

Write-Host "Docker Desktop installer downloaded to $installerPath"

# Run the installer silently
Start-Process -FilePath $installerPath -ArgumentList "install", "--quiet" -Wait

Write-Host "Docker Desktop installation completed."

# Start Docker Desktop
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

Write-Host "Docker Desktop started. Please wait for it to initialize."

# Wait for Docker to be ready
Write-Host "Waiting for Docker to be ready..."
do {
    Start-Sleep -Seconds 5
    $dockerInfo = docker info 2>$null
} while (-not $dockerInfo)

Write-Host "Docker is ready."

# Clean up installer
Remove-Item $installerPath -Force

Write-Host "Installation script completed."
