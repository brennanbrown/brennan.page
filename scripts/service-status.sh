#!/bin/bash
# Dynamic Service Status Generator for brennan.page
# This script generates real-time status for all services

set -euo pipefail

# Configuration
SSH_KEY="${HOME}/.omg-lol-keys/id_ed25519"
SERVER="root@159.203.44.169"
STATUS_FILE="/tmp/service-status.json"
HTML_FILE="/tmp/dynamic-status.html"

# Service definitions
declare -A SERVICES=(
  ["docker"]="Portainer|https://docker.brennan.page|Docker management interface"
  ["monitor"]="Monitor|https://monitor.brennan.page|System monitoring dashboard"
  ["files"]="Files|https://files.brennan.page|File management interface"
  ["tasks"]="Tasks|https://tasks.brennan.page|Task management system"
  ["notes"]="Notes|https://notes.brennan.page|Collaborative markdown notes"
  ["bookmarks"]="Bookmarks|https://bookmarks.brennan.page|Bookmark manager"
  ["music"]="Music|https://music.brennan.page|Music streaming service"
  ["blog"]="Blog|https://blog.brennan.page|Minimalist blogging platform"
  ["forum"]="Forum|https://forum.brennan.page|Community discussion forum"
  ["rss"]="RSS|https://rss.brennan.page|RSS feed aggregator"
)

