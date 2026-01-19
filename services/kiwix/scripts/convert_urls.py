#!/usr/bin/env python3
"""
Convert Kiwix URLs to proper format and generate organized HTML for archive homepage.
"""

import re
import urllib.parse
from typing import List, Dict, Tuple

def extract_name_from_url(url: str) -> str:
    """Extract readable name from Kiwix URL."""
    # Extract the part after # and before date
    match = re.search(r'#(.+)$', url)
    if match:
        full_name = match.group(1)
        
        # Handle devdocs special cases FIRST (before generic mapping)
        if full_name.startswith('devdocs_'):
            parts = full_name.split('_')
            if len(parts) >= 3:
                tech = parts[2].upper()
                return f'DevDocs - {tech}'
        
        # Handle ted talks FIRST (before generic mapping)
        if full_name.startswith('ted_'):
            if 'life' in full_name:
                return 'TED Talks - Life'
            elif 'ideas' in full_name:
                return 'TED Talks - Ideas'
        
        # Handle freecodecamp special cases
        if full_name.startswith('freecodecamp_'):
            if 'project-euler' in full_name:
                return 'freeCodeCamp - Project Euler'
            else:
                return 'freeCodeCamp'
        
        # Handle gutenberg categories FIRST (before generic mapping)
        if full_name.startswith('gutenberg_en_lcc-'):
            category = full_name.split('-')[-1].upper()
            return f'Project Gutenberg - Category {category}'
        
        # Handle wikipedia variants FIRST (before generic mapping)
        if full_name.startswith('wikipedia_'):
            if 'wp1-0.8' in full_name:
                return 'Wikipedia - Simple English'
            elif 'nopic' in full_name:
                return 'Wikipedia - No Images'
        
        # Extract base name for generic mapping (remove date and variant info)
        name_parts = full_name.split('_')
        base_name = name_parts[0]
        
        # Generic name mapping (only for non-special cases)
        name_mapping = {
            'php.net': 'PHP Documentation',
            'archlinux': 'Arch Linux Wiki',
            'finiki': 'Financial Wiki',
            'docs.python.org': 'Python Documentation',
            'medlineplus.gov': 'MedlinePlus',
            'openstreetmap-wiki': 'OpenStreetMap Wiki',
            'termux': 'Termux Wiki',
            'urban-prepper': 'Urban Prepper',
            'citizendium.org': 'Citizendium',
            'fas-military-medicine': 'Military Medicine',
            'quickguidesformedicine': 'Quick Medical Guides',
            'internet-encyclopedia-philosophy': 'Internet Encyclopedia of Philosophy',
            'libretexts.org': 'LibreTexts',
            'wikitech': 'WikiTech',
            'internetarchive': 'Internet Archive'
        }
        
        return name_mapping.get(base_name, base_name.replace('-', ' ').title())
    
    return "Unknown"

def generate_download_url(viewer_url: str) -> str:
    """Convert viewer URL to download URL."""
    # Extract the content identifier from viewer URL
    match = re.search(r'#(.+)$', viewer_url)
    if match:
        content_id = match.group(1)
        # Convert to download URL format
        return f"https://download.kiwix.org/zim/zimit/{content_id}.zim"
    
    return viewer_url

def generate_local_viewer_url(viewer_url: str) -> str:
    """Generate local viewer URL for self-hosted Kiwix service."""
    # Extract the content identifier from viewer URL
    match = re.search(r'#(.+)$', viewer_url)
    if match:
        content_id = match.group(1)
        # Point to the library interface - this works reliably
        # Users can click on the archive to open it
        return f"https://archive.brennan.page/kiwix/"
    
    return viewer_url

def categorize_archive(name: str, url: str) -> str:
    """Categorize archive based on name and URL."""
    name_lower = name.lower()
    url_lower = url.lower()
    
    if 'wikipedia' in name_lower or 'gutenberg' in name_lower or 'citizendium' in name_lower:
        return 'Encyclopedias'
    elif 'devdocs' in name_lower or 'python' in name_lower or 'php' in name_lower or 'archlinux' in name_lower:
        return 'Technical Documentation'
    elif 'ted' in name_lower or 'freecodecamp' in name_lower:
        return 'Education'
    elif 'medline' in name_lower or 'medical' in name_lower or 'medicine' in name_lower:
        return 'Medical'
    elif 'openstreetmap' in name_lower or 'termux' in name_lower:
        return 'Tools & Utilities'
    elif 'urban-prepper' in name_lower:
        return 'Prepping'
    else:
        return 'General Knowledge'

