#!/usr/bin/env bash
# Health check script for brennan.page homelab services
set -euo pipefail

# Configuration
REMOTE="root@159.203.44.169"
SSH_KEY="~/.omg-lol-keys/id_ed25519"
LOG_FILE="/tmp/health-check.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status="$1"
    local service="$2"
    local message="$3"
    
    case "$status" in
        "OK")
            echo -e "${GREEN}✅ OK${NC} $service: $message"
            ;;
        "WARN")
            echo -e "${YELLOW}⚠️  WARN${NC} $service: $message"
            ;;
        "ERROR")
            echo -e "${RED}❌ ERROR${NC} $service: $message"
            ;;
        "INFO")
            echo -e "${BLUE}ℹ️  INFO${NC} $service: $message"
            ;;
    esac
}

# Function to check HTTP/HTTPS endpoint
check_http() {
    local url="$1"
    local expected_code="${2:-200}"
    local service_name="$3"
    
    local status_code
    status_code=$(curl -o /dev/null -s -w "%{http_code}" --connect-timeout 10 --max-time 30 "$url" 2>/dev/null || echo "000")
    
    if [ "$status_code" = "$expected_code" ]; then
        print_status "OK" "$service_name" "HTTP $status_code"
        return 0
    elif [ "$status_code" = "000" ]; then
        print_status "ERROR" "$service_name" "Connection failed"
        return 2
    else
        print_status "WARN" "$service_name" "HTTP $status_code (expected $expected_code)"
        return 1
    fi
}

# Function to check Docker container status
check_docker_container() {
    local container_name="$1"
    local service_name="$2"
    
    local status
    status=$(ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" "docker inspect -f '{{.State.Status}}' '$container_name' 2>/dev/null || echo 'not_found'")
    
    case "$status" in
        "running")
            print_status "OK" "$service_name" "Container running"
            return 0
            ;;
        "exited")
            print_status "ERROR" "$service_name" "Container exited"
            return 2
            ;;
        "not_found")
            print_status "ERROR" "$service_name" "Container not found"
            return 2
            ;;
        *)
            print_status "WARN" "$service_name" "Container status: $status"
            return 1
            ;;
    esac
}

