# PowerShell script to assist with downloading NVIDIA GPU driver and CUDA Toolkit installers on Windows 10

# Define URLs for latest NVIDIA driver and CUDA Toolkit
$NvidiaDriverUrl = "https://www.nvidia.com/Download/driverResults.aspx/214849/en-us"
$CudaToolkitUrl = "https://developer.nvidia.com/compute/cuda/12.2.0/local_installers/cuda_12.2.0_535.54.03_windows.exe"

# Define download paths
$DownloadFolder = "$env:USERPROFILE\Downloads"
$NvidiaDriverInstaller = Join-Path $DownloadFolder "NVIDIA_Driver_Installer.exe"
$CudaToolkitInstaller = Join-Path $DownloadFolder "CUDA_Toolkit_Installer.exe"

Write-Host "Downloading NVIDIA GPU driver installer..."
Invoke-WebRequest -Uri $NvidiaDriverUrl -OutFile $NvidiaDriverInstaller

Write-Host "Downloading CUDA Toolkit installer..."
Invoke-WebRequest -Uri $CudaToolkitUrl -OutFile $CudaToolkitInstaller

Write-Host "Download complete."
Write-Host "Please run the following installers manually with administrator privileges:"
Write-Host "1. NVIDIA GPU Driver: $NvidiaDriverInstaller"
Write-Host "2. CUDA Toolkit: $CudaToolkitInstaller"
Write-Host "Follow the on-screen instructions to complete the installations."
Write-Host "After installation, restart your computer and run the check_nvidia_driver_and_cuda.ps1 script to verify."
