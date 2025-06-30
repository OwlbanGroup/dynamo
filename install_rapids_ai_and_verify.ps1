# PowerShell script to install RAPIDS AI using Conda and verify installation

# Check if conda is installed
$conda = Get-Command conda -ErrorAction SilentlyContinue
if ($null -eq $conda) {
    Write-Host "Conda is not installed or not in PATH. Please install Miniconda or Anaconda first."
    exit 1
}

# Create and activate RAPIDS conda environment
Write-Host "Creating RAPIDS conda environment..."
conda create -n rapids-22.12 -c rapidsai -c nvidia -c conda-forge rapids=22.12 python=3.8 cudatoolkit=11.5 -y

Write-Host "Activating RAPIDS conda environment..."
conda activate rapids-22.12

# Verify RAPIDS installation by importing cudf and printing version
Write-Host "Verifying RAPIDS installation..."
$pythonCode = @"
import cudf
print('RAPIDS cuDF version:', cudf.__version__)
"@

python -c $pythonCode

if ($LASTEXITCODE -eq 0) {
    Write-Host "RAPIDS AI installation and verification succeeded."
} else {
    Write-Host "RAPIDS AI verification failed. Please check the installation."
}

# Deactivate conda environment
conda deactivate
