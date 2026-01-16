#!/usr/bin/env bash
# Full deployment script for brennan.page homelab
set -euo pipefail

# Configuration
REMOTE="root@159.203.44.169"
REMOTE_BASE="/opt/homelab"
SSH_KEY="~/.omg-lol-keys/id_ed25519"

echo "=== brennan.page Full Deployment ==="
echo "Date: $(date)"
echo ""

# Function to sync directory
sync_directory() {
    local local_dir="$1"
    local remote_dir="$2"
    
    echo "Syncing $local_dir to $remote_dir..."
    rsync -avz --exclude '.git' --exclude '*.log' --exclude '*.tmp' \
        "$local_dir/" "${REMOTE}:${remote_dir}/"
}

# Function to setup server directory structure
setup_server_structure() {
    echo "Setting up server directory structure..."
    
    ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" << EOF
        # Create base directories
        mkdir -p "$REMOTE_BASE"/{caddy,services,wiki,backups/{scripts,data},monitoring,shared/{passwords,ssl-certs}}
        
        # Set proper permissions
        chmod 700 "$REMOTE_BASE/shared/passwords"
        
        # Create backup script on server
        mkdir -p "$REMOTE_BASE/backups/scripts"
EOF
}

# Function to setup Docker networks
setup_docker_networks() {
    echo "Setting up Docker networks..."
    
    ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" << EOF
        # Create networks if they don't exist
        for network in caddy internal_db monitoring; do
            if ! docker network inspect "\$network" >/dev/null 2>&1; then
                echo "Creating network: \$network"
                docker network create "\$network"
            else
                echo "Network \$network already exists"
            fi
        done
EOF
}

# Function to deploy Caddy
deploy_caddy() {
    echo "Deploying Caddy reverse proxy..."
    
    sync_directory "caddy" "$REMOTE_BASE/caddy"
    
    ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" << EOF
        cd "$REMOTE_BASE/caddy"
        
        # Stop existing Caddy
        docker compose down || true
        
        # Start Caddy
        docker compose up -d
        
        # Wait for Caddy to start
        sleep 10
        
        # Check if Caddy is running
        if docker compose ps | grep -q "Up"; then
            echo "✅ Caddy deployed successfully"
        else
            echo "❌ Caddy failed to start"
            docker compose logs
            exit 1
        fi
EOF
}

# Function to deploy services
deploy_services() {
    echo "Deploying core services..."
    
    # List of services to deploy in order
    services=("portainer" "glances" "filebrowser")
    
    for service in "${services[@]}"; do
        echo "Deploying service: $service"
        
        if [ -d "services/$service" ]; then
            sync_directory "services/$service" "$REMOTE_BASE/services/$service"
            
            ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" << EOF
                cd "$REMOTE_BASE/services/$service"
                
                # Stop existing service
                docker compose down || true
                
                # Start service
                docker compose up -d
                
                # Wait for service to start
                sleep 5
                
                # Check service status
                if docker compose ps | grep -q "Up"; then
                    echo "✅ Service $service deployed successfully"
                else
                    echo "❌ Service $service failed to start"
                    docker compose logs
                fi
EOF
        else
            echo "⚠️  Service directory $service not found, skipping"
        fi
    done
}

# Function to setup backup scripts
setup_backup_scripts() {
    echo "Setting up backup scripts..."
    
    sync_directory "scripts" "$REMOTE_BASE/backups/scripts"
    
    ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" << EOF
        # Make backup scripts executable
        chmod +x "$REMOTE_BASE/backups/scripts"/*.sh
        
        # Setup cron job for daily backups (3:00 AM)
        (crontab -l 2>/dev/null; echo "0 3 * * * $REMOTE_BASE/backups/scripts/backup.sh") | crontab -
        
        echo "✅ Backup scripts setup completed"
EOF
}

# Function to verify deployment
verify_deployment() {
    echo "Verifying deployment..."
    
    ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" << EOF
        echo "=== System Status ==="
        echo "Docker containers:"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        
        echo ""
        echo "Docker networks:"
        docker network ls
        
        echo ""
        echo "Disk usage:"
        df -h | grep -E "(Filesystem|/dev/)"
        
        echo ""
        echo "Memory usage:"
        free -h
        
        echo ""
        echo "=== Service URLs ==="
        echo "Caddy (reverse proxy): https://brennan.page"
        echo "Portainer: https://docker.brennan.page"
        echo "Glances: https://monitor.brennan.page"
        echo "FileBrowser: https://files.brennan.page"
EOF
}

# Main deployment process
main() {
    echo "Starting full deployment of brennan.page homelab..."
    echo ""
    
    # Setup server structure
    setup_server_structure
    echo ""
    
    # Setup Docker networks
    setup_docker_networks
    echo ""
    
    # Deploy Caddy
    deploy_caddy
    echo ""
    
    # Deploy services
    deploy_services
    echo ""
    
    # Setup backup scripts
    setup_backup_scripts
    echo ""
    
    # Verify deployment
    verify_deployment
    echo ""
    
    echo "✅ Full deployment completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Visit https://docker.brennan.page to manage Docker containers"
    echo "2. Visit https://monitor.brennan.page to monitor system resources"
    echo "3. Visit https://files.brennan.page to manage files"
    echo "4. Deploy wiki: cd wiki && ./deploy-wiki.sh"
}

# Execute main function
main
