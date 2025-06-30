# PowerShell script to complete environment setup for NVIDIA Dynamo AI system

# 1. Install Python 3.10+ (Assuming Python is already installed, verify version)
Write-Host "Checking Python version..."
python --version

# 2. Create and activate virtual environment
Write-Host "Creating and activating virtual environment..."
python -m venv venv
& .\venv\Scripts\Activate.ps1

# 3. Upgrade pip and install Python dependencies
Write-Host "Upgrading pip and installing Python dependencies..."
python -m pip install --upgrade pip
pip install -r requirements.txt

# 4. Install additional Python packages that may be missing
Write-Host "Installing additional Python packages..."
pip install tritonclient sseclient protobuf

# 5. Set PYTHONPATH environment variable
Write-Host "Setting PYTHONPATH environment variable..."
.\set_pythonpath.ps1

# 6. Clean up __pycache__ and .pyc files to avoid import mismatches
Write-Host "Cleaning up __pycache__ and .pyc files..."
Get-ChildItem -Path . -Include __pycache__ -Recurse | Remove-Item -Recurse -Force
Get-ChildItem -Path . -Include *.pyc -Recurse | Remove-Item -Force

# 7. Verify Docker and Docker Compose installation
Write-Host "Checking Docker and Docker Compose versions..."
docker --version
docker-compose --version

# 8. Build release binaries using Cargo
Write-Host "Building release binaries with Cargo..."
cargo build --release

# 9. Build Docker image for Dynamo
Write-Host "Building Docker image for Dynamo..."
.\container\build.sh --framework vllm

# 10. Start prerequisite services using Docker Compose
Write-Host "Starting prerequisite services (NATS, etcd, Prometheus, Grafana)..."
docker compose -f deploy/metrics/docker-compose.yml up -d

Write-Host "Environment setup complete. You can now run tests using run_tests_with_env.ps1."
