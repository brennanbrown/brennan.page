#!/usr/bin/env bash
# Deploy archive and mirrors services
set -euo pipefail

echo "🚀 Deploying Kiwix Archive and Mirrors services..."

# Function to deploy service
deploy_service() {
    local service_dir="$1"
    local service_name="$2"
    
    echo "📦 Deploying $service_name..."
    cd "$service_dir"
    
    # Build and start
    docker-compose down
    docker-compose build
    docker-compose up -d
    
    # Check status
    if docker-compose ps | grep -q "Up"; then
        echo "✅ $service_name deployed successfully"
    else
        echo "❌ $service_name deployment failed"
        return 1
    fi
}

# Deploy Kiwix Archive service
echo "📚 Deploying Kiwix Archive service..."
deploy_service "/Users/brennan/Documents/GitHub/brennan.page/services/kiwix" "Kiwix Archive"

# Deploy Mirrors service
echo "🪞 Deploying Mirrors service..."
deploy_service "/Users/brennan/Documents/GitHub/brennan.page/services/mirrors" "Mirrors"

# Verify services are running
echo "🔍 Verifying services..."
sleep 5

# Check if services are responding
if curl -s http://localhost:8082 > /dev/null; then
    echo "✅ Kiwix Archive service is responding"
else
    echo "❌ Kiwix Archive service is not responding"
fi

if curl -s http://localhost:8083 > /dev/null; then
    echo "✅ Mirrors service is responding"
else
    echo "❌ Mirrors service is not responding"
fi

echo ""
echo "🌐 Services are available at:"
echo "   📖 Archive Library: https://archive.brennan.page"
echo "   🏠 Archive Homepage: https://archive.brennan.page/homepage.html"
echo "   🪞 Mirrors Portal: https://mirrors.brennan.page"
echo ""
echo "📊 Archive Summary:"
python3 /Users/brennan/Documents/GitHub/brennan.page/services/kiwix/scripts/convert_urls.py "/Users/brennan/Documents/GitHub/brennan.page/Docker KiwiX URLs.txt" /dev/null 2>/dev/null | tail -7

echo ""
echo "🎉 Deployment complete!"
