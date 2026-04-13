#!/usr/bin/env python3
"""
Check for undefined glossing abbreviations in HTML output.

Scans HTML output to find all small-caps abbreviations created by pandoc-ling
in interlinear glossing examples (e.g., NOM, ACC, 3SG from gloss lines like
"go.IND.3" → "go" <IND> <3>). Compares against glossing-abbreviations defined
in the source document's YAML frontmatter and warns about any missing definitions.

This post-processing check catches all undefined abbreviations at once,
complementing the Lua filter's build-time warnings.

Usage: python3 check_gloss_markup.py output.html [source.md]
       If source.md is omitted, infers from output.html filename.
"""

import sys
import re
from pathlib import Path
from html.parser import HTMLParser


class SmallCapsParser(HTMLParser):
    """Extract text content from <span class="smallcaps"> elements."""
    
    def __init__(self):
        super().__init__()
        self.abbreviations = []
        self.in_smallcaps = False
        self.current_text = []
    
    def handle_starttag(self, tag, attrs):
        if tag == 'span':
            for attr, value in attrs:
                if attr == 'class' and 'smallcaps' in value:
                    self.in_smallcaps = True
                    self.current_text = []
    
    def handle_endtag(self, tag):
        if tag == 'span' and self.in_smallcaps:
            text = ''.join(self.current_text).strip()
            if text:
                self.abbreviations.append(text.upper())
            self.in_smallcaps = False
            self.current_text = []
    
    def handle_data(self, data):
        if self.in_smallcaps:
            self.current_text.append(data)


def extract_smallcaps_from_html(html_file):
    """Extract all small-caps abbreviations from HTML file."""
    parser = SmallCapsParser()
    parser.feed(html_file.read_text())
    return set(parser.abbreviations)


def extract_defined_abbreviations(md_file):
    """Extract glossing-abbreviations from YAML frontmatter."""
    content = md_file.read_text()
    
    # Find YAML frontmatter
    if not content.startswith('---'):
        return set()
    
    # Extract frontmatter
    parts = content.split('---', 2)
    if len(parts) < 3:
        return set()
    
    frontmatter = parts[1]
    
    # Find glossing-abbreviations section
    defined = set()
    in_glossing = False
    
    for line in frontmatter.split('\n'):
        stripped = line.strip()
        
        # Start of glossing-abbreviations section
        if stripped.startswith('glossing-abbreviations:'):
            in_glossing = True
            continue
        
        # End of section (new top-level key)
        if in_glossing and line and not line[0].isspace():
            break
        
        # Parse abbreviation definitions
        if in_glossing and ':' in stripped:
            abbrev = stripped.split(':')[0].strip()
            if abbrev:
                defined.add(abbrev.upper())
    
    return defined


def main():
    # Parse arguments
    if len(sys.argv) < 2:
        print("Usage: python3 check_gloss_markup.py output.html [source.md]", file=sys.stderr)
        sys.exit(1)
    
    html_file = Path(sys.argv[1])
    
    # Try to infer source .md file from HTML filename
    if len(sys.argv) > 2:
        md_file = Path(sys.argv[2])
    else:
        md_file = html_file.with_suffix('.md')
    
    # Check files exist
    if not html_file.exists():
        print(f"Error: HTML file not found: {html_file}", file=sys.stderr)
        sys.exit(1)
    
    # Extract abbreviations from HTML
    used_abbrevs = extract_smallcaps_from_html(html_file)
    
    if not used_abbrevs:
        print("✓ No glossing abbreviations found in HTML output")
        sys.exit(0)
    
    # Extract defined abbreviations from source
    if md_file.exists():
        defined_abbrevs = extract_defined_abbreviations(md_file)
        undefined = used_abbrevs - defined_abbrevs
    else:
        # If no source file, report all abbreviations
        undefined = used_abbrevs
        defined_abbrevs = set()
    
    # Report findings
    if undefined:
        print(f"\n⚠️  Found {len(undefined)} undefined glossing abbreviations in {html_file.name}:\n")
        
        for abbrev in sorted(undefined):
            print(f"  {abbrev}")
        
        print("\n💡 These abbreviations appear in your interlinear examples but are not")
        print("   defined in the document metadata. Add them to avoid warnings:\n")
        print("📋 Copy this to your document metadata:\n")
        print("glossing-abbreviations:")
        for abbrev in sorted(undefined):
            print(f"  {abbrev}: DEFINITION")
        print()
        
        if defined_abbrevs:
            print(f"✓ Already defined: {', '.join(sorted(defined_abbrevs))}\n")
        
        sys.exit(1)
    else:
        print(f"✓ All {len(used_abbrevs)} glossing abbreviations are defined")
        print(f"  {', '.join(sorted(used_abbrevs))}")
        sys.exit(0)


if __name__ == '__main__':
    main()
