# brennan.page Homelab

Self-hosted infrastructure on DigitalOcean showcasing backend/cloud development skills while providing personal productivity tools and community-building features.

## Quick Start

This repository contains the complete infrastructure configuration for brennan.page homelab. The structure follows the specification in `docs/spec-sheet.md`.

### Repository Structure

```
homelab/
├── .gitignore
├── README.md
├── caddy/                    # Reverse proxy configuration
│   ├── Caddyfile
│   └── docker-compose.yml
├── wiki/                     # Git-backed static wiki (MkDocs)
│   ├── mkdocs.yml
│   ├── docs/
│   └── deploy-wiki.sh
├── services/                 # Individual service configurations
│   ├── writefreely/
│   ├── flarum/
│   ├── vikunja/
│   └── [other services]/
├── scripts/                  # Automation and utility scripts
│   ├── backup.sh
│   ├── health-check.sh
│   └── deploy-service.sh
└── docs/                     # Internal development documentation
    ├── ssh-reference.md
    ├── basic-info.md
    └── spec-sheet.md
```

### Deployment Workflow

1. **Local Development**: All configurations are authored and tested locally
2. **Git Version Control**: Track all changes in version control
3. **Remote Deployment**: Use `rsync` to sync files to the server
4. **Service Management**: Use Docker Compose to manage services

### Key Services

- **brennan.page** - Landing page with service status
- **wiki.brennan.page** - Git-backed static documentation wiki
- **docker.brennan.page** - Portainer Docker management UI
- **monitor.brennan.page** - Glances system monitoring
- **files.brennan.page** - FileBrowser file management

### Getting Started

1. Review `docs/spec-sheet.md` for complete architecture overview
2. Set up local development environment
3. Configure SSH access to the server (see `docs/ssh-reference.md`)
4. Begin with Phase 1: Foundation services (Caddy, Docker, Portainer)

### Documentation

Complete documentation is maintained in the `docs/` directory and deployed to `wiki.brennan.page`.

### Project Tracking

- **[CHANGELOG.md](./CHANGELOG.md)** - Detailed history of changes and releases
- **[TODO.md](./TODO.md)** - Current tasks, priorities, and roadmap

---

**Server**: DigitalOcean 2GB RAM/1CPU/70GB Disk - Ubuntu 24.04 LTS  
**Domain**: brennan.page  
**Management**: Local development + SSH deployment via AI-assisted coding