# Icons for services
declare -A ICONS=(
  ["docker"]="🐋"
  ["monitor"]="📊"
  ["files"]="📁"
  ["tasks"]="✅"
  ["notes"]="📝"
  ["bookmarks"]="🔖"
  ["music"]="🎵"
  ["blog"]="✍️"
  ["forum"]="💬"
  ["rss"]="📰"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# SSH command wrapper
ssh_cmd() {
    ssh -i "$SSH_KEY" -T -o BatchMode=yes "$SERVER" "$1"
}

# Test service availability
test_service() {
    local url="$1"
    local timeout=10
    
    if curl -s --connect-timeout "$timeout" --max-time "$timeout" "$url" >/dev/null 2>&1; then
        echo "online"
    else
        echo "offline"
    fi
}

# Get system stats
get_system_stats() {
    local stats
    stats=$(ssh_cmd "
        echo \"TOTAL_RAM: \$(free -h | awk '/^Mem:/ {print \$2}')\"
        echo \"USED_RAM: \$(free -h | awk '/^Mem:/ {print \$3}')\"
        echo \"STORAGE: \$(df -h / | awk 'NR==2 {print \$2}')\"
        echo \"SERVICES: \$(docker ps --format '{{.Names}}' | grep -v '^caddy\$' | wc -l)\"
    " 2>/dev/null || echo "ERROR: Could not get stats")
    
    echo "$stats"
}

# Generate status JSON
generate_status_json() {
    echo "{"
    echo "  \"timestamp\": \"$(date -Iseconds)\","
    echo "  \"services\": {"
    
    local first=true
    for key in "${!SERVICES[@]}"; do
        if [[ "$first" == true ]]; then
            first=false
        else
            echo ","
        fi
        
        IFS='|' read -r name url description <<< "${SERVICES[$key]}"
        local status
        status=$(test_service "$url")
        
        echo "    \"$key\": {"
        echo "      \"name\": \"$name\","
        echo "      \"url\": \"$url\","
        echo "      \"description\": \"$description\","
        echo "      \"status\": \"$status\","
        echo "      \"icon\": \"${ICONS[$key]}\""
        echo "    }"
    done
    
    echo ""
    echo "  },"
    echo "  \"system\": {"
    
    # Parse system stats
    local stats
    stats=$(get_system_stats)
    while IFS= read -r line; do
        if [[ "$line" =~ ^TOTAL_RAM: ]]; then
            echo "    \"total_ram\": \"${line#TOTAL_RAM: }\","
        elif [[ "$line" =~ ^USED_RAM: ]]; then
            echo "    \"used_ram\": \"${line#USED_RAM: }\","
        elif [[ "$line" =~ ^STORAGE: ]]; then
            echo "    \"storage\": \"${line#STORAGE: }\","
        elif [[ "$line" =~ ^SERVICES: ]]; then
            echo "    \"services\": \"${line#SERVICES: }\""
        fi
    done <<< "$stats"
    
    echo "  }"
    echo "}"
}

# Generate HTML status cards
generate_html_cards() {
    echo "<!-- Dynamic Service Status - Generated $(date) -->"
    echo "<div class=\"status-grid\" id=\"service-status\">"
    
    for key in "${!SERVICES[@]}"; do
        IFS='|' read -r name url description <<< "${SERVICES[$key]}"
        local icon="${ICONS[$key]}"
        
        echo "    <div class=\"service-card\" data-service=\"$key\">"
        echo "        <div class=\"service-name\">$icon $name</div>"
        echo "        <a href=\"$url\" class=\"service-url\" target=\"_blank\">${url#https://}</a>"
        echo "        <div class=\"service-description\">$description</div>"
        echo "        <div class=\"status checking\">CHECKING...</div>"
        echo "    </div>"
    done
    
    echo "</div>"
    
    # Add JavaScript for dynamic status checking
    cat << 'EOF'
<script>
// Dynamic service status checking
const services = {
EOF
    
    for key in "${!SERVICES[@]}"; do
        IFS='|' read -r name url description <<< "${SERVICES[$key]}"
        echo "    '$key': '$url',"
    done
    
    cat << 'EOF'
};

async function checkServiceStatus(service, url) {
    try {
        const response = await fetch(url, { 
            method: 'HEAD', 
            mode: 'no-cors',
            cache: 'no-cache',
            signal: AbortSignal.timeout(5000)
        });
        return 'online';
    } catch (error) {
        return 'offline';
    }
}

async function updateAllStatuses() {
    const cards = document.querySelectorAll('.service-card');
    
    for (const card of cards) {
        const service = card.dataset.service;
        const url = services[service];
        const statusElement = card.querySelector('.status');
        
        statusElement.className = 'status checking';
        statusElement.textContent = 'CHECKING...';
        
        const status = await checkServiceStatus(service, url);
        
        statusElement.className = `status ${status}`;
        statusElement.textContent = status.toUpperCase();
    }
}

// Update statuses on page load
document.addEventListener('DOMContentLoaded', updateAllStatuses);

// Update statuses every 30 seconds
setInterval(updateAllStatuses, 30000);
</script>
EOF
}

# Main execution
main() {
    case "${1:-json}" in
        "json")
            generate_status_json > "$STATUS_FILE"
            echo "Status JSON generated: $STATUS_FILE"
            ;;
        "html")
            generate_html_cards > "$HTML_FILE"
            echo "Status HTML generated: $HTML_FILE"
            ;;
        "update-landing")
            # Update the landing page with dynamic status
            echo "Updating landing page with dynamic status..."
            
            # Generate the new status section
            local temp_status
            temp_status=$(mktemp)
            generate_html_cards > "$temp_status"
            
            # Update the landing page on server
            ssh_cmd "
                # Backup current landing page
                cp /var/www/brennan.page/index.html /var/www/brennan.page/index.html.backup
                
                # Replace status section
                sed '/<div class=\"status-grid\">/,/<\/div>/c\\
$(cat "$temp_status")
' /var/www/brennan.page/index.html.backup > /var/www/brennan.page/index.html
            "
            
            rm "$temp_status"
            echo "Landing page updated with dynamic status"
            ;;
        "check")
            echo "=== Service Status Check ==="
            for key in "${!SERVICES[@]}"; do
                IFS='|' read -r name url description <<< "${SERVICES[$key]}"
                local icon="${ICONS[$key]}"
                local status
                status=$(test_service "$url")
                
                if [[ "$status" == "online" ]]; then
                    echo -e "${GREEN}✅ $icon $name${NC}"
                else
                    echo -e "${RED}❌ $icon $name${NC}"
                fi
            done
            ;;
        *)
            echo "Usage: $0 {json|html|update-landing|check}"
            echo "  json         - Generate status JSON"
            echo "  html         - Generate status HTML"
            echo "  update-landing - Update landing page with dynamic status"
            echo "  check        - Check current service status"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
