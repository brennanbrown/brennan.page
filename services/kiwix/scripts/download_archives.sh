#!/bin/bash

# Archive downloader script for prepper content
# This script downloads essential knowledge archives

ZIM_DIR="/zims"
DATA_DIR="/data"

echo "Starting archive downloads..."

# Create directories
mkdir -p "$ZIM_DIR"
mkdir -p "$DATA_DIR/survival"
mkdir -p "$DATA_DIR/medical"
mkdir -p "$DATA_DIR/gardening"
mkdir -p "$DATA_DIR/technical"

# Download essential, space-efficient archives first
echo "Downloading essential archives..."

# Wikipedia Mini (text-only, no images - ~1GB)
echo "Downloading Wikipedia Mini (text-only)..."
wget -c "https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_mini_2024-01.zim" -O "$ZIM_DIR/wikipedia_en_all_mini_2024-01.zim" &

# Wiktionary (dictionary - ~200MB)
wget -c "https://download.kiwix.org/zim/wiktionary/wiktionary_en_all_2024-01.zim" -O "$ZIM_DIR/wiktionary_en_all_2024-01.zim" &

# WikiBooks (essential textbooks - ~500MB)
wget -c "https://download.kiwix.org/zim/wikibooks/wikibooks_en_all_2024-01.zim" -O "$ZIM_DIR/wikibooks_en_all_2024-01.zim" &

# Wait for essential downloads to complete
wait

echo "Essential archives downloaded. Starting survival content downloads..."

# Download survival PDFs
cd "$DATA_DIR/survival"

# Military manuals
wget -c "https://trueprepper.com/wp-content/uploads/Canadian-Military-Fieldcraft.pdf" &
wget -c "https://trueprepper.com/wp-content/uploads/2023/03/Down-But-Not-Out-Canadian-Survival-Manual.pdf" &
wget -c "https://trueprepper.com/wp-content/uploads/CIA-RDP78-Introdution-to-Survival.pdf" &
wget -c "https://trueprepper.com/wp-content/uploads/Boy-Scout-Handbook-1911.pdf" &
wget -c "https://trueprepper.com/wp-content/uploads/US-Antarctic-Continental-Field-Manual.pdf" &

# Medical content
cd "$DATA_DIR/medical"
wget -c "https://ia801605.us.archive.org/32/items/pdfy-IFo2wktEmDJZVmsy/First%20Aid,%20Survival%20And%20CPR%20%5BHome%20And%20Field%20Pocket%20Guide%5D.pdf" &

# Gardening content
cd "$DATA_DIR/gardening"
wget -c "https://seedalliance.org/wp-content/uploads/2010/04/seed_saving_guide.pdf" &
wget -c "https://www.seedambassadors.org/docs/seedzine4handout.pdf" &

wait

echo "Archive downloads completed!"
echo "Available content:"
echo "- Wikipedia and reference archives in $ZIM_DIR"
echo "- Survival manuals in $DATA_DIR/survival"
echo "- Medical guides in $DATA_DIR/medical"
echo "- Gardening resources in $DATA_DIR/gardening"
