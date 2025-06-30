# PowerShell deployment script for Windows

# Load environment variables from .env if present
if (Test-Path .env) {
    Get-Content .env | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]+)=(.+)$') {
            [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
        }
    }
}

# Build Docker images for all services
docker-compose build

# Stop and remove existing containers
docker-compose down

# Start containers in detached mode
docker-compose up -d

# Show running containers
docker-compose ps
