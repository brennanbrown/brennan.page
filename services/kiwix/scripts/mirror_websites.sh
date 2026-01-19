#!/bin/bash

# Website mirroring script for essential prepper content
# Uses wget to create offline copies of essential websites

DATA_DIR="/data/mirrored_sites"
mkdir -p "$DATA_DIR"

echo "Starting website mirroring..."

# Mirror essential websites with wget
cd "$DATA_DIR"

# First aid and medical sites
echo "Mirroring medical sites..."
wget --mirror \
     --convert-links \
     --adjust-extension \
     --page-requisites \
     --no-parent \
     --wait=2 \
     --random-wait \
     --limit-rate=1m \
     -U "Mozilla/5.0 (compatible; site-mirror/1.0)" \
     https://www.mayoclinic.org/first-aid/first-aid-index.html \
     -o mayoclinic.log &

# Gardening and homesteading
echo "Mirroring gardening resources..."
wget --mirror \
     --convert-links \
     --adjust-extension \
     --page-requisites \
     --no-parent \
     --wait=2 \
     --random-wait \
     --limit-rate=1m \
     -U "Mozilla/5.0 (compatible; site-mirror/1.0)" \
     https://www.almanac.com/gardening \
     -o almanac.log &

# Technical repair guides
echo "Mirroring repair guides..."
wget --mirror \
     --convert-links \
     --adjust-extension \
     --page-requisites \
     --no-parent \
     --wait=2 \
     --random-wait \
     --limit-rate=1m \
     -U "Mozilla/5.0 (compatible; site-mirror/1.0)" \
     https://www.ifixit.com/Guide \
     -o ifixit.log &

# Alternative energy resources
echo "Mirroring alternative energy guides..."
wget --mirror \
     --convert-links \
     --adjust-extension \
     --page-requisites \
     --no-parent \
     --wait=2 \
     --random-wait \
     --limit-rate=1m \
     -U "Mozilla/5.0 (compatible; site-mirror/1.0)" \
     https://www.builditsolar.com/Projects/FluidFluid/fluidfluid.htm \
     -o builditsolar.log &

wait

echo "Website mirroring completed!"
echo "Mirrored sites available in $DATA_DIR"

# Create index.html for easy navigation
cat > "$DATA_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Offline Prepper Archives</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .site { margin: 20px 0; padding: 15px; border: 1px solid #ccc; }
        .site h3 { margin: 0 0 10px 0; color: #333; }
        .site p { margin: 0; color: #666; }
    </style>
</head>
<body>
    <h1>Offline Prepper Archives</h1>
    <p>This directory contains mirrored essential websites for offline access.</p>
    
    <div class="site">
        <h3>Mayo Clinic First Aid</h3>
        <p>Medical first aid guides and emergency procedures</p>
        <a href="www.mayoclinic.org/first-aid/">Access First Aid Guides</a>
    </div>
    
    <div class="site">
        <h3>Old Farmer's Almanac Gardening</h3>
        <p>Comprehensive gardening guides and planting information</p>
        <a href="www.almanac.com/gardening/">Access Gardening Guides</a>
    </div>
    
    <div class="site">
        <h3>iFixit Repair Guides</h3>
        <p>Device repair and troubleshooting guides</p>
        <a href="www.ifixit.com/Guide/">Access Repair Guides</a>
    </div>
    
    <div class="site">
        <h3>Build It Solar</h3>
        <p>DIY solar and alternative energy projects</p>
        <a href="www.builditsolar.com/Projects/FluidFluid/fluidfluid.htm">Access Solar Guides</a>
    </div>
</body>
</html>
EOF

echo "Navigation index created at $DATA_DIR/index.html"
