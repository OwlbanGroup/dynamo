#!/bin/bash

# Simple deployment verification script for NVIDIA Dynamo

echo "Checking if Dynamo service is running on port 8000..."
if curl -s --fail http://localhost:8000/v1/chat/completions > /dev/null; then
  echo "Dynamo service is reachable."
else
  echo "ERROR: Dynamo service is not reachable on port 8000."
  exit 1
fi

echo "Checking if OwlbanGroup service is running on port 3000..."
if curl -s --fail http://localhost:3000/ > /dev/null; then
  echo "OwlbanGroup service is reachable."
else
  echo "ERROR: OwlbanGroup service is not reachable on port 3000."
  exit 1
fi

echo "Deployment verification completed successfully."
