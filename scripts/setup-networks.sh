#!/usr/bin/env bash
# Docker network setup script for brennan.page homelab
set -euo pipefail

echo "Setting up Docker networks for brennan.page homelab..."

# Create networks if they don't exist
networks=("caddy" "internal_db" "monitoring")

for network in "${networks[@]}"; do
    if docker network inspect "$network" >/dev/null 2>&1; then
        echo "Network '$network' already exists"
    else
        echo "Creating network '$network'..."
        docker network create "$network"
    fi
done

echo "Docker networks setup complete!"

# List networks for verification
echo "Current Docker networks:"
docker network ls
