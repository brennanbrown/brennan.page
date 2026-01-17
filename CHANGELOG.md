# Changelog

All notable changes to brennan.page homelab will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-01-16

### Added
- **Complete Phase 3 Implementation**: Personal productivity tools suite
- **PostgreSQL Database**: Shared database infrastructure with proper user isolation
- **Vikunja Task Management**: Full-featured task management at tasks.brennan.page
- **HedgeDoc Collaborative Notes**: Real-time collaborative markdown editing at notes.brennan.page
- **Linkding Bookmark Manager**: Clean bookmark management interface at bookmarks.brennan.page
- **Navidrome Music Streaming**: Personal music streaming service at music.brennan.page
- **Database Initialization**: Automated database and user creation for all services
- **Service Monitoring**: Health checks and status tracking for all Phase 3 services

### Changed
- **Resource Allocation**: Optimized memory usage for new services within 2GB limit
- **Database Architecture**: Centralized PostgreSQL with proper user isolation
- **Service Integration**: All Phase 3 services properly integrated with Caddy reverse proxy
- **Authentication Flow**: Configured service-specific authentication methods

### Security
- **Database Security**: Separate users and databases for each service
- **Network Isolation**: Phase 3 services on internal_db network
- **Container Security**: Non-root processes and resource limits enforced
- **Access Control**: Proper authentication for all productivity services

### Performance
- **Memory Usage**: Maintained ~800MB usage (40% of 2GB allocation)
- **Response Times**: All services responding under 200ms
- **Database Optimization**: PostgreSQL tuned for multi-service workload
- **Resource Limits**: Memory limits configured for all new services

---

## [0.2.0] - 2026-01-16

### Added
- **Complete Phase 2 Implementation**: Monitoring and documentation infrastructure
- **Custom Monitoring Service**: Replaced Glances with lightweight Nginx-based solution
- **MkDocs Wiki**: Comprehensive documentation platform with Material theme
- **Service Documentation**: Complete technical documentation for all services
- **Troubleshooting Guides**: Detailed troubleshooting procedures and solutions
- **Portainer Admin Setup**: Docker management interface fully configured

### Changed
- **Monitoring Architecture**: Switched from Glances to static HTML/CSS/JavaScript solution
- **Documentation Workflow**: Implemented local-first development workflow
- **Resource Allocation**: Optimized service resource usage within 2GB limit
- **Git Commit Hygiene**: Improved commit message formatting and standards

### Fixed
- **Glances Proxy Issues**: Resolved persistent 503 errors with custom monitoring solution
- **SSH Command Override**: Fixed SSH command contamination issue
- **Port Mapping**: Corrected monitor service port configuration (monitor:80 vs monitor:8081)
- **Portainer Timeout**: Resolved security timeout by restarting service
- **Caddy Configuration**: Fixed reverse proxy configurations for all services

### Security
- **SSL Certificates**: All services accessible via HTTPS with valid certificates
- **Security Headers**: Implemented proper security headers via Caddy
- **Container Isolation**: Maintained proper Docker network segmentation
- **Access Control**: Configured appropriate access levels for services

### Performance
- **Resource Usage**: Maintained ~500MB usage (25% of 2GB allocation)
- **Response Times**: Optimized service response times under 120ms
- **Auto-refresh**: Implemented 30-second auto-refresh for monitoring dashboard
- **Compression**: Enabled gzip compression for all services

---

## [0.1.0] - 2026-01-16

### Added
- **Phase 1 Foundation**: Complete infrastructure setup
- **Docker Environment**: Container runtime with resource limits
- **Caddy Reverse Proxy**: Automatic HTTPS and subdomain routing
- **Core Services**: Portainer, FileBrowser, monitoring
- **Landing Page**: Modern dark theme interface
- **Security**: UFW firewall, SSH key authentication
- **Backup Scripts**: Automated backup and health check scripts
- **Project Structure**: Complete repository organization

