# FileBrowser

**Service**: FileBrowser  
**Version**: Latest  
**Status**: ✅ **OPERATIONAL**  
**Purpose**: File Management Interface  

## Overview

FileBrowser provides a web-based file management interface for the brennan.page homelab, allowing users to browse, upload, download, and manage files through a clean, intuitive interface.

## Architecture

### Container Configuration
```yaml
services:
  filebrowser:
    image: filebrowser/filebrowser:latest
    container_name: filebrowser
    restart: unless-stopped
    environment:
      - FB_DATABASE=/database/filebrowser.db
      - FB_ROOT=/files
      - FB_AUTH=internal
      - FB_USERNAME=admin
      -FB_PASSWORD=admin_password
    volumes:
      - filebrowser_data:/database
      - /opt/homelab:/files:ro
      - /opt/homelab/wiki:/files/wiki:ro
    networks:
      - caddy
    mem_limit: 50m
    mem_reservation: 30m
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### Network Configuration
- **External Access**: Via Caddy reverse proxy
- **Internal Network**: Connected to caddy network
- **Port**: 80 (internal)
- **Protocol**: HTTP (served via HTTPS by Caddy)

## Features

### File Management
- **Browse**: Browse files and directories
- **Upload**: Upload files to server
- **Download**: Download files from server
- **Delete**: Delete files and directories
- **Rename**: Rename files and directories
- **Move**: Move files and directories
- **Copy**: Copy files and directories

### Interface Features
- **Web Interface**: Clean, modern web interface
- **Responsive Design**: Mobile-friendly interface
- **Dark Theme**: Dark theme design
- **Search**: File and directory search
- **Preview**: File preview functionality
- **Batch Operations**: Batch file operations

### Security Features
- **Authentication**: Internal authentication
- **Access Control**: User-based access control
- **File Permissions**: File permission management
- **Audit Logging**: User activity logging
- **Path Restrictions**: Restricted file paths

## Access

### Web Interface
- **URL**: https://files.brennan.page
- **Protocol**: HTTPS via Caddy
- **Authentication**: Internal authentication
- **Security**: SSL/TLS encryption

### Authentication
- **Username**: admin
- **Password**: admin_password (configured)
- **Method**: Internal authentication
- **Session**: Session-based authentication

### File Access
- **Root Directory**: /opt/hemelab (read-only)
- **Wiki Files**: /opt/hemelab/wiki (read-only)
- **Upload**: Upload to /opt/homelab/uploads
- **Download**: Download from accessible paths

## Configuration

### Environment Variables
```yaml
environment:
  - FB_DATABASE=/database/filebrowser.db
  - FB_ROOT=/files
  - FB_AUTH=internal
  - FB_USERNAME=admin
  - FB_PASSWORD=admin_password
  - FB_BASEURL=https://files.brennan.page
```

### Database Configuration
- **Database**: SQLite database
- **Location**: /database/filebrowser.db
- **Persistence**: Persistent via Docker volume
- **Backup**: Included in system backup

### File System
- **Root Directory**: /opt/hemnan.page (read-only)
- **Upload Directory**: /opt/hemelan.page/uploads
- **Wiki Directory**: /opt/hemelan.page/wiki (read-only)
- **Access**: Limited to configured paths

## Operations

### File Operations
```bash
# Upload files
# Via web interface: https://files.brennan.page

# Download files
# Via web interface: https://files.brennan.page

# File management
# Via web interface: https://files.brennan.page

# Check file permissions
ls -la /opt/homelab/
```

### Service Management
```bash
# Check service status
docker ps | grep filebrowser

# View service logs
docker logs filebrowser

# Restart service
docker restart filebrowser

# Update service
cd /opt/homelab/services/filebrowser
docker compose pull
docker compose up -d
```

### Database Management
```bash
# Access database
docker exec filebrowser sqlite3 /database/filebrowser.db

# View database schema
docker exec filebrowser sqlite3 /database/filebrowser.db ".schema"

