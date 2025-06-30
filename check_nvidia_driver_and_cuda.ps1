# PowerShell script to check NVIDIA GPU driver and CUDA installation on Windows

Write-Host "Checking NVIDIA GPU driver and CUDA installation..."

# Check if nvidia-smi command is available
$nvidiaSmi = Get-Command nvidia-smi -ErrorAction SilentlyContinue

if ($null -eq $nvidiaSmi) {
    Write-Host "nvidia-smi not found. NVIDIA GPU driver may not be installed or not in PATH."
    Write-Host "Please download and install the latest NVIDIA GPU driver from:"
    Write-Host "https://www.nvidia.com/Download/index.aspx"
} else {
    Write-Host "nvidia-smi found. Displaying GPU status:"
    nvidia-smi
}

# Check CUDA installation by looking for nvcc compiler
$nvccPath = Get-Command nvcc -ErrorAction SilentlyContinue

if ($null -eq $nvccPath) {
    Write-Host "nvcc (CUDA compiler) not found. CUDA Toolkit may not be installed or not in PATH."
    Write-Host "Please download and install the CUDA Toolkit from:"
    Write-Host "https://developer.nvidia.com/cuda-downloads"
} else {
    Write-Host "nvcc found. Displaying CUDA version:"
    nvcc --version
}

Write-Host "Script completed. Please ensure NVIDIA GPU driver and CUDA Toolkit are installed and configured properly before proceeding with RAPIDS AI installation."
