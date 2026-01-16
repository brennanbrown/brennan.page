#!/usr/bin/env bash
# Generic service deployment script for brennan.page homelab
set -euo pipefail

# Configuration
REMOTE="root@159.203.44.169"
REMOTE_BASE="/opt/homelab"
SSH_KEY="~/.omg-lol-keys/id_ed25519"

# Usage function
usage() {
    echo "Usage: $0 <service-name>"
    echo "Available services: portainer, glances, filebrowser, caddy"
    exit 1
}

# Check if service name is provided
if [ $# -eq 0 ]; then
    usage
fi

SERVICE_NAME="$1"
SERVICE_DIR="services/${SERVICE_NAME}"
REMOTE_SERVICE_DIR="${REMOTE_BASE}/services/${SERVICE_NAME}"

# Validate service exists
if [ ! -d "$SERVICE_DIR" ]; then
    echo "Error: Service directory '$SERVICE_DIR' does not exist"
    usage
fi

echo "Deploying service: $SERVICE_NAME"

# Validate docker-compose configuration
echo "Validating docker-compose configuration..."
cd "$SERVICE_DIR"
docker compose config > /dev/null
cd - > /dev/null

# Sync service files to server
echo "Syncing service files to server..."
rsync -avz --exclude '.git' "$SERVICE_DIR/" "${REMOTE}:${REMOTE_SERVICE_DIR}/"

# Deploy service on server
echo "Deploying service on server..."
ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" << EOF
    cd "$REMOTE_SERVICE_DIR"
    
    # Stop existing service if running
    docker compose down || true
    
    # Start service
    docker compose up -d
    
    # Wait a moment for service to start
    sleep 5
    
    # Check service status
    if docker compose ps | grep -q "Up"; then
        echo "✅ Service '$SERVICE_NAME' deployed successfully"
        docker compose ps
    else
        echo "❌ Service '$SERVICE_NAME' failed to start"
        docker compose logs
        exit 1
    fi
EOF

# Update Caddy if service has a subdomain
if [ -f "caddy/Caddyfile" ] && grep -q "${SERVICE_NAME}.brennan.page" caddy/Caddyfile; then
    echo "Reloading Caddy configuration..."
    ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" << EOF
        cd /opt/homelab/caddy
        docker exec caddy caddy reload
EOF
fi

echo "Deployment of '$SERVICE_NAME' completed successfully!"
