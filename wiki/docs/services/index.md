# Services

This section documents all services running in the brennan.page homelab.

## Active Services

### Core Services

#### [Caddy](caddy.md)
**Role**: Reverse Proxy & SSL Termination  
**URL**: All subdomains  
**Status**: ✅ Active  
**Memory**: 100MB limit, 50MB reservation  

#### [PostgreSQL](postgresql.md)
**Role**: Database Server  
**URL**: Internal only  
**Status**: ✅ Active  
**Memory**: 256MB limit, 128MB reservation  

### Management Services

#### [Portainer](portainer.md)
**Role**: Docker Management  
**URL**: https://docker.brennan.page  
**Status**: ✅ Active  
**Memory**: 100MB limit, 50MB reservation  

#### [Monitor](monitor.md)
**Role**: Enhanced System Monitoring  
**URL**: https://monitor.brennan.page  
**Status**: ✅ Active  
**Memory**: 50MB limit, 30MB reservation  
**Features**: Real-time stats, service health checks, visual progress bars  

#### [FileBrowser](filebrowser.md)
**Role**: File Management  
**URL**: https://files.brennan.page  
**Status**: ✅ Active  
**Memory**: 50MB limit, 30MB reservation  

### Productivity Services

#### [Vikunja](vikunja.md)
**Role**: Task Management  
**URL**: https://tasks.brennan.page  
**Status**: ✅ Active  
**Memory**: 256MB limit, 128MB reservation  

#### [HedgeDoc](hedgedoc.md)
**Role**: Collaborative Notes  
**URL**: https://notes.brennan.page  
**Status**: ✅ Active  
**Memory**: 256MB limit, 128MB reservation  

#### [Linkding](linkding.md)
**Role**: Bookmark Manager  
**URL**: https://bookmarks.brennan.page  
**Status**: ✅ Active  
**Memory**: 128MB limit, 64MB reservation  

#### [Navidrome](navidrome.md)
**Role**: Music Streaming  
**URL**: https://music.brennan.page/music/app/  
**Status**: ✅ Active  
**Memory**: 256MB limit, 128MB reservation  

### Documentation

#### [Wiki](wiki.md)
**Role**: Documentation Platform  
**URL**: https://wiki.brennan.page  
**Status**: ✅ Active  
**Memory**: Static files (no container)

### Community Platforms (Phase 4)

#### [WriteFreely](writefreely.md)
**Role**: Blogging Platform  
**URL**: https://blog.brennan.page  
**Status**: ✅ Active  
**Memory**: 128MB limit, 64MB reservation  

#### [Flarum](flarum.md)
**Role**: Community Forum  
**URL**: https://forum.brennan.page  
**Status**: ✅ Active  
**Memory**: 256MB limit, 128MB reservation  
**Database**: MariaDB (dedicated)

#### [FreshRSS](freshrss.md)
**Role**: RSS Aggregator  
**URL**: https://rss.brennan.page  
**Status**: ✅ Active  
**Memory**: 128MB limit, 64MB reservation

## Service Architecture

### Network Topology
```
Internet
    │
    ▼
┌─────────────┐
│   Caddy     │ ← Reverse Proxy
└─────┬───────┘
      │
      ├─┬─────────────────────────────────────────────┐
      │ │                                         │
      ▼ ▼                                         ▼ ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│Portainer│ │Vikunja │ │HedgeDoc│ │Linkding│ │Navidrome│
└───────┘ └───────┘ └───────┘ └───────┘ └───────┘
      │         │         │         │         │
      └─────────┴─────────┴─────────┴─────────┘
                │
                ▼
        ┌─────────────┐
        │ PostgreSQL   │ ← Database
        └─────────────┘
```

### Resource Allocation

| Service | Memory Limit | Memory Reservation | Database | Status |
|---------|---------------|-------------------|----------|--------|
| Caddy | 100MB | 50MB | None | ✅ Active |
| PostgreSQL | 256MB | 128MB | Self | ✅ Active |
| Portainer | 100MB | 50MB | None | ✅ Active |
| Monitor | 50MB | 30MB | None | ✅ Active |
| FileBrowser | 50MB | 30MB | None | ✅ Active |
| Vikunja | 256MB | 128MB | PostgreSQL | ✅ Active |
| HedgeDoc | 256MB | 128MB | PostgreSQL | ✅ Active |
| Linkding | 128MB | 64MB | PostgreSQL | ✅ Active |
| Navidrome | 256MB | 128MB | PostgreSQL | ✅ Active |
| Wiki | N/A | N/A | None | ✅ Active |

**Total**: 1.2GB allocated of 2GB available

## Service Dependencies

### Database Dependencies
- **Vikunja**: PostgreSQL (vikunja database)
- **HedgeDoc**: PostgreSQL (hedgedoc database)
- **Linkding**: PostgreSQL (linkding database)
- **Navidrome**: PostgreSQL (navidrome database)

### Network Dependencies
- **All Services**: Caddy network for web access
- **Database Services**: internal_db network for database access
- **Monitoring Services**: monitoring network for monitoring

### Configuration Dependencies
- **SSL Certificates**: Managed by Caddy
- **Environment Variables**: Service-specific configurations
- **Volume Mounts**: Persistent data storage
- **Health Checks**: Service health monitoring

## Service Management

### Deployment Commands
```bash
# Deploy single service
cd /opt/homelab/services/service_name
docker compose up -d

# Deploy all services
cd /opt/homelab
docker compose up -d

# Update service
cd /opt/homelab/services/service_name
docker compose pull
docker compose up -d
```

