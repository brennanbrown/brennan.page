# Phase 3 Progress - Personal Productivity Tools

**Date**: 2026-01-16  
**Status**: 🚧 **IN PROGRESS**  
**Phase**: 3 - Personal Productivity Tools  

## Overview

Phase 3 focuses on deploying personal productivity tools to enhance the brennan.page homelab functionality. This phase introduces a shared PostgreSQL database foundation and task management capabilities.

## Current Progress

### ✅ **Completed Deployments**

#### 1. PostgreSQL Database Foundation
- **Status**: ✅ **OPERATIONAL**
- **Version**: PostgreSQL 15 Alpine
- **Memory**: 256MB limit, 128MB reservation
- **Network**: `internal_db` network
- **Purpose**: Shared database for all Phase 3 services

**Configuration**:
```yaml
services:
  postgresql:
    image: postgres:15-alpine
    container_name: postgresql
    restart: unless-stopped
    environment:
      - POSTGRES_DB=homelab
      - POSTGRES_USER=homelab
      - POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./postgres_password:/run/secrets/postgres_password:ro
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - internal_db
    mem_limit: 256m
    mem_reservation: 128m
```

**Database Schema**:
- **Databases**: `vikunja`, `hedgedoc`, `linkding`, `navidrome`
- **Users**: Dedicated users for each service
- **Management**: Service configuration tracking, backup logs, user activity
- **Security**: Proper schema permissions and access controls

#### 2. Vikunja Task Management
- **Status**: ✅ **OPERATIONAL**
- **URL**: https://tasks.brennan.page
- **Version**: Latest (v1.0.0-rc3)
- **Memory**: 256MB limit, 128MB reservation
- **Database**: PostgreSQL `vikunja` database
- **Features**: Task management, project organization, user registration

**Configuration**:
```yaml
services:
  vikunja:
    image: vikunja/vikunja:latest
    container_name: vikunja
    restart: unless-stopped
    environment:
      - VIKUNJA_DATABASE_HOST=postgresql
      - VIKUNJA_DATABASE_TYPE=postgres
      - VIKUNJA_DATABASE_USER=vikunja
      - VIKUNJA_DATABASE_PASSWORD=vikunja_password
      - VIKUNJA_DATABASE_DATABASE=vikunja
      - VIKUNJA_SERVICE_URL=https://tasks.brennan.page
      - VIKUNJA_PUBLIC_URL=https://tasks.brennan.page
      - VIKUNJA_CORS_ENABLE=false
      - VIKUNJA_ENOBLEREGISTRATION=true
    volumes:
      - vikunja_files:/app/vikunja/files
    networks:
      - internal_db
      - caddy
    mem_limit: 256m
    mem_reservation: 128m
```

### 🚧 **Pending Deployments**

#### 3. HedgeDoc (notes.brennan.page)
- **Status**: 📋 **PLANNED**
- **Purpose**: Collaborative markdown notes
- **Database**: PostgreSQL `hedgedoc` database
- **Memory**: 100MB estimated

#### 4. Linkding (bookmarks.brennan.page)
- **Status**: 📋 **PLANNED**
- **Purpose**: Bookmark manager
- **Database**: PostgreSQL `linkding` database
- **Memory**: 50MB estimated

#### 5. Navidrome (music.brennan.page)
- **Status**: 📋 **PLANNED**
- **Purpose**: Music streaming service
- **Database**: PostgreSQL `navidrome` database
- **Memory**: 100MB estimated

## Technical Architecture

### Database Architecture
```
PostgreSQL Server (port 5432)
├── homelab (management database)
│   ├── service_configs (service tracking)
│   ├── backup_log (backup tracking)
│   └── user_activity (audit trail)
├── vikunja (task management)
├── hedgedoc (collaborative notes)
├── linkding (bookmark manager)
└── navidrome (music streaming)
```

### Network Configuration
```
internal_db Network
├── postgresql (database server)
├── vikunja (task management)
├── hedgedoc (collaborative notes)
├── linkding (bookmark manager)
└── navidrome (music streaming)

caddy Network
├── caddy (reverse proxy)
├── vikunja (task management)
├── hedgedoc (collaborative notes)
├── linkding (bookmark manager)
└── navidrome (music streaming)
```

### Service Integration
- **Database Connectivity**: All services connect via `internal_db` network
- **Web Access**: All services accessible via Caddy reverse proxy
- **Resource Management**: Memory limits enforced per service
- **Security**: Database users with limited privileges

## Resource Management

### Current Resource Usage
- **Total RAM**: 2GB
- **Used**: ~750MB (37%)
- **Available**: ~1.25GB for remaining services
- **Storage**: PostgreSQL data volume for persistence

