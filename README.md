# brennan.page Homelab

Self-hosted infrastructure on DigitalOcean showcasing backend/cloud development skills while providing personal productivity tools and community-building features.

## 🌐 Live Services

### Core Infrastructure
- **brennan.page** - Modern landing page with service status dashboard
- **docker.brennan.page** - Portainer Docker management UI
- **monitor.brennan.page** - Enhanced system monitoring with real-time stats
- **files.brennan.page** - FileBrowser file management interface
- **wiki.brennan.page** - Git-backed static documentation wiki

### Productivity Suite
- **tasks.brennan.page** - Vikunja task management system
- **notes.brennan.page** - HedgeDoc collaborative markdown editing
- **bookmarks.brennan.page** - Linkding bookmark manager
- **music.brennan.page** - Navidrome music streaming service

### Community Platforms
- **blog.brennan.page** - WriteFreely minimalist blogging platform
- **forum.brennan.page** - Flarum community discussion forum
- **rss.brennan.page** - FreshRSS feed aggregator

## 🚀 Quick Start

This repository contains the complete infrastructure configuration for brennan.page homelab. The structure follows the specification in `docs/spec-sheet.md`.

### Repository Structure

```
homelab/
├── .gitignore
├── README.md
├── landing.html              # Main landing page
├── caddy/                    # Reverse proxy configuration
│   ├── Caddyfile
│   └── docker-compose.yml
├── services/                 # Individual service configurations
│   ├── portainer/            # Docker management
│   ├── monitor/              # Enhanced monitoring dashboard
│   ├── filebrowser/          # File management
│   ├── postgresql/           # Shared database
│   ├── vikunja/              # Task management
│   ├── hedgedoc/             # Collaborative notes
│   ├── linkding/             # Bookmark manager
│   ├── navidrome/            # Music streaming
│   ├── writefreely/          # Blogging platform
│   ├── flarum/               # Community forum
│   ├── freshrss/             # RSS aggregator
│   └── glances/              # Legacy monitoring
├── wiki/                     # Git-backed static wiki (MkDocs)
│   ├── mkdocs.yml
│   ├── docs/
│   └── deploy-wiki.sh
├── scripts/                  # Automation and utility scripts
│   ├── backup.sh
│   ├── health-check.sh
│   ├── deploy-service.sh
│   └── deploy-all.sh
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

## 📊 System Overview

### Infrastructure Stack
- **Server**: DigitalOcean 2GB RAM/1CPU/70GB Disk - Ubuntu 24.04 LTS
- **Reverse Proxy**: Caddy 2 with automatic HTTPS
- **Containerization**: Docker & Docker Compose
- **Database**: PostgreSQL 16 with multi-service architecture
- **Monitoring**: Custom dashboard with real-time metrics

### Resource Usage
- **Memory Usage**: ~800MB (40% of 2GB allocation)
- **Storage Usage**: ~3.4GB (5% of 70GB allocation)
- **Active Services**: 11 containers running
- **Response Times**: All services under 200ms

## 🛠️ Getting Started

1. Review `docs/spec-sheet.md` for complete architecture overview
2. Set up local development environment
3. Configure SSH access to the server (see `docs/ssh-reference.md`)
4. Begin with Phase 1: Foundation services (Caddy, Docker, Portainer)

### SSL Certificate Monitoring

Use the SSL health check script to monitor certificate status and prevent issues:

```bash
# Run SSL health check
./scripts/ssl-health-check.sh

# Or run directly on server
ssh -i ~/.omg-lol-keys/id_ed25519 -T -o BatchMode=yes root@159.203.44.169 "/opt/homelab/scripts/ssl-health-check.sh"
```

For troubleshooting SSL issues, see: https://wiki.brennan.page/troubleshooting/ssl-issues/

### Phase-Based Deployment

**Phase 1**: Core Infrastructure (Caddy, Docker, Portainer)
**Phase 2**: Monitoring & Documentation (Monitor, Wiki)
**Phase 3**: Productivity Suite (Tasks, Notes, Bookmarks, Music)
**Phase 4**: Community Platforms (Blog, Forum, RSS)

## 📚 Documentation

Complete documentation is maintained in the `docs/` directory and deployed to `wiki.brennan.page`.

### Key Documentation
- **[Wiki](https://wiki.brennan.page)** - Complete service documentation
- **[SSH Reference](./docs/ssh-reference.md)** - Server management commands
- **[Configuration Guide](./wiki/docs/configuration/)** - Service configuration
- **[Operations Guide](./wiki/docs/operations/)** - Deployment and maintenance

## 📈 Project Tracking

- **[CHANGELOG.md](./CHANGELOG.md)** - Detailed history of changes and releases
- **[TODO.md](./TODO.md)** - Current tasks, priorities, and roadmap

## 🔧 Recent Updates (v0.3.0)

### Enhanced Monitoring Dashboard
- **Real-time System Stats**: Memory, disk, CPU, network metrics
- **Visual Progress Bars**: Color-coded resource usage indicators
- **Service Health Checks**: Automated status monitoring for all 11 services
- **Response Time Tracking**: Performance monitoring with detailed metrics

### Modern Landing Page
- **Complete UI Overhaul**: From simple text to modern styled interface
- **Service Cards**: Interactive cards with status indicators
- **System Statistics**: Real-time resource usage display
- **Responsive Design**: Mobile-friendly layout

### Productivity Suite Integration
- **Task Management**: Vikunja with PostgreSQL backend
- **Collaborative Notes**: HedgeDoc with real-time editing
- **Bookmark Management**: Linkding with clean interface
- **Music Streaming**: Navidrome with personal library

---

**Domain**: brennan.page  
**Management**: Local development + SSH deployment
**Version**: 0.3.0 (Production)  
**Last Updated**: 2026-01-16
