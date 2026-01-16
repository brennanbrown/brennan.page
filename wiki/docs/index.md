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

## Service Status

| Service | Subdomain | Status | Priority |
|---------|-----------|--------|----------|
| Caddy | - | 🟢 Critical | Foundation |
| Portainer | docker.brennan.page | 🟢 High | Management |
| Glances | monitor.brennan.page | 🟢 High | Monitoring |
| FileBrowser | files.brennan.page | 🟢 Medium | File Management |
| Wiki | wiki.brennan.page | 🟢 High | Documentation |

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
