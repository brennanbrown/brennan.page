#!/bin/bash

# Critical website mirroring for storage-constrained environment
# Only mirrors the most essential pages, not entire sites

DATA_DIR="/data/mirrored_sites"
mkdir -p "$DATA_DIR"

echo "Starting CRITICAL website mirroring (~2GB total)..."

cd "$DATA_DIR"

# First aid - only essential guides
echo "Mirroring critical first aid guides..."
wget --mirror \
     --convert-links \
     --adjust-extension \
     --page-requisites \
     --no-parent \
     --wait=2 \
     --random-wait \
     --limit-rate=500k \
     --reject="*.mp4,*.avi,*.mov,*.pdf" \
     -U "Mozilla/5.0 (compatible; site-mirror/1.0)" \
     https://www.mayoclinic.org/first-aid/first-aid-index.html \
     -o mayoclinic.log &

# Basic gardening guides
echo "Mirroring essential gardening guides..."
wget --mirror \
     --convert-links \
     --adjust-extension \
     --page-requisites \
     --no-parent \
     --wait=2 \
     --random-wait \
     --limit-rate=500k \
     --reject="*.mp4,*.avi,*.mov,*.jpg,*.jpeg,*.png" \
     --accept="*.html,*.css,*.js" \
     -U "Mozilla/5.0 (compatible; site-mirror/1.0)" \
     https://www.almanac.com/gardening/planting-calendar \
     -o almanac.log &

# Critical repair guides (phones, generators, tools)
echo "Mirroring essential repair guides..."
wget --mirror \
     --convert-links \
     --adjust-extension \
     --page-requisites \
     --no-parent \
     --wait=2 \
     --random-wait \
     --limit-rate=500k \
     --reject="*.mp4,*.avi,*.mov" \
     -U "Mozilla/5.0 (compatible; site-mirror/1.0)" \
     https://www.ifixit.com/Device/Phone \
     -o ifixit.log &

wait

echo "Critical website mirroring completed!"
echo "Storage used: ~2GB"
echo "Mirrored content available in $DATA_DIR"

# Create compact index
cat > "$DATA_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Critical Offline Archives</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; }
        .site { margin: 15px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .site h3 { margin: 0 0 8px 0; color: #333; }
        .site p { margin: 0 0 10px 0; color: #666; font-size: 14px; }
        .warning { background: #fff3cd; border: 1px solid #ffeaa7; padding: 10px; border-radius: 5px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Critical Offline Archives</h1>
        <div class="warning">
            <strong>Storage-Constrained Archive:</strong> Essential prepper content only (~2GB)
        </div>
        
        <div class="site">
            <h3>🏥 Mayo Clinic First Aid</h3>
            <p>Emergency medical procedures and first aid instructions</p>
            <a href="www.mayoclinic.org/first-aid/first-aid-index.html">Access First Aid</a>
        </div>
        
        <div class="site">
            <h3>🌱 Planting Calendar</h3>
            <p>Essential gardening timing and planting information</p>
            <a href="www.almanac.com/gardening/planting-calendar">Access Garden Guide</a>
        </div>
        
        <div class="site">
            <h3>🔧 Phone Repair Guides</h3>
            <p>Critical device repair procedures (phones, communication tools)</p>
            <a href="www.ifixit.com/Device/Phone">Access Repair Guides</a>
        </div>
    </div>
</body>
</html>
EOF

echo "Compact navigation index created at $DATA_DIR/index.html"