def convert_urls(input_file: str, output_file: str = None) -> Tuple[List[Dict], str]:
    """Convert URLs from input file and return structured data and HTML."""
    archives = []
    
    with open(input_file, 'r') as f:
        content = f.read()
    
    # Find all URLs
    urls = re.findall(r'https://browse\.library\.kiwix\.org/viewer#.+', content)
    
    for url in urls:
        name = extract_name_from_url(url)
        download_url = generate_download_url(url)
        local_viewer_url = generate_local_viewer_url(url)
        category = categorize_archive(name, url)
        
        archives.append({
            'name': name,
            'viewer_url': local_viewer_url,
            'download_url': download_url,
            'category': category
        })
    
    # Generate HTML
    html = generate_archive_html(archives)
    
    if output_file:
        with open(output_file, 'w') as f:
            f.write(html)
    
    return archives, html

def generate_archive_html(archives: List[Dict]) -> str:
    """Generate HTML for archive homepage."""
    # Group by category
    categories = {}
    for archive in archives:
        cat = archive['category']
        if cat not in categories:
            categories[cat] = []
        categories[cat].append(archive)
    
    # Sort categories and archives within each category
    sorted_categories = sorted(categories.keys())
    
    html = """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kiwix Archive Library</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 40px;
            color: white;
        }
        
        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        .stats {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }
        
        .stat {
            background: rgba(255,255,255,0.1);
            padding: 15px 25px;
            border-radius: 10px;
            text-align: center;
            backdrop-filter: blur(10px);
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #fff;
        }
        
        .stat-label {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
        }
        
        .category {
            background: rgba(255,255,255,0.95);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
        }
        
        .category h2 {
            color: #4a5568;
            margin-bottom: 20px;
            font-size: 1.5rem;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 10px;
        }
        
        .archives {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 15px;
        }
        
        .archive-card {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 20px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .archive-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        
        .archive-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .archive-title {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 10px;
            font-size: 1.1rem;
        }
        
        .archive-links {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-view {
            background: #667eea;
            color: white;
        }
        
        .btn-view:hover {
            background: #5a67d8;
            transform: translateY(-1px);
        }
        
        .btn-download {
            background: #48bb78;
            color: white;
        }
        
        .btn-download:hover {
            background: #38a169;
            transform: translateY(-1px);
        }
        
        .footer {
            text-align: center;
            margin-top: 40px;
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .archives {
                grid-template-columns: 1fr;
            }
            
            .stats {
                gap: 15px;
            }
            
            .stat {
                padding: 10px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header class="header">
            <h1>📚 Kiwix Archive Library</h1>
            <p>Offline access to essential knowledge and educational resources</p>
        </header>
        
        <div class="stats">
            <div class="stat">
                <div class="stat-number">{total_archives}</div>
                <div class="stat-label">Total Archives</div>
            </div>
            <div class="stat">
                <div class="stat-number">{total_categories}</div>
                <div class="stat-label">Categories</div>
            </div>
            <div class="stat">
                <div class="stat-number">24/7</div>
                <div class="stat-label">Available</div>
            </div>
        </div>
        
        {categories_html}
        
        <footer class="footer">
            <p>Powered by Kiwix | Part of brennan.page Homelab</p>
        </footer>
    </div>
</body>
</html>"""
    
    # Generate categories HTML
    categories_html = ""
    for category in sorted_categories:
        archives_html = ""
        for archive in sorted(categories[category], key=lambda x: x['name']):
            archives_html += f"""
                <div class="archive-card">
                    <div class="archive-title">{archive['name']}</div>
                    <div class="archive-links">
                        <a href="{archive['viewer_url']}" class="btn btn-view" target="_blank">📖 View</a>
                        <a href="{archive['download_url']}" class="btn btn-download" target="_blank">⬇️ Download</a>
                    </div>
                </div>"""
        
        categories_html += f"""
        <div class="category">
            <h2>{category} ({len(categories[category])})</h2>
            <div class="archives">
                {archives_html}
            </div>
        </div>"""
    
    # Replace placeholders
    html = html.replace("{total_archives}", str(len(archives)))
    html = html.replace("{total_categories}", str(len(sorted_categories)))
    html = html.replace("{categories_html}", categories_html)
    
    return html

if __name__ == "__main__":
    import sys
    
    input_file = sys.argv[1] if len(sys.argv) > 1 else "Docker KiwiX URLs.txt"
    output_file = sys.argv[2] if len(sys.argv) > 2 else "archive_homepage.html"
    
    try:
        archives, html = convert_urls(input_file, output_file)
        print(f"✅ Processed {len(archives)} archives")
        print(f"📁 Generated {output_file}")
        
        # Print summary by category
        categories = {}
        for archive in archives:
            cat = archive['category']
            categories[cat] = categories.get(cat, 0) + 1
        
        print("\n📊 Archive Summary:")
        for category, count in sorted(categories.items()):
            print(f"  {category}: {count}")
            
    except FileNotFoundError:
        print(f"❌ Error: Could not find input file '{input_file}'")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)