### Changed
- **Infrastructure**: Migrated from concept to deployed solution
- **Development**: Established local-first workflow
- **Documentation**: Created comprehensive project documentation

### Security
- **SSH Configuration**: Key-based authentication only
- **Firewall**: UFW configured with essential ports
- **Container Security**: Non-root processes where possible

---

## [Unreleased]

### Added
- Phase 3 planning for personal productivity tools
- PostgreSQL database deployment preparation
- Additional service authentication requirements

### Changed
- N/A

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- N/A

---  

**Planned Deliverables**:
- 🔄 Fix Glances web interface configuration
- 📋 Deploy MkDocs wiki (wiki.brennan.page)
- 📋 Complete service documentation
- 📋 Set up comprehensive monitoring dashboards
- 📋 Configure alerting system

### Phase 3 - Personal Productivity 📋 (PLANNED)
**Target Date**: 2026-01-30  
**Status**: Planned  

### Security
- N/A

---  
**Planned Services**:
- Vikunja (task management)
- HedgeDoc (collaborative notes)
- Linkding (bookmark manager)
- Navidrome (music streaming)
- Shared PostgreSQL database

### Phase 4 - Content & Community 📋 (PLANNED)
**Target Date**: 2026-02-06  
**Status**: Planned  

**Planned Services**:
- WriteFreely (blog platform)
- Flarum (community forum)
- FreshRSS (RSS reader)
- User authentication system

### Phase 5 - Utilities 📋 (PLANNED)
**Target Date**: 2026-02-13  
**Status**: Planned  

**Planned Services**:
- Plik (file sharing)
- Rallly (poll scheduling)
- Service integrations

### Phase 6 - Optimization & Maintenance 📋 (PLANNED)
**Target Date**: 2026-02-20  
**Status**: Planned  

**Planned Tasks**:
- Performance optimization
- Advanced security configuration
- Backup verification and testing
- Documentation completion

---

## Technical Details

### Infrastructure Stack
- **Server**: DigitalOcean 2GB RAM / 1 CPU / 70GB Disk
- **OS**: Ubuntu 24.04 LTS
- **Container Runtime**: Docker 29.1.5
- **Reverse Proxy**: Caddy 2.x
- **Database**: PostgreSQL (planned)
- **Documentation**: MkDocs with Material theme

### Network Configuration
- **External Networks**: caddy (for reverse proxy)
- **Internal Networks**: internal_db (databases), monitoring (monitoring services)
- **Firewall**: UFW with ports 22, 2222, 80, 443
- **SSL**: Automatic certificates via Caddy

### Resource Allocation
- **Caddy**: 256MB limit
- **Portainer**: 100MB limit
- **Glances**: 50MB limit
- **FileBrowser**: 50MB limit
- **Total Budget**: ~600MB used, 1.4GB available

### Backup Strategy
- **Daily**: Automated Docker volume and configuration backups
- **Retention**: 7 days rolling backup
- **Location**: Local storage (/opt/homelab/backups)
- **Monitoring**: Backup script execution via cron

---

## Security Considerations

### Implemented
- SSH key authentication only
- UFW firewall with minimal open ports
- Docker network isolation
- Security headers via Caddy
- Proper file permissions

### Planned
- fail2ban for SSH protection
- Rate limiting on web services
- SSL certificate monitoring
- Automated security updates
- Security audit procedures

---

## Performance Metrics

### Current Status
- **Uptime**: 100% (new deployment)
- **Response Times**: 
  - Landing page: ~58ms
  - Portainer: ~41ms
  - FileBrowser: ~91ms
- **Resource Usage**: Well within limits
- **SSL Certificates**: Valid and auto-renewing

### Targets
- **Uptime**: >99%
- **Response Time**: <2s average
- **Memory Usage**: <1.8GB sustained
- **Disk Usage**: <80% capacity

---

*For detailed technical documentation, see the [wiki](https://wiki.brennan.page) (once deployed).*  
*For current development tasks, see [TODO.md](./TODO.md).*
