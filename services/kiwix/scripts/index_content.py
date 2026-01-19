#!/usr/bin/env python3

import os
import json
import time
from pathlib import Path
from meilisearch import Client
from bs4 import BeautifulSoup
import zipfile
import pdfplumber

class ArchiveIndexer:
    def __init__(self, meili_url, master_key):
        self.client = Client(meili_url, master_key)
        self.data_dir = Path("/data")
        self.zim_dir = Path("/zims")
        
    def create_indices(self):
        """Create search indices for different content types"""
        
        # Create index for PDFs and documents
        self.client.create_index('documents', {
            'primaryKey': 'id',
            'searchableAttributes': ['title', 'content', 'category'],
            'filterableAttributes': ['category', 'source'],
            'sortableAttributes': ['title']
        })
        
        # Create index for mirrored websites
        self.client.create_index('websites', {
            'primaryKey': 'id',
            'searchableAttributes': ['title', 'content', 'url', 'site_name'],
            'filterableAttributes': ['site_name'],
            'sortableAttributes': ['title']
        })
        
        print("Created search indices")
    
    def index_pdfs(self):
        """Index PDF documents"""
        documents = []
        
        # Index survival PDFs
        survival_dir = self.data_dir / "survival"
        if survival_dir.exists():
            for pdf_file in survival_dir.glob("*.pdf"):
                try:
                    with pdfplumber.open(pdf_file) as pdf:
                        content = ""
                        for page in pdf.pages[:10]:  # First 10 pages
                            content += page.extract_text() or ""
                    
                    doc = {
                        'id': f"survival_{pdf_file.stem}",
                        'title': pdf_file.stem.replace('_', ' ').title(),
                        'content': content[:5000],  # Limit content length
                        'category': 'survival',
                        'source': pdf_file.name,
                        'file_path': str(pdf_file)
                    }
                    documents.append(doc)
                    print(f"Indexed survival PDF: {pdf_file.name}")
                except Exception as e:
                    print(f"Error indexing {pdf_file}: {e}")
        
        # Index medical PDFs
        medical_dir = self.data_dir / "medical"
        if medical_dir.exists():
            for pdf_file in medical_dir.glob("*.pdf"):
                try:
                    with pdfplumber.open(pdf_file) as pdf:
                        content = ""
                        for page in pdf.pages[:10]:
                            content += page.extract_text() or ""
                    
                    doc = {
                        'id': f"medical_{pdf_file.stem}",
                        'title': pdf_file.stem.replace('_', ' ').title(),
                        'content': content[:5000],
                        'category': 'medical',
                        'source': pdf_file.name,
                        'file_path': str(pdf_file)
                    }
                    documents.append(doc)
                    print(f"Indexed medical PDF: {pdf_file.name}")
                except Exception as e:
                    print(f"Error indexing {pdf_file}: {e}")
        
        # Index gardening PDFs
        gardening_dir = self.data_dir / "gardening"
        if gardening_dir.exists():
            for pdf_file in gardening_dir.glob("*.pdf"):
                try:
                    with pdfplumber.open(pdf_file) as pdf:
                        content = ""
                        for page in pdf.pages[:10]:
                            content += page.extract_text() or ""
                    
                    doc = {
                        'id': f"gardening_{pdf_file.stem}",
                        'title': pdf_file.stem.replace('_', ' ').title(),
                        'content': content[:5000],
                        'category': 'gardening',
                        'source': pdf_file.name,
                        'file_path': str(pdf_file)
                    }
                    documents.append(doc)
                    print(f"Indexed gardening PDF: {pdf_file.name}")
                except Exception as e:
                    print(f"Error indexing {pdf_file}: {e}")
        
        if documents:
            self.client.index('documents').add_documents(documents)
            print(f"Indexed {len(documents)} PDF documents")
    
    def index_websites(self):
        """Index mirrored websites"""
        websites = []
        mirrored_dir = self.data_dir / "mirrored_sites"
        
        if not mirrored_dir.exists():
            print("No mirrored websites found")
            return
        
        for site_dir in mirrored_dir.iterdir():
            if site_dir.is_dir():
                site_name = site_dir.name
                print(f"Indexing website: {site_name}")
                
                # Find HTML files
                for html_file in site_dir.rglob("*.html"):
                    try:
                        with open(html_file, 'r', encoding='utf-8', errors='ignore') as f:
                            content = f.read()
                        
                        soup = BeautifulSoup(content, 'html.parser')
                        
                        # Extract text content
                        text_content = soup.get_text(strip=True)
                        title = soup.title.string if soup.title else html_file.stem
                        
                        # Get relative URL
                        rel_path = html_file.relative_to(mirrored_dir)
                        url = f"/{rel_path}"
                        
                        doc = {
                            'id': f"site_{site_name}_{html_file.stem}",
                            'title': title,
                            'content': text_content[:3000],  # Limit content
                            'url': url,
                            'site_name': site_name,
                            'file_path': str(html_file)
                        }
                        websites.append(doc)
                        
                    except Exception as e:
                        print(f"Error indexing {html_file}: {e}")
        
        if websites:
            # Add in batches to avoid timeouts
            batch_size = 100
            for i in range(0, len(websites), batch_size):
                batch = websites[i:i+batch_size]
                self.client.index('websites').add_documents(batch)
                print(f"Indexed batch {i//batch_size + 1}/{(len(websites)-1)//batch_size + 1}")
            
            print(f"Indexed {len(websites)} web pages")
    
    def run_indexing(self):
        """Run complete indexing process"""
        print("Starting archive indexing...")
        
        # Wait for Meilisearch to be ready
        time.sleep(10)
        
        try:
            self.create_indices()
            self.index_pdfs()
            self.index_websites()
            print("Indexing completed successfully!")
        except Exception as e:
            print(f"Indexing failed: {e}")

if __name__ == "__main__":
    meili_url = os.getenv("MEILI_URL", "http://meilisearch:7700")
    master_key = os.getenv("MEILI_MASTER_KEY")
    
    if not master_key:
        print("MEILI_MASTER_KEY environment variable required")
        exit(1)
    
    indexer = ArchiveIndexer(meili_url, master_key)
    indexer.run_indexing()
