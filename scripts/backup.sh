#!/usr/bin/env bash
# Backup script for brennan.page homelab
set -euo pipefail

# Configuration
BACKUP_DIR="/opt/homelab/backups/data"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=7

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "Starting backup process - $DATE"

# Function to backup Docker volumes
backup_docker_volume() {
    local volume_name="$1"
    local backup_file="${BACKUP_DIR}/${volume_name}_${DATE}.tar.gz"
    
    echo "Backing up Docker volume: $volume_name"
    
    docker run --rm \
        -v "${volume_name}:/source:ro" \
        -v "$BACKUP_DIR:/backup" \
        alpine \
        tar czf "/backup/$(basename "$backup_file")" -C /source .
    
    echo "✅ Volume backup completed: $backup_file"
}

# Function to backup configuration files
backup_configs() {
    local config_backup="${BACKUP_DIR}/configs_${DATE}.tar.gz"
    
    echo "Backing up configuration files..."
    
    tar czf "$config_backup" \
        /opt/homelab/services/ \
        /opt/homelab/caddy/ \
        --exclude='*.log' \
        --exclude='*.tmp' \
        --exclude='.git'
    
    echo "✅ Configuration backup completed: $config_backup"
}

# Function to backup wiki (static files)
backup_wiki() {
    local wiki_backup="${BACKUP_DIR}/wiki_${DATE}.tar.gz"
    
    if [ -d "/opt/homelab/wiki" ]; then
        echo "Backing up wiki files..."
        tar czf "$wiki_backup" -C /opt/homelab wiki/
        echo "✅ Wiki backup completed: $wiki_backup"
    else
        echo "⚠️  Wiki directory not found, skipping wiki backup"
    fi
}

# Function to rotate old backups
rotate_backups() {
    echo "Rotating old backups (keeping last $RETENTION_DAYS days)..."
    
    find "$BACKUP_DIR" -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete
    
    echo "✅ Backup rotation completed"
}

# Function to verify backup integrity
verify_backup() {
    local backup_file="$1"
    
    if tar tzf "$backup_file" > /dev/null 2>&1; then
        echo "✅ Backup integrity verified: $backup_file"
        return 0
    else
        echo "❌ Backup integrity check failed: $backup_file"
        return 1
    fi
}

# Main backup process
main() {
    echo "=== brennan.page Homelab Backup ==="
    echo "Date: $(date)"
    echo "Backup Directory: $BACKUP_DIR"
    echo ""
    
    # Backup Docker volumes
    echo "--- Docker Volumes ---"
    backup_docker_volume "caddy_caddy_data"
    backup_docker_volume "portainer_portainer_data"
    backup_docker_volume "filebrowser_filebrowser_data"
    backup_docker_volume "filebrowser_filebrowser_config"
    echo ""
    
    # Backup configurations
    echo "--- Configurations ---"
    backup_configs
    echo ""
    
    # Backup wiki
    echo "--- Wiki Files ---"
    backup_wiki
    echo ""
    
    # Rotate old backups
    echo "--- Cleanup ---"
    rotate_backups
    echo ""
    
    # Summary
    echo "--- Backup Summary ---"
    echo "Total backup size: $(du -sh "$BACKUP_DIR" | cut -f1)"
    echo "Number of backup files: $(find "$BACKUP_DIR" -name "*.tar.gz" | wc -l)"
    echo "Latest backups:"
    ls -lh "$BACKUP_DIR"/*.tar.gz | tail -5
    echo ""
    
    echo "✅ Backup process completed successfully!"
}

# Execute main function
main