### Monitoring Commands
```bash
# Check all services
docker ps

# Check service logs
docker logs service_name

# Check resource usage
docker stats

# Check service health
curl -f https://service.brennan.page
```

### Maintenance Commands
```bash
# Restart service
docker compose restart

# Update service
docker compose pull && docker compose up -d

# Remove service
docker compose down

# Backup service
./scripts/backup-service.sh service_name
```

## Service URLs

### Management URLs
- **Docker Management**: https://docker.brennan.page
- **System Monitoring**: https://monitor.brennan.page
- **File Management**: https://files.brennan.page

### Productivity URLs
- **Task Management**: https://tasks.brennan.page
- **Collaborative Notes**: https://notes.brennan.page
- **Bookmark Manager**: https://bookmarks.brennan.page
- **Music Streaming**: https://music.brennan.page/music/app/

### Documentation URLs
- **Main Wiki**: https://wiki.brennan.page
- **Landing Page**: https://brennan.page

## Service Configuration

### Common Configuration Patterns
All services follow similar configuration patterns:

```yaml
version: '3.8'

services:
  service_name:
    image: image:tag
    container_name: service_name
    restart: unless-stopped
    environment:
      - ENV_VAR=value
    volumes:
      - volume:/path
    networks:
      - caddy
      - internal_db
    mem_limit: XXXm
    mem_reservation: XXXm
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### Environment Variables
- **Database Connection**: PostgreSQL connection strings
- **Service URLs**: Public service URLs
- **Authentication**: Service authentication settings
- **Resource Limits**: Memory and CPU limits

### Volume Mounts
- **Data Volumes**: Persistent data storage
- **Configuration**: Service configuration files
- **Logs**: Log file storage
- **Shared**: Shared data between services

## Service Integration

### Database Integration
All database-backed services use PostgreSQL with:
- **Dedicated Databases**: Separate database per service
- **Dedicated Users**: Separate database users
- **Connection Pooling**: Application-level connection pooling
- **Backup Integration**: Included in backup procedures

### Web Integration
All web services integrate with:
- **Caddy**: Reverse proxy and SSL termination
- **Authentication**: Service-specific authentication
- **Security Headers**: Common security headers
- **Error Handling**: Graceful error handling

### Monitoring Integration
All services integrate with:
- **Health Checks**: Service health monitoring
- **Resource Monitoring**: Resource usage tracking
- **Log Aggregation**: Centralized logging
- **Alerting**: Automated alerting

## Service Security

### Container Security
- **Non-root Users**: Services run as non-root users
- **Resource Limits**: Memory and CPU limits
- **Network Isolation**: Network-based isolation
- **Read-only Filesystems**: Where applicable

### Application Security
- **Authentication**: Service authentication
- **Authorization**: Proper access controls
- **Data Protection**: Encrypted data storage
- **Audit Logging**: Activity logging

### Network Security
- **SSL/TLS**: All external traffic encrypted
- **Firewall**: UFW firewall protection
- **Network Isolation**: Internal network isolation
- **Access Control**: Limited external access

## Service Troubleshooting

### Common Issues
- **Service Not Starting**: Check logs and resource usage
- **Database Connection**: Verify database connectivity
- **Network Access**: Check network configuration
- **SSL Issues**: Verify certificate configuration

### Troubleshooting Commands
```bash
# Check service status
docker ps | grep service_name

# Check service logs
docker logs service_name --tail 50

# Check resource usage
docker stats service_name

# Test connectivity
docker exec caddy curl -f http://service_name:port

# Check database connectivity
docker exec postgres psql -U user -d database -c "SELECT 1;"
```

## Service Updates

### Update Process
1. **Backup**: Backup current configuration and data
2. **Test**: Test update in staging environment
3. **Update**: Pull new image and update configuration
4. **Deploy**: Deploy updated service
5. **Verify**: Verify service functionality
6. **Monitor**: Monitor service performance

### Update Commands
```bash
# Update single service
cd /opt/homelab/services/service_name
docker compose pull
docker compose up -d

# Update all services
cd /opt/homelab
docker compose pull
docker compose up -d
```

## Service Scaling

### Current Capacity
- **Total Services**: 8 active services
- **Memory Usage**: 1.2GB of 2GB (60%)
- **Storage Usage**: 3.4GB of 70GB (5%)
- **CPU Usage**: Low utilization

### Scaling Considerations
- **Memory**: Additional services require memory planning
- **Storage**: Monitor storage usage and plan expansion
- **Network**: Consider network bandwidth for scaling
- **Database**: Database performance with more services

## Future Services

### Planned Services
- **WriteFreely**: Blog platform (blog.brennan.page)
- **Flarum**: Community forum (forum.brennan.page)
- **FreshRSS**: RSS reader (rss.brennan.page)
- **Plik**: File sharing (share.brennan.page)
- **Rallly**: Poll scheduler (poll.brennan.page)

### Service Planning
- **Resource Planning**: Memory and storage requirements
- **Database Planning**: Database capacity planning
- **Network Planning**: Network capacity planning
- **Security Planning**: Security considerations

## References

- [Infrastructure](../infrastructure/) - Infrastructure documentation
- [Configuration](../configuration/) - Configuration management
- [Operations](../operations/) - Operational procedures
- [Troubleshooting](../troubleshooting/) - Troubleshooting guides
