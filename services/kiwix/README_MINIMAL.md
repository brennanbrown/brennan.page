# Minimal Prepper Archive System

Storage-optimized offline archive system for 20GB constraint.

## Storage Budget (20GB total)

- **Wikipedia Mini**: 1GB (text-only, no images)
- **Essential PDFs**: 500MB (survival, medical, gardening)
- **Critical Websites**: 2GB (first aid, gardening, repair)
- **Search Index**: 1GB (if enabled)
- **Buffer**: 15.5GB (system overhead and expansion)

## Quick Start

```bash
cd /Users/brennan/Documents/GitHub/brennan.page/services/kiwix

# Start archive service
docker-compose up -d

# Download minimal essential content (~2GB)
docker exec kiwix /usr/local/bin/download_archives_minimal.sh

# Optional: Add critical website mirrors (+2GB)
docker exec kiwix /usr/local/bin/mirror_critical_sites.sh

# Optional: Add search functionality (+1GB)
./scripts/setup_search.sh
```

## Content Included

### Essential Archives
- **Wikipedia Mini**: Full text content, no images
- **Survival Manuals**: Canadian Military Fieldcraft, Down But Not Out
- **Medical**: First Aid & CPR Pocket Guide
- **Gardening**: Seed Saving Guide

### Critical Websites (Optional)
- Mayo Clinic First Aid
- Old Farmer's Almanac Planting Calendar
- iFixit Phone Repair Guides

## Storage Management

### Minimal Setup (~2GB)
```bash
docker-compose up -d
docker exec kiwix /usr/local/bin/download_archives_minimal.sh
```

### Standard Setup (~4GB)
```bash
docker-compose up -d
docker exec kiwix /usr/local/bin/download_archives_minimal.sh
docker exec kiwix /usr/local/bin/mirror_critical_sites.sh
```

### Full Setup (~5GB)
```bash
# Standard setup + search
docker-compose up -d
docker exec kiwix /usr/local/bin/download_archives_minimal.sh
docker exec kiwix /usr/local/bin/mirror_critical_sites.sh
./scripts/setup_search.sh
```

## Access Points

- **Kiwix Archives**: http://archive.brennan.page:8080
- **Mirrored Sites**: http://mirrors.brennan.page
- **Search Interface**: http://search.brennan.page (optional)

## Monitoring Storage

Check remaining space:
```bash
df -h /path/to/your/server/storage
du -sh /path/to/kiwix/data
```

## Expansion Strategy

When you have more storage available:
1. Add full Wikipedia (+100GB)
2. Add comprehensive website mirrors (+10GB)
3. Add video content (+50GB)

This minimal system provides critical knowledge while staying within your storage constraints.
