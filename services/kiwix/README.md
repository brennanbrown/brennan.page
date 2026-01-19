# Kiwix Archive Service

Offline knowledge archive service for prepper content and essential information.

## Services

- **archive.brennan.page** - Kiwix server for Wikipedia and other ZIM archives
- **mirrors.brennan.page** - Mirrored essential websites (via nginx)

## Setup

1. Build and start the service:
```bash
docker-compose up -d
```

2. Download archives (run inside container):
```bash
docker exec kiwix /usr/local/bin/download_archives.sh
```

3. Mirror websites:
```bash
docker exec kiwix /usr/local/bin/mirror_websites.sh
```

## Available Content

### ZIM Archives
- Wikipedia (full English) - ~100GB
- Wiktionary (English dictionary)
- WikiBooks (textbooks and manuals)

### PDF Libraries
- **Survival Manuals**: Military field manuals, CIA survival guides
- **Medical**: First aid, emergency medical procedures
- **Gardening**: Seed saving, homesteading guides

### Mirrored Websites
- Mayo Clinic First Aid
- Old Farmer's Almanac Gardening
- iFixit Repair Guides
- Build It Solar (alternative energy)

## Storage Requirements

- Essential archives: ~10GB
- Full Wikipedia: ~100GB
- Mirrored sites: ~5GB
- PDF libraries: ~500MB

## Automation

Add to crontab for regular updates:
```bash
# Weekly archive updates
0 2 * * 0 /usr/local/bin/download_archives.sh

# Monthly website mirrors
0 3 1 * * /usr/local/bin/mirror_websites.sh
```

## Access

- Kiwix Library: http://archive.brennan.page:8080
- Mirrored Sites: http://mirrors.brennan.page
