#!/bin/bash
# SSL Certificate Health Check for brennan.page
# Run this script to monitor SSL certificate status and detect issues early

set -euo pipefail

# Configuration
SSH_KEY="${HOME}/.omg-lol-keys/id_ed25519"
SERVER="root@159.203.44.169"
LOG_FILE="/tmp/ssl-health-check.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# SSH command wrapper
ssh_cmd() {
    ssh -i "$SSH_KEY" -T -o BatchMode=yes "$SERVER" "$1"
}

# Check if we can connect to server
check_server_connectivity() {
    log "Checking server connectivity..."
    if ssh_cmd "echo 'Connection successful'" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Server connectivity: OK${NC}"
        return 0
    else
        echo -e "${RED}❌ Server connectivity: FAILED${NC}"
        return 1
    fi
}

# Check Caddy container status
check_caddy_status() {
    log "Checking Caddy container status..."
    local status
    status=$(ssh_cmd "docker compose -c /opt/homelab/caddy/docker-compose.yml ps -q caddy | xargs docker inspect -f '{{.State.Status}}'" 2>/dev/null || echo "error")
    
    if [[ "$status" == "running" ]]; then
        echo -e "${GREEN}✅ Caddy container: Running${NC}"
        return 0
    else
        echo -e "${RED}❌ Caddy container: $status${NC}"
        return 1
    fi
}

# Check SSL certificates
check_ssl_certificates() {
    log "Checking SSL certificates..."
    local cert_count
    cert_count=$(ssh_cmd "docker exec caddy find /data -name '*.crt' | wc -l" 2>/dev/null || echo "0")
    
    if [[ "$cert_count" -gt 0 ]]; then
        echo -e "${GREEN}✅ SSL certificates: $cert_count certificates found${NC}"
        
        # Check for brennan.page certificate specifically
        if ssh_cmd "test -f /data/caddy/certificates/acme-v02.api.letsencrypt.org-directory/brennan.page/brennan.page.crt" 2>/dev/null; then
            echo -e "${GREEN}✅ brennan.page certificate: Present${NC}"
        else
            echo -e "${RED}❌ brennan.page certificate: Missing${NC}"
            return 1
        fi
        return 0
    else
        echo -e "${RED}❌ SSL certificates: None found${NC}"
        return 1
    fi
}

# Check certificate expiry
check_certificate_expiry() {
    log "Checking certificate expiry dates..."
    local expiry_days
    expiry_days=$(ssh_cmd "docker exec caddy openssl x509 -in /data/caddy/certificates/acme-v02.api.letsencrypt.org-directory/brennan.page/brennan.page.crt -noout -dates | grep 'notAfter' | cut -d'=' -f2" 2>/dev/null || echo "unknown")
    
    if [[ "$expiry_days" != "unknown" ]]; then
        echo -e "${GREEN}✅ brennan.page certificate expires: $expiry_days${NC}"
        
        # Calculate days until expiry (simplified)
        local expiry_timestamp
        expiry_timestamp=$(date -d "$expiry_days" +%s 2>/dev/null || echo "0")
        local current_timestamp
        current_timestamp=$(date +%s)
        local days_until_expiry
        days_until_expiry=$(( (expiry_timestamp - current_timestamp) / 86400 ))
        
        if [[ $days_until_expiry -lt 7 ]]; then
            echo -e "${RED}⚠️  Certificate expires in $days_until_expiry days (CRITICAL)${NC}"
            return 1
        elif [[ $days_until_expiry -lt 30 ]]; then
            echo -e "${YELLOW}⚠️  Certificate expires in $days_until_expiry days (WARNING)${NC}"
        else
            echo -e "${GREEN}✅ Certificate expires in $days_until_expiry days${NC}"
        fi
        return 0
    else
        echo -e "${RED}❌ Could not determine certificate expiry${NC}"
        return 1
    fi
}

# Test external HTTPS connectivity
test_https_connectivity() {
    log "Testing HTTPS connectivity..."
    local domains=("brennan.page" "wiki.brennan.page" "docker.brennan.page")
    local failed_domains=()
    
    for domain in "${domains[@]}"; do
        if curl -s --connect-timeout 10 --max-time 15 "https://$domain" >/dev/null 2>&1; then
            echo -e "${GREEN}✅ $domain: HTTPS OK${NC}"
        else
            echo -e "${RED}❌ $domain: HTTPS FAILED${NC}"
            failed_domains+=("$domain")
        fi
    done
    
    if [[ ${#failed_domains[@]} -gt 0 ]]; then
        echo -e "${RED}❌ Failed domains: ${failed_domains[*]}${NC}"
        return 1
    else
        echo -e "${GREEN}✅ All domains: HTTPS OK${NC}"
        return 0
    fi
}

# Check Caddy configuration
check_caddy_config() {
    log "Checking Caddy configuration..."
    local config_valid
    config_valid=$(ssh_cmd "cd /opt/homelab/caddy && docker compose exec caddy caddy validate --config /etc/caddy/Caddyfile 2>&1" | grep -c "Valid configuration" || echo "0")
    
    if [[ "$config_valid" -gt 0 ]]; then
        echo -e "${GREEN}✅ Caddy configuration: Valid${NC}"
        return 0
    else
        echo -e "${RED}❌ Caddy configuration: Invalid${NC}"
        return 1
    fi
}

# Check recent Caddy errors
check_recent_errors() {
    log "Checking recent Caddy errors..."
    local error_count
    error_count=$(ssh_cmd "docker logs caddy --since=1h 2>&1 | grep -c -i 'error\\|fail\\|warn'" || echo "0")
    
    if [[ "$error_count" -eq 0 ]]; then
        echo -e "${GREEN}✅ Recent errors: None${NC}"
        return 0
    elif [[ "$error_count" -lt 5 ]]; then
        echo -e "${YELLOW}⚠️  Recent errors: $error_count (minor)${NC}"
        return 0
    else
        echo -e "${RED}❌ Recent errors: $error_count (concerning)${NC}"
        return 1
    fi
}

# Main function
main() {
    echo "=== SSL Certificate Health Check ==="
    echo "Date: $(date)"
    echo "Server: $SERVER"
    echo
    
    local exit_code=0
    
    # Run all checks
    check_server_connectivity || exit_code=1
    check_caddy_status || exit_code=1
    check_ssl_certificates || exit_code=1
    check_certificate_expiry || exit_code=1
    test_https_connectivity || exit_code=1
    check_caddy_config || exit_code=1
    check_recent_errors || exit_code=1
    
    echo
    if [[ $exit_code -eq 0 ]]; then
        echo -e "${GREEN}🎉 All SSL health checks passed!${NC}"
        log "All SSL health checks passed"
    else
        echo -e "${RED}⚠️  Some SSL health checks failed. Review the output above.${NC}"
        log "Some SSL health checks failed"
        echo
        echo "Quick fix suggestions:"
        echo "1. Restart Caddy: ssh -i $SSH_KEY $SERVER 'cd /opt/homelab/caddy && docker compose restart caddy'"
        echo "2. Check configuration: ssh -i $SSH_KEY $SERVER 'cd /opt/homelab/caddy && docker compose exec caddy caddy validate --config /etc/caddy/Caddyfile'"
        echo "3. View full documentation: https://wiki.brennan.page/troubleshooting/ssl-issues/"
    fi
    
    echo "Log saved to: $LOG_FILE"
    exit $exit_code
}

# Run main function
main "$@"