### Service Resource Allocation
| Service | Memory Limit | Memory Reservation | Status |
|---------|---------------|-------------------|---------|
| PostgreSQL | 256MB | 128MB | ✅ Active |
| Vikunja | 256MB | 128MB | ✅ Active |
| HedgeDoc | 100MB | 50MB | 📋 Planned |
| Linkding | 50MB | 25MB | 📋 Planned |
| Navidrome | 100MB | 50MB | 📋 Planned |
| **Total** | **762MB** | **381MB** | **~38%** |

## Security Implementation

### Database Security
- **User Isolation**: Dedicated database users for each service
- **Schema Permissions**: Limited privileges per service
- **Password Management**: Secure password file mounting
- **Network Isolation**: Database only accessible via internal network

### Web Security
- **HTTPS Only**: All services accessible via HTTPS
- **Security Headers**: Caddy provides security headers
- **Network Segmentation**: Services isolated by network
- **Access Control**: User registration enabled where appropriate

## Deployment Process

### Local Development Workflow
1. **Local Configuration**: Create docker-compose.yml locally
2. **Database Setup**: Configure init.sql for database initialization
3. **Testing**: Validate configuration locally
4. **Version Control**: Commit changes to Git repository
5. **Remote Deployment**: Transfer files via rsync
6. **Service Start**: Start services via Docker Compose
7. **Validation**: Test service accessibility

### Deployment Commands
```bash
# Deploy PostgreSQL
rsync -avz services/postgresql/ root@server:/opt/homelab/services/postgresql/
ssh root@server "cd /opt/homelab/services/postgresql && docker compose up -d"

# Deploy Vikunja
rsync -avz services/vikunja/ root@server:/opt/homelab/services/vikunja/
ssh root@server "cd /opt/homelab/services/vikunja && docker compose up -d"

# Update Caddy
rsync caddy/Caddyfile root@server:/opt/homelab/caddy/Caddyfile
ssh root@server "cd /opt/homelab/caddy && docker compose restart"
```

## Troubleshooting

### Common Issues

#### Database Connection Issues
**Symptoms**: Service cannot connect to database
**Solutions**:
- Verify database user permissions
- Check network connectivity
- Validate environment variables
- Review PostgreSQL logs

#### Service Startup Issues
**Symptoms**: Container fails to start or restarts
**Solutions**:
- Check container logs for errors
- Verify memory limits
- Validate configuration files
- Check network connectivity

#### Caddy Proxy Issues
**Symptoms**: 503 errors or connection refused
**Solutions**:
- Verify service port configuration
- Check network connectivity
- Validate Caddyfile syntax
- Review Caddy logs

### Debugging Commands
```bash
# Check container status
docker ps | grep -E "(postgresql|vikunja)"

# Check service logs
docker logs postgresql --tail 20
docker logs vikunja --tail 20

# Test database connectivity
docker exec postgresql psql -U homelab -d homelab -c "SELECT * FROM service_configs;"

# Test service connectivity
docker exec caddy wget -qO- http://vikunja:3456

# Check resource usage
docker stats postgresql vikunja
```

## Performance Monitoring

### Database Performance
- **Connection Pooling**: Managed by application layer
- **Query Optimization**: Indexes created for common queries
- **Resource Usage**: Monitored via Docker stats
- **Backup Strategy**: Automated backup procedures planned

### Service Performance
- **Response Times**: Monitored via Caddy logs
- **Resource Limits**: Enforced via Docker
- **Health Checks**: Service health monitoring
- **User Activity**: Tracked via database audit trail

## Next Steps

### Immediate Tasks
1. **Deploy HedgeDoc**: Collaborative notes system
2. **Deploy Linkding**: Bookmark manager
3. **Deploy Navidrome**: Music streaming service
4. **Update Documentation**: Complete service documentation
5. **Performance Testing**: Validate resource usage

### Future Enhancements
- **Backup Automation**: Automated database backups
- **Monitoring Dashboard**: Enhanced service monitoring
- **User Management**: Centralized user authentication
- **API Integration**: Service-to-service communication

## Validation

### Service Accessibility
- **PostgreSQL**: ✅ Internal access verified
- **Vikunja**: ✅ https://tasks.brennan.page accessible
- **Caddy**: ✅ Proxy configuration working
- **Network**: ✅ Inter-service connectivity verified

### Database Validation
- **Schema Creation**: ✅ All databases and users created
- **Permissions**: ✅ Proper access controls configured
- **Connectivity**: ✅ Services can connect to databases
- **Data Integrity**: ✅ Initial data populated correctly

---

**Last Updated**: 2026-01-16  
**Next Review**: After Phase 3 completion  
**Phase Owner**: brennan.page Homelab
