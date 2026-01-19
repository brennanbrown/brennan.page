#!/bin/bash

ZIMDIR=${ZIMDIR:-/zims}
LIBRARY_XML=/library.xml

# Create empty library.xml if it doesn't exist
if [ ! -f "$LIBRARY_XML" ]; then
    echo '<?xml version="1.0" encoding="UTF-8"?><library></library>' > "$LIBRARY_XML"
fi

# Add all .zim files to library
for f in "$ZIMDIR"/*.zim; do
    if [[ -f "$f" ]]; then
        echo "Adding $f to library..."
        kiwix-manage "$LIBRARY_XML" add "$f"
    fi
done

# Start kiwix-serve
echo "Starting Kiwix server on port 8080..."
exec kiwix-serve --port 8080 --library "$LIBRARY_XML"