# Function to check system resources
check_system_resources() {
    echo -e "${BLUE}=== System Resources ===${NC}"
    
    # Check memory usage
    local memory_info
    memory_info=$(ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" "free -m | grep '^Mem:' | awk '{print \$3,\$2}'")
    local used_mem=$(echo "$memory_info" | cut -d' ' -f1)
    local total_mem=$(echo "$memory_info" | cut -d' ' -f2)
    local mem_percent=$((used_mem * 100 / total_mem))
    
    if [ "$mem_percent" -lt 80 ]; then
        print_status "OK" "Memory" "${used_mem}MB/${total_mem}MB (${mem_percent}%)"
    elif [ "$mem_percent" -lt 90 ]; then
        print_status "WARN" "Memory" "${used_mem}MB/${total_mem}MB (${mem_percent}%)"
    else
        print_status "ERROR" "Memory" "${used_mem}MB/${total_mem}MB (${mem_percent}%)"
    fi
    
    # Check disk usage
    local disk_usage
    disk_usage=$(ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" "df -h / | tail -1 | awk '{print \$5}' | sed 's/%//'")
    
    if [ "$disk_usage" -lt 80 ]; then
        print_status "OK" "Disk" "${disk_usage}% used"
    elif [ "$disk_usage" -lt 90 ]; then
        print_status "WARN" "Disk" "${disk_usage}% used"
    else
        print_status "ERROR" "Disk" "${disk_usage}% used"
    fi
    
    # Check load average
    local load_avg
    load_avg=$(ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" "uptime | awk -F'load average:' '{print \$2}' | cut -d',' -f1 | sed 's/^[[:space:]]*//'")
    print_status "INFO" "Load" "Load average: $load_avg"
    
    echo ""
}

# Function to check Docker daemon
check_docker_daemon() {
    local docker_status
    docker_status=$(ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" "systemctl is-active docker" 2>/dev/null || echo "unknown")
    
    if [ "$docker_status" = "active" ]; then
        print_status "OK" "Docker" "Daemon running"
    else
        print_status "ERROR" "Docker" "Daemon status: $docker_status"
    fi
}

# Function to check firewall status
check_firewall() {
    local ufw_status
    ufw_status=$(ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" "ufw status | head -1" 2>/dev/null || echo "unknown")
    
    if echo "$ufw_status" | grep -q "active"; then
        print_status "OK" "UFW" "Firewall active"
    else
        print_status "WARN" "UFW" "Firewall status: $ufw_status"
    fi
}

# Main health check function
main() {
    echo "=== brennan.page Health Check ==="
    echo "Date: $(date)"
    echo ""
    
    local total_checks=0
    local passed_checks=0
    local warning_checks=0
    local error_checks=0
    
    # System checks
    check_system_resources
    ((total_checks += 3))
    
    check_docker_daemon
    ((total_checks++))
    
    check_firewall
    ((total_checks++))
    
    echo -e "${BLUE}=== Service Health ===${NC}"
    
    # Check Docker containers
    check_docker_container "caddy" "Caddy"
    ((total_checks++))
    case $? in
        0) ((passed_checks++)) ;;
        1) ((warning_checks++)) ;;
        2) ((error_checks++)) ;;
    esac
    
    check_docker_container "portainer" "Portainer"
    ((total_checks++))
    case $? in
        0) ((passed_checks++)) ;;
        1) ((warning_checks++)) ;;
        2) ((error_checks++)) ;;
    esac
    
    check_docker_container "glances" "Glances"
    ((total_checks++))
    case $? in
        0) ((passed_checks++)) ;;
        1) ((warning_checks++)) ;;
        2) ((error_checks++)) ;;
    esac
    
    check_docker_container "filebrowser" "FileBrowser"
    ((total_checks++))
    case $? in
        0) ((passed_checks++)) ;;
        1) ((warning_checks++)) ;;
        2) ((error_checks++)) ;;
    esac
    
    echo ""
    echo -e "${BLUE}=== HTTP Endpoint Checks ===${NC}"
    
    # Check HTTP endpoints (only if containers are running)
    if ssh -i "$SSH_KEY" -T -o BatchMode=yes "$REMOTE" "docker inspect -f '{{.State.Status}}' caddy" 2>/dev/null | grep -q "running"; then
        check_http "https://brennan.page" "200" "brennan.page"
        ((total_checks++))
        case $? in
            0) ((passed_checks++)) ;;
            1) ((warning_checks++)) ;;
            2) ((error_checks++)) ;;
        esac
        
        check_http "https://docker.brennan.page" "200" "docker.brennan.page"
        ((total_checks++))
        case $? in
            0) ((passed_checks++)) ;;
            1) ((warning_checks++)) ;;
            2) ((error_checks++)) ;;
        esac
        
        check_http "https://monitor.brennan.page" "200" "monitor.brennan.page"
        ((total_checks++))
        case $? in
            0) ((passed_checks++)) ;;
            1) ((warning_checks++)) ;;
            2) ((error_checks++)) ;;
        esac
        
        check_http "https://files.brennan.page" "200" "files.brennan.page"
        ((total_checks++))
        case $? in
            0) ((passed_checks++)) ;;
            1) ((warning_checks++)) ;;
            2) ((error_checks++)) ;;
        esac
    else
        print_status "WARN" "HTTP Checks" "Caddy not running, skipping endpoint checks"
        ((total_checks += 4))
        ((warning_checks += 4))
    fi
    
    echo ""
    echo -e "${BLUE}=== Health Check Summary ===${NC}"
    echo "Total checks: $total_checks"
    echo -e "Passed: ${GREEN}$passed_checks${NC}"
    echo -e "Warnings: ${YELLOW}$warning_checks${NC}"
    echo -e "Errors: ${RED}$error_checks${NC}"
    
    if [ "$error_checks" -gt 0 ]; then
        echo ""
        print_status "ERROR" "Overall" "$error_checks critical issues detected"
        exit 2
    elif [ "$warning_checks" -gt 0 ]; then
        echo ""
        print_status "WARN" "Overall" "$warning_checks warnings detected"
        exit 1
    else
        echo ""
        print_status "OK" "Overall" "All systems healthy"
        exit 0
    fi
}

# Execute main function
main
