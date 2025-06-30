# PowerShell deployment script for Windows

# Load environment variables from .env if present
if (Test-Path .env) {
    Get-Content .env | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]+)=(.+)$') {
            [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
        }
    }
}

# Build release binaries before Docker build
Write-Host "Building release binaries..."
cargo build --release

Write-Host "Copying binaries to deployment SDK directory..."
New-Item -ItemType Directory -Force -Path deploy/sdk/src/dynamo/sdk/cli/bin | Out-Null
Copy-Item -Path target/release/http -Destination deploy/sdk/src/dynamo/sdk/cli/bin/
Copy-Item -Path target/release/llmctl -Destination deploy/sdk/src/dynamo/sdk/cli/bin/
Copy-Item -Path target/release/dynamo-run -Destination deploy/sdk/src/dynamo/sdk/cli/bin/

# Build Docker images for all services
docker-compose build

# Stop and remove existing containers
docker-compose down

# Start containers in detached mode
docker-compose up -d

# Show running containers
docker-compose ps
