# Getting Started

This guide will help you get familiar with the brennan.page homelab infrastructure and development workflow.

## Prerequisites

### Local Development Environment

- **Git**: For version control
- **Docker**: For local testing (optional but recommended)
- **SSH Client**: For server access
- **Text Editor**: VS Code, micro, or your preferred editor

### Server Access

- SSH key configured for `root@159.203.44.169`
- Domain `brennan.page` pointing to the server IP
- Basic understanding of Linux command line

## Development Workflow

### 1. Local Development

All configuration changes are made locally first:

```bash
# Clone the repository
git clone https://github.com/brennanbrown/brennan.page.git
cd brennan.page

# Make your changes
# Edit docker-compose files, documentation, etc.

# Test configurations locally (when possible)
docker compose config
```

### 2. Version Control

Commit your changes with descriptive messages:

```bash
git add .
git commit -m "Add/update service-name: description of changes"
git push
```

### 3. Deployment

Use the deployment scripts to sync to the server:

```bash
# Sync all configurations
./scripts/deploy-all.sh

# Or deploy specific service
./scripts/deploy-service.sh portainer
```

### 4. Service Management

Manage services on the server:

```bash
# SSH into server
ssh -i ~/.omg-lol-keys/id_ed25519 root@159.203.44.169

# Check service status
docker ps

# View logs
docker logs portainer

# Restart service
cd /opt/homelab/services/portainer
docker compose restart
```

## First Steps

### 1. Set Up Docker Networks

```bash
# On the server
./scripts/setup-networks.sh
```

### 2. Deploy Caddy (Foundation)

```bash
# Deploy Caddy configuration
rsync -avz caddy/ root@159.203.44.169:/opt/homelab/caddy/

# Start Caddy
ssh root@159.203.44.169 "cd /opt/homelab/caddy && docker compose up -d"
```

### 3. Deploy Core Services

```bash
# Deploy Portainer
./scripts/deploy-service.sh portainer

# Deploy Enhanced Monitor
./scripts/deploy-service.sh monitor

# Deploy FileBrowser
./scripts/deploy-service.sh filebrowser
```

### 4. Deploy Wiki

```bash
# Build and deploy wiki
cd wiki
./deploy-wiki.sh
```

## Directory Structure

```
brennan.page/
├── caddy/                    # Reverse proxy configuration
├── services/                 # Individual service configurations
│   ├── portainer/
│   ├── monitor/
│   └── filebrowser/
├── wiki/                     # Documentation (MkDocs)
├── scripts/                  # Deployment and utility scripts
└── docs/                     # Internal documentation
```

## Common Commands

### Docker Operations

```bash
# List all containers
docker ps -a

# View resource usage
docker stats

# View logs
docker logs <container_name>

# Restart service
docker compose restart
```

### File Operations

```bash
# Sync files to server
rsync -avz --exclude '.git' ./ root@159.203.44.169:/opt/homelab/

# Download files from server
scp -r root@159.203.44.169:/opt/homelab/backups/ ./
```

### System Monitoring

```bash
# Check system resources
free -h
df -h
htop

# Check service status
systemctl status docker
ufw status
```

## Troubleshooting

### Service Won't Start

1. Check logs: `docker logs <service>`
2. Verify configuration: `docker compose config`
3. Check resource usage: `docker stats`
4. Verify ports: `netstat -tulpn | grep <port>`

### Can't Access Service

1. Check Caddy logs: `docker logs caddy`
2. Verify DNS resolution
3. Check firewall rules: `ufw status`
4. Test locally: `curl -I http://localhost:<port>`

### Out of Memory

1. Check memory usage: `free -h`
2. Identify heavy containers: `docker stats`
3. Restart heavy services
4. Verify swap is active: `swapon -s`

## Next Steps

1. Read the [Architecture Overview](home/architecture.md)
2. Review [Service Documentation](services/)
3. Check [Deployment Procedures](deployments/)
4. Set up [Monitoring](operations/daily-checks.md)

## Getting Help

- **Documentation**: This wiki is your primary resource
- **Service Logs**: Check Docker logs for service-specific issues
- **System Status**: Visit `monitor.brennan.page` for real-time stats
- **SSH Reference**: See [SSH Commands](reference/ssh-commands.md)

---

*Remember: Always test locally before deploying to production!*
