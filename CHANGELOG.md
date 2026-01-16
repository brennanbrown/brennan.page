# Changelog

All notable changes to brennan.page homelab will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Planned Phase 2-6 service deployments
- Comprehensive documentation structure
- Backup and monitoring automation plans

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

## [0.1.0] - 2026-01-16

### Added
- **Repository Structure**: Complete mono-repo layout with proper organization
- **SSH Configuration**: Secure SSH access with key-based authentication
- **Docker Infrastructure**: 
  - Docker and Docker Compose installation
  - Network setup (caddy, internal_db, monitoring)
  - Container resource limits and logging
- **Security**:
  - UFW firewall configuration (ports 22, 2222, 80, 443)
  - SSH key authentication
  - Basic security headers via Caddy
- **Reverse Proxy**:
  - Caddy configuration with automatic HTTPS
  - HTTP/2 and HTTP/3 support
  - Compression and security headers
  - Subdomain routing for all planned services
- **Core Services**:
  - **Portainer** (docker.brennan.page) - Docker management UI
  - **FileBrowser** (files.brennan.page) - File management interface
  - **Glances** (monitor.brennan.page) - System monitoring (partial)
- **Landing Page**: 
  - Modern dark theme landing page at brennan.page
  - Service status overview
  - System information display
- **Automation**:
  - Backup scripts with automated daily execution
  - Health check scripts for service monitoring
  - Deployment scripts for infrastructure management
- **Documentation**:
  - Comprehensive README with setup instructions
  - SSH reference documentation
  - Service specification document
  - MkDocs wiki structure (ready for deployment)

### Changed
- N/A

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- **Caddy Volume Mount**: Fixed web directory mounting for landing page
- **SSH Host Key**: Resolved SSH host key verification issues
- **Docker Networks**: Created proper network isolation for services

### Security
- Configured UFW firewall with essential ports
- Implemented SSH key-based authentication
- Added security headers via Caddy configuration
- Set up proper file permissions for sensitive directories

---

## [0.0.1] - 2026-01-16 (Planning)

### Added
- Initial project specification document
- Repository structure planning
- Service architecture design
- Development workflow documentation

---

## Project Phases

### Phase 1 - Foundation ✅ (COMPLETED)
**Date**: 2026-01-16  
**Status**: Complete  

**Deliverables**:
- ✅ Server setup and security configuration
- ✅ Docker infrastructure and networking
- ✅ Reverse proxy with SSL termination
- ✅ Core management services (Portainer, FileBrowser)
- ✅ Landing page and basic monitoring
- ✅ Backup and deployment automation

**Services Deployed**:
- Caddy (reverse proxy)
- Portainer (Docker management)
- FileBrowser (file management)
- Glances (system monitoring - partial)

**Resource Usage**:
- Memory: ~500MB / 2GB (25%)
- Storage: ~3GB / 67GB (5%)
- All services running with proper resource limits

### Phase 2 - Monitoring & Documentation 🚧 (IN PROGRESS)
**Target Date**: 2026-01-23  
**Status**: In Progress  

**Planned Deliverables**:
- 🔄 Fix Glances web interface configuration
- 📋 Deploy MkDocs wiki (wiki.brennan.page)
- 📋 Complete service documentation
- 📋 Set up comprehensive monitoring dashboards
- 📋 Configure alerting system

### Phase 3 - Personal Productivity 📋 (PLANNED)
**Target Date**: 2026-01-30  
**Status**: Planned  

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
