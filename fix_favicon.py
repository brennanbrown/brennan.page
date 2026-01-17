#!/usr/bin/env python3

# Add favicon handles to all reverse proxy services

with open('caddy/Caddyfile', 'r') as f:
    content = f.read()

# Define favicon handles
favicon_handles = '''    handle /favicon.ico {
        root * /opt/homelab/favicon
        file_server
    }
    handle /apple-touch-icon.png {
        root * /opt/homelab/favicon
        file_server
    }
    handle /android-chrome-192x192.png {
        root * /opt/homelab/favicon
        file_server
    }
    handle /android-chrome-512x512.png {
        root * /opt/homelab/favicon
        file_server
    }
    handle /favicon-16x16.png {
        root * /opt/homelab/favicon
        file_server
    }
    handle /favicon-32x32.png {
        root * /opt/homelab/favicon
        file_server
    }
    handle /site.webmanifest {
        root * /opt/homelab/favicon
        file_server
    }
    
    '''

# Services that need favicon handles
services = ['docker', 'files', 'tasks', 'notes', 'bookmarks', 'music', 'blog', 'forum', 'rss']

for service in services:
    # Find the service block and add favicon handles after import security
    old_pattern = f'{service}.brennan.page {{\n    import compression\n    import security\n    \n    reverse_proxy'
    new_pattern = f'{service}.brennan.page {{\n    import compression\n    import security\n    \n{favicon_handles}    reverse_proxy'
    
    if old_pattern in content:
        content = content.replace(old_pattern, new_pattern)
        print(f"Updated {service}.brennan.page")
    else:
        print(f"Pattern not found for {service}.brennan.page")

with open('caddy/Caddyfile', 'w') as f:
    f.write(content)

print("Fixed favicon handles for all reverse proxy services")
