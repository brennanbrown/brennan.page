#!/bin/bash

# Minimal archive downloader for 20GB storage constraint
# Focus on essential prepper content only

ZIM_DIR="/zims"
DATA_DIR="/data"

echo "Starting MINIMAL archive downloads for storage-constrained environment..."

# Create directories
mkdir -p "$ZIM_DIR"
mkdir -p "$DATA_DIR/essential"

# Storage budget allocation:
# Wikipedia Mini: ~1GB
# Essential PDFs: ~500MB
# Critical website mirrors: ~2GB
# Search index: ~1GB
# Buffer: ~15GB

echo "Downloading Wikipedia Mini (text-only, ~1GB)..."
wget -c "https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_mini_2024-01.zim" -O "$ZIM_DIR/wikipedia_en_mini_2024-01.zim" &
wait

echo "Downloading essential survival and medical PDFs..."
cd "$DATA_DIR/essential"

# Only the most critical survival PDFs
wget -c "https://trueprepper.com/wp-content/uploads/Canadian-Military-Fieldcraft.pdf" &
wget -c "https://trueprepper.com/wp-content/uploads/2023/03/Down-But-Not-Out-Canadian-Survival-Manual.pdf" &
wget -c "https://ia801605.us.archive.org/32/items/pdfy-IFo2wktEmDJZVmsy/First%20Aid,%20Survival%20And%20CPR%20%5BHome%20And%20Field%20Pocket%20Guide%5D.pdf" &
wget -c "https://seedalliance.org/wp-content/uploads/2010/04/seed_saving_guide.pdf" &

wait

echo "Minimal archive downloads completed!"
echo "Storage used: ~2GB total"
echo "Available content:"
echo "- Wikipedia Mini (text-only) in $ZIM_DIR"
echo "- Essential survival/medical/gardening PDFs in $DATA_DIR/essential"
echo ""
echo "To add more content, run:"
echo "- ./scripts/mirror_critical_sites.sh (adds ~2GB)"
echo "- ./scripts/setup_search.sh (adds ~1GB)"
