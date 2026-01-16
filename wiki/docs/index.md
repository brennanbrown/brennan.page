# brennan.page Wiki

Welcome to the brennan.page homelab documentation. This wiki contains comprehensive information about the self-hosted infrastructure, services, and operational procedures.

## Quick Navigation

- **[Getting Started](home/getting-started.md)** - New to the homelab? Start here
- **[Services](services/)** - Detailed documentation for each service
- **[Deployments](deployments/)** - Deployment phases and procedures
- **[Operations](operations/)** - Daily, weekly, and monthly maintenance tasks
- **[Troubleshooting](troubleshooting/)** - Common issues and solutions

## Overview

brennan.page is a self-hosted homelab running on a DigitalOcean droplet (2GB RAM, 1 CPU, 70GB disk) with Ubuntu 24.04 LTS. The infrastructure showcases backend/cloud development skills while providing personal productivity tools and community-building features.

### Key Features

- **Infrastructure as Code**: All configurations tracked in Git
- **Local-First Development**: All changes authored and tested locally
- **Automated Deployment**: Scripts for reliable service deployment
- **Resource Monitoring**: Continuous monitoring with Glances
- **Comprehensive Documentation**: This Git-backed static wiki

### Architecture Highlights

- **Reverse Proxy**: Caddy with automatic HTTPS
- **Container Runtime**: Docker with resource limits
- **Network Segmentation**: Isolated networks for different service categories
- **Backup Strategy**: Automated backups with rotation
- **Security**: UFW firewall, fail2ban, SSH key authentication

## Recent Updates

### Phase 3 Progress (2026-01-16)
- **PostgreSQL Database**: Shared database foundation deployed
- **Vikunja Task Management**: Task management system operational
- **Database Integration**: All services connected to PostgreSQL
- **Security Implementation**: Proper user permissions and network isolation
- **Next**: HedgeDoc, Linkding, Navidrome deployment

### Phase 2 Completion (2026-01-16)
- **Monitoring Service**: Replaced Glances with custom monitoring solution
- **Documentation Wiki**: Deployed comprehensive MkDocs documentation
- **All Services**: 5/5 services operational
- **Resource Efficiency**: Maintained within 2GB limit

### Phase 1 Foundation (2026-01-16)
- **Infrastructure Setup**: Docker, Caddy, networking
- **Core Services**: Portainer, FileBrowser, monitoring
- **Landing Page**: Modern dark theme interface
- **Security**: UFW firewall, SSH configuration
- **Automation**: Backup and health check scripts

## Service Status

| Service | Subdomain | Status | Priority | Description |
|---------|-----------|--------|----------|-------------|
| Caddy | - | 🟢 Critical | Foundation | Reverse proxy with SSL |
| Portainer | docker.brennan.page | 🟢 High | Management | Docker management UI |
| Monitor | monitor.brennan.page | 🟢 High | Monitoring | System monitoring dashboard |
| FileBrowser | files.brennan.page | 🟢 Medium | File Management | File management interface |
| Wiki | wiki.brennan.page | 🟢 High | Documentation | MkDocs documentation |
| PostgreSQL | - | 🟢 Critical | Database | Shared database for Phase 3 |
| Vikunja | tasks.brennan.page | 🟢 Medium | Productivity | Task management system |

## Resource Usage

- **Total RAM**: 2GB
- **Allocated**: ~1.4GB
- **Available Buffer**: ~600MB
- **Swap**: 4GB configured

## Getting Help

1. **Check the Wiki**: Most questions are answered in these documents
2. **Review Logs**: Use `docker logs <service>` for service-specific issues
3. **Check Status**: Visit `monitor.brennan.page` for system overview
4. **SSH Reference**: See [SSH Commands](reference/ssh-commands.md) for server management

---

*Last updated: {{ git_revision_date_localized }}*
