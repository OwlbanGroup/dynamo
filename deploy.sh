#!/bin/bash

# Load environment variables
if [ -f .env ]; then
  export $(cat .env | xargs)
fi

# Build Docker images for all services
docker-compose build

# Stop and remove existing containers
docker-compose down

# Start containers in detached mode
docker-compose up -d

# Show running containers
docker-compose ps
