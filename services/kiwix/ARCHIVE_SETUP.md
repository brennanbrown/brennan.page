# Kiwix Archive & Mirrors Setup

This document describes the setup for the Kiwix Archive and Mirrors services.

## Overview

The archive system consists of two main services:

1. **Kiwix Archive Service** (`archive.brennan.page`)
   - Serves Kiwix ZIM archives via kiwix-serve
   - Provides a beautiful homepage with organized archive collection
   - Runs on port 8082 (proxied through Caddy)

2. **Mirrors Service** (`mirrors.brennan.page`)
   - Simple nginx-based landing page
   - Provides navigation to archive services
   - Runs on port 8083 (proxied through Caddy)

## Features

### Archive Homepage
- **47 Archives**: Technical documentation, encyclopedias, educational content
- **7 Categories**: Technical Documentation, Encyclopedias, Education, Medical, Tools & Utilities, General Knowledge
- **Beautiful UI**: Modern gradient design with responsive layout
- **Direct Links**: View and download links for each archive
- **Search & Filter**: Easy navigation through categorized content

### Archive Categories
- **Technical Documentation** (27 archives): DevDocs for various technologies, Python docs, PHP documentation
- **Encyclopedias** (5 archives): Wikipedia variants, Project Gutenberg, Citizendium
- **Education** (4 archives): freeCodeCamp, TED Talks
- **Medical** (3 archives): MedlinePlus, Medical guides
- **Tools & Utilities** (2 archives): OpenStreetMap Wiki, Termux
- **General Knowledge** (6 archives): Various educational and reference materials

## URL Conversion

The `convert_urls.py` script converts Kiwix viewer URLs to the proper format:

```bash
python3 scripts/convert_urls.py "Docker KiwiX URLs.txt" archive_homepage.html
```

**Input Format:**
```
https://browse.library.kiwix.org/viewer#php.net_en_all_2024-08
```

**Output Format:**
- **Viewer URL**: `https://browse.library.kiwix.org/viewer#php.net_en_all_2024-08`
- **Download URL**: `https://download.kiwix.org/zim/zimit/php.net_en_all_2024-08.zim`
- **Readable Name**: "PHP Documentation"
- **Category**: "Technical Documentation"

## Deployment

### Quick Deploy
```bash
./scripts/deploy_archives.sh
```

### Manual Deploy

1. **Deploy Kiwix Archive:**
```bash
cd services/kiwix
docker-compose down
docker-compose build
docker-compose up -d
```

2. **Deploy Mirrors:**
```bash
cd services/mirrors
docker-compose down
docker-compose build
docker-compose up -d
```

## Architecture

### Kiwix Archive Service
- **Base Image**: Ubuntu 24.04 with nginx
- **Components**:
  - nginx (port 8080) - Serves homepage and proxies to kiwix-serve
  - kiwix-serve (port 8081) - Serves ZIM archives
  - Custom startup script manages both processes
- **Volumes**:
  - `./zims:/zims:ro` - ZIM archive files
  - `./data:/data` - Library data
  - `./www:/var/www/html:ro` - Homepage files

### Mirrors Service
- **Base Image**: nginx:alpine
- **Purpose**: Simple landing page with navigation
- **Features**: Responsive design, service links, statistics

## File Structure

```
services/kiwix/
├── www/
│   ├── index.html          # Main archive homepage
│   └── homepage.html       # Duplicate for direct access
├── scripts/
│   ├── convert_urls.py     # URL conversion script
│   ├── deploy_archives.sh  # Deployment script
│   └── ...
├── Dockerfile.with-nginx   # Custom Dockerfile with nginx
├── nginx.conf             # nginx configuration
├── start.sh               # Startup script
└── docker-compose.yml    # Service configuration

services/mirrors/
├── www/
│   └── index.html          # Mirrors landing page
├── nginx.conf             # nginx configuration
└── docker-compose.yml    # Service configuration
```

## Access URLs

- **Archive Library**: https://archive.brennan.page
- **Archive Homepage**: https://archive.brennan.page/homepage.html
- **Mirrors Portal**: https://mirrors.brennan.page
- **Direct Kiwix**: https://archive.brennan.page/homepage.html

## Maintenance

### Adding New Archives
1. Update `Docker KiwiX URLs.txt` with new viewer URLs
2. Run the conversion script:
   ```bash
   python3 scripts/convert_urls.py "Docker KiwiX URLs.txt" www/index.html
   ```
3. Deploy the updated service:
   ```bash
   docker-compose up -d --build
   ```

### Updating Categories
Edit the `categorize_archive()` function in `convert_urls.py` to modify categorization logic.

### Customizing Appearance
- Edit `www/index.html` for the archive homepage
- Edit `services/mirrors/www/index.html` for the mirrors portal
- Modify CSS in the `<style>` sections of each file

## Monitoring

Check service status:
```bash
# Kiwix Archive
docker-compose -f services/kiwix/docker-compose.yml ps

# Mirrors
docker-compose -f services/mirrors/docker-compose.yml ps
```

Check logs:
```bash
# Kiwix Archive
docker logs kiwix

# Mirrors
docker logs mirrors
```

## Troubleshooting

### Common Issues

1. **Service not responding**:
   - Check if containers are running: `docker ps`
   - Check logs: `docker logs kiwix` or `docker logs mirrors`
   - Verify port conflicts: `netstat -tulpn | grep 808[23]`

2. **Homepage not loading**:
   - Verify www directory is mounted correctly
   - Check nginx configuration: `docker exec kiwix nginx -t`

3. **Kiwix library not loading**:
   - Verify ZIM files are in the zims directory
   - Check library.xml generation in container logs

### Recovery Commands

```bash
# Restart services
docker-compose -f services/kiwix/docker-compose.yml restart
docker-compose -f services/mirrors/docker-compose.yml restart

# Rebuild services
docker-compose -f services/kiwix/docker-compose.yml up -d --build
docker-compose -f services/mirrors/docker-compose.yml up -d --build
```

## Future Enhancements

- [ ] Add search functionality to archive homepage
- [ ] Implement archive favorites/bookmarking
- [ ] Add download progress tracking
- [ ] Integrate with automatic archive updates
- [ ] Add usage analytics and statistics
- [ ] Implement archive metadata display