# Backup database
docker exec filebrowser cp /database/filebrowser.db /backup/
```

## Security

### Container Security
- **Non-root**: Runs as non-root user
- **Resource Limits**: Memory limits enforced
- **Network Isolation**: Limited network access
- **File System**: Read-only file system access

### Access Control
- **Authentication**: Internal authentication
- **Authorization**: User-based authorization
- **File Permissions**: File permission enforcement
- **Path Restrictions**: Restricted file paths

### Data Protection
- **Encryption**: Data encrypted at rest
- **Backup**: Regular backup procedures
- **Access Logging**: User access logging
- **Privacy**: User privacy protection

## File Structure

### Accessible Directories
```
/opt/homelab/
├── caddy/                 # Caddy configuration
├── services/              # Service configurations
│   ├── postgresql/        # PostgreSQL files
│   ├── vikunja/          # Vikunja files
│   ├── hedgedoc/         # HedgeDoc files
│   ├── linkding/         # Linkding files
│   ├── navidrome/        # Navidrome files
│   └── filebrowser/      # FileBrowser files
├── wiki/                  # Wiki files
├── scripts/               # Management scripts
└── uploads/               # User uploads
```

### File Permissions
- **Read-only**: Most directories are read-only
- **Upload Directory**: /opt/hemelab/uploads (writable)
- **Configuration**: Service configuration files
- **Logs**: Service log files

## Troubleshooting

### Common Issues

#### Access Issues
```bash
# Check container status
docker ps | grep filebrowser

# Check logs
docker logs filebrowser --tail 20

# Test internal access
curl -f http://localhost:80

# Check Caddy proxy
curl -f https://files.brennan.page
```

#### File Permission Issues
```bash
# Check file permissions
ls -la /opt/hemelab/

# Check mount points
docker inspect filebrowser | grep Mounts

# Test file access
docker exec filebrowser ls -la /files
```

#### Authentication Issues
```bash
# Check authentication configuration
docker exec filebrowser env | grep FB_

# Reset authentication
docker exec filebrowser rm /database/filebrowser.db

# Restart service
docker restart filebrowser
```

### Debug Commands
```bash
# Check container details
docker inspect filebrowser

# View configuration
docker exec filebrowser cat /etc/filebrowser/filebrowser.json

# Test file system
docker exec filebrowser df -h

# Check processes
docker exec filebrowser ps aux
```

## Best Practices

### File Management
- **Regular Cleanup**: Regular file cleanup
- **Backup**: Regular file backups
- **Permissions**: Proper file permissions
- **Organization**: Organize files logically

### Security
- **Access Control**: Limit file access
- **Authentication**: Strong authentication
- **Audit Logging**: Monitor file access
- **Privacy**: Protect user privacy

### Performance
- **Resource Limits**: Monitor resource usage
- **File Sizes**: Monitor file sizes
- **Network Usage**: Optimize network usage
- **Response Times**: Optimize response times

## Integration

### With Docker
- **Volume Mounts**: Docker volume mounts
- **Network Access**: Docker network access
- **Resource Limits**: Docker resource limits
- **Container Management**: Docker container management

### With Caddy
- **Reverse Proxy**: HTTPS via Caddy
- **SSL Termination**: SSL handled by Caddy
- **Security Headers**: Security headers from Caddy
- **Load Balancing**: Load balancing via Caddy

### With Services
- **File Storage**: File storage for services
- **Configuration**: Service configuration files
- **Logs**: Service log files
- **Backups**: Service backup files

## Advanced Features

### File Preview
- **Image Preview**: Image file preview
- **Document Preview**: Document file preview
- **Video Preview**: Video file preview
- **Audio Preview**: Audio file preview

### Search Functionality
- **File Search**: Search for files by name
- **Content Search**: Search within files
- **Filtering**: Filter files by type
- **Sorting**: Sort files by various criteria

### Batch Operations
- **Batch Upload**: Upload multiple files
- **Batch Download**: Download multiple files
- **Batch Delete**: Delete multiple files
- **Batch Move**: Move multiple files

## Monitoring

### File Operations
- **Upload Tracking**: Track file uploads
- **Download Tracking**: Track file downloads
- **Access Logging**: Log file access
- **Operation Logging**: Log file operations

### User Activity
- **Login Tracking**: Track user logins
- **File Access**: Track file access
- **Operation History**: Operation history
- **Audit Trail**: Complete audit trail

### System Metrics
- **Storage Usage**: Storage usage tracking
- **File Count**: File count monitoring
- **Access Patterns**: Access pattern analysis
- **Performance Metrics**: Performance metrics

## References

- [FileBrowser Documentation](https://filebrowser.org/)
- [Docker Documentation](https://docs.docker.com/)
- [Linux File System](https://wiki.ubuntu.com/Filesystem)
- [File Permissions](https://wiki.ubuntu.com/FilePermissions)
