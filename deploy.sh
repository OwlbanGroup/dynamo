#!/bin/bash

# Load environment variables
if [ -f .env ]; then
  export $(cat .env | xargs)
fi

# Build release binaries before Docker build
echo "Building release binaries..."
cargo build --release

echo "Copying binaries to deployment SDK directory..."
mkdir -p deploy/sdk/src/dynamo/sdk/cli/bin
cp target/release/http deploy/sdk/src/dynamo/sdk/cli/bin/
cp target/release/llmctl deploy/sdk/src/dynamo/sdk/cli/bin/
cp target/release/dynamo-run deploy/sdk/src/dynamo/sdk/cli/bin/

# Build Docker images for all services
docker-compose build

# Stop and remove existing containers
docker-compose down

# Start containers in detached mode
docker-compose up -d

# Show running containers
docker-compose ps
