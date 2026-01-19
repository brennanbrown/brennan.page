#!/bin/bash

echo "Setting up offline search functionality..."

# Start search services
docker-compose -f docker-compose.search.yml up -d

echo "Waiting for Meilisearch to start..."
sleep 30

# Run indexing
docker-compose -f docker-compose.search.yml run --rm indexer

echo "Search setup completed!"
echo "Access search interface at: http://search.brennan.page"
echo ""
echo "API endpoints:"
echo "- Documents (PDFs): http://search.brennan.page/indexes/documents/search"
echo "- Websites: http://search.brennan.page/indexes/websites/search"
echo ""
echo "Example search:"
echo "curl -X POST 'http://search.brennan.page/indexes/documents/search' \\"
echo "  -H 'Authorization: Bearer your-secret-master-key' \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  --data-binary '{\"q\": \"first aid\", \"limit\": 10}'"
