# Deployments

This section documents the deployment phases and procedures for the brennan.page homelab.

## Deployment Overview

The homelab deployment follows a phased approach to ensure stability and proper testing at each stage.

## Deployment Phases

### Phase 1: Foundation Services ✅
**Status**: Complete  
**Timeline**: Initial Setup  
**Services**: Caddy, Docker, Portainer, Monitoring

#### Completed Tasks
- [x] Server setup and security hardening
- [x] Docker and Docker Compose installation
- [x] Caddy reverse proxy configuration
- [x] Portainer Docker management
- [x] Enhanced Monitor system monitoring
- [x] SSL certificate automation
- [x] Backup system implementation

#### Key Achievements
- Secure server with UFW firewall and fail2ban
- Automated SSL certificates via Let's Encrypt
- Container orchestration with Docker
- Web-based Docker management
- Real-time system monitoring

### Phase 2: Core Services ✅
**Status**: Complete  
**Timeline**: Week 2-3  
**Services**: PostgreSQL, FileBrowser, Wiki

#### Completed Tasks
- [x] PostgreSQL database server
- [x] FileBrowser file management
- [x] MkDocs wiki platform
- [x] Database backup procedures
- [x] Service monitoring integration

#### Key Achievements
- Centralized database for all services
- Secure file management interface
- Comprehensive documentation platform
- Automated backup procedures

### Phase 3: Productivity Services 🚧
**Status**: In Progress  
**Timeline**: Week 4-5  
**Services**: Vikunja, HedgeDoc, Linkding, Navidrome

#### Current Progress
- [x] Vikunja task management
- [x] HedgeDoc collaborative notes
- [x] Linkding bookmark manager
- [x] Navidrome music streaming
- [x] Database integration
- [x] Service configuration
- [ ] Performance optimization
- [ ] User acceptance testing

#### Known Issues
- Navidrome library scanning performance
- HedgeDoc plugin configuration
- Service resource optimization

### Phase 4: Community Services 📋
**Status**: Planned  
**Timeline**: Week 6-7  
**Services**: WriteFreely, Flarum, FreshRSS

#### Planned Tasks
- [ ] WriteFreely blog platform
- [ ] Flarum community forum
- [ ] FreshRSS RSS reader
- [ ] User registration systems
- [ ] Content moderation setup
- [ ] Performance testing

### Phase 5: Advanced Services 📋
**Status**: Planned  
**Timeline**: Week 8+  
**Services**: Plik, Rallly, Analytics

#### Planned Tasks
- [ ] Plik file sharing
- [ ] Rallly poll scheduling
- [ ] Analytics platform
- [ ] Advanced monitoring
- [ ] Performance optimization
- [ ] Security hardening

## Deployment Procedures

### Pre-Deployment Checklist
- [ ] Review service requirements
- [ ] Check resource availability
- [ ] Backup current configuration
- [ ] Test in staging environment
- [ ] Prepare rollback plan

### Deployment Steps
1. **Configuration Preparation**
   ```bash
   # Create service directory
   mkdir -p /opt/homelab/services/newservice
   
   # Copy configuration files
   rsync -avz ~/homelab/services/newservice/ /opt/homelab/services/newservice/
   ```

2. **Service Deployment**
   ```bash
   # Deploy service
   cd /opt/homelab/services/newservice
   docker compose pull
   docker compose up -d
   
   # Verify deployment
   docker ps | grep newservice
   docker logs newservice
   ```

3. **Network Configuration**
   ```bash
   # Update Caddy configuration
   # Download current Caddyfile
   scp -i ~/.omg-lol-keys/id_ed25519 root@159.203.44.169:/opt/homelab/caddy/Caddyfile ./Caddyfile
   
   # Edit and upload
   # Add new service configuration
   scp -i ~/.omg-lol-keys/id_ed25519 ./Caddyfile root@159.203.44.169:/opt/homelab/caddy/Caddyfile
   
   # Reload Caddy
   docker exec caddy caddy reload --config /etc/caddy/Caddyfile
   ```

4. **Verification**
   ```bash
   # Test service endpoint
   curl -I https://newservice.brennan.page
   
   # Check service health
   docker exec newservice curl -f http://localhost:port/health
   ```

### Post-Deployment Checklist
- [ ] Verify service functionality
- [ ] Check resource usage
- [ ] Test backup procedures
- [ ] Update monitoring
- [ ] Update documentation
- [ ] Train users (if applicable)

## Deployment Tools

### Automation Scripts
- **deploy-service.sh**: Automated service deployment
- **backup.sh**: Backup procedures
- **health-check.sh**: Service health monitoring

### Configuration Management
- **Git**: Version control for all configurations
- **Docker Compose**: Service orchestration
- **Environment Files**: Service-specific configurations

### Monitoring Tools
- **Enhanced Monitor**: System monitoring
- **Docker Stats**: Container monitoring
- **Health Checks**: Service health monitoring

## Deployment Standards

### Code Standards
- All configurations in Git
- Environment-specific configs
- Proper documentation
- Security best practices

### Resource Standards
- Memory limits for all services
- CPU limits where applicable
- Storage quotas
- Network isolation

### Security Standards
- SSL/TLS for all web services
- Database encryption
- User authentication
- Access logging

## Deployment Troubleshooting

### Common Issues
- **Service Won't Start**: Check logs and resource limits
- **Network Access**: Verify Caddy configuration
- **Database Issues**: Check database connectivity
- **SSL Problems**: Verify certificate configuration

### Troubleshooting Commands
```bash
# Check service status
docker ps | grep service_name

# Check service logs
docker logs service_name --tail 50

# Check resource usage
docker stats service_name

# Test connectivity
curl -I https://service.brennan.page

# Check database connectivity
docker exec postgres psql -U user -d database -c "SELECT 1;"
```

## Deployment Metrics

### Success Metrics
- Service uptime > 99%
- Response time < 2 seconds
- Resource usage within limits
- Backup success rate 100%

### Monitoring Metrics
- Service availability
- Response times
- Error rates
- Resource utilization

## Deployment History

### Recent Deployments
- **2026-01-16**: FileBrowser authentication fix
- **2026-01-15**: Navidrome music streaming
- **2026-01-14**: Linkding bookmark manager
- **2026-01-13**: HedgeDoc collaborative notes
- **2026-01-12**: Vikunja task management

### Deployment Statistics
- **Total Deployments**: 15
- **Success Rate**: 93%
- **Average Deployment Time**: 15 minutes
- **Rollback Rate**: 7%

## References

- [Services](../services/) - Service documentation
- [Infrastructure](../infrastructure/) - Infrastructure documentation
- [Operations](../operations/) - Operational procedures
- [Troubleshooting](../troubleshooting/) - Troubleshooting guides
