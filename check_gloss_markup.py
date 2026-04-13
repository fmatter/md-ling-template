#!/usr/bin/env python3
"""
Check for undefined glossing abbreviations in HTML output.

Scans HTML output to find all small-caps abbreviations created by pandoc-ling
in interlinear glossing examples (e.g., NOM, ACC, 3SG from gloss lines like
"go.IND.3" → "go" <IND> <3>). Compares against glossing-abbreviations defined
in the source document's YAML frontmatter and warns about any missing definitions.

Automatically excludes standard Leipzig Glossing Rules abbreviations.

This post-processing check catches all undefined abbreviations at once,
complementing the Lua filter's build-time warnings.

Usage: python3 check_gloss_markup.py output.html [source.md]
       If source.md is omitted, infers from output.html filename.
"""

import sys
import re
from pathlib import Path
from html.parser import HTMLParser


# Standard Leipzig Glossing Rules abbreviations (hardcoded)
LEIPZIG_ABBREVIATIONS = {
    '1', '2', '3', 'A', 'ABL', 'ABS', 'ACC', 'ADJ', 'ADV', 'AGR', 'ALL',
    'ANTIP', 'APPL', 'ART', 'AUX', 'BEN', 'CAUS', 'CLF', 'COM', 'COMP',
    'COMPL', 'COND', 'COP', 'CVB', 'DAT', 'DECL', 'DEF', 'DEM', 'DET',
    'DIST', 'DISTR', 'DU', 'DUR', 'ERG', 'EXCL', 'F', 'FOC', 'FUT', 'GEN',
    'IMP', 'INCL', 'IND', 'INDF', 'INF', 'INS', 'INTR', 'IPFV', 'IRR',
    'LOC', 'M', 'N', 'NEG', 'NMLZ', 'NOM', 'OBJ', 'OBL', 'P', 'PASS',
    'PFV', 'PL', 'POSS', 'PRED', 'PRF', 'PRS', 'PROG', 'PROH', 'PROX',
    'PST', 'PTCP', 'PURP', 'Q', 'QUOT', 'RECP', 'REFL', 'REL', 'RES',
    'S', 'SBJ', 'SBJV', 'SG', 'TOP', 'TR', 'VOC'
}


class SmallCapsParser(HTMLParser):
    """Extract text content from <span class="smallcaps"> elements within gloss cells."""
    
    def __init__(self):
        super().__init__()
        self.abbreviations = []
        self.in_gloss_cell = False
        self.in_smallcaps = False
        self.current_text = []
        self.tag_stack = []
    
    def handle_starttag(self, tag, attrs):
        self.tag_stack.append(tag)
        
        if tag == 'td':
            for attr, value in attrs:
                if attr == 'class' and 'linguistic-example-gloss' in value:
                    self.in_gloss_cell = True
        
        if tag == 'span' and self.in_gloss_cell:
            for attr, value in attrs:
                if attr == 'class' and 'smallcaps' in value:
                    self.in_smallcaps = True
                    self.current_text = []
    
    def handle_endtag(self, tag):
        if self.tag_stack:
            self.tag_stack.pop()
        
        if tag == 'td' and self.in_gloss_cell:
            self.in_gloss_cell = False
        
        if tag == 'span' and self.in_smallcaps:
            text = ''.join(self.current_text).strip()
            if text:
                self.abbreviations.append(text.upper())
            self.in_smallcaps = False
            self.current_text = []
    
    def handle_data(self, data):
        if self.in_smallcaps:
            self.current_text.append(data)


def is_leipzig_combo(abbrev, leipzig):
    """
    Check if an abbreviation is a combination of Leipzig abbreviations.
    
    Examples:
    - 2SG → 2 + SG (both Leipzig)
    - 3PL → 3 + PL (both Leipzig)
    - 1SG.NOM → 1SG + NOM → (1 + SG) + NOM (all Leipzig)
    """
    # Check if starts with person marker (1/2/3) followed by another Leipzig abbrev
    if abbrev[0] in '123' and len(abbrev) > 1:
        rest = abbrev[1:]
        if rest in leipzig:
            return True
        # Check if rest can be further decomposed
        if is_leipzig_combo(rest, leipzig):
            return True
    
    # Check if contains separators (., -, etc.) and all parts are Leipzig
    for sep in ['.', '-', '_']:
        if sep in abbrev:
            parts = abbrev.split(sep)
            if all(part in leipzig or is_leipzig_combo(part, leipzig) for part in parts):
                return True
    
    return False


def extract_smallcaps_from_html(html_file):
    """Extract all small-caps abbreviations from gloss cells in HTML file."""
    parser = SmallCapsParser()
    parser.feed(html_file.read_text())
    return set(parser.abbreviations)


def extract_defined_abbreviations(yaml_file):
    """Extract glossing-abbreviations from YAML file (frontmatter or metadata.yaml)."""
    content = yaml_file.read_text()
    
    # For regular markdown files with frontmatter
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            yaml_content = parts[1]
        else:
            return set()
    else:
        # For metadata.yaml files
        yaml_content = content
    
    # Find glossing-abbreviations section
    defined = set()
    in_glossing = False
    
    for line in yaml_content.split('\n'):
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
    
    # Extract defined abbreviations from source file(s)
    defined_abbrevs = set()
    
    # Check source markdown file
    if md_file.exists():
        defined_abbrevs.update(extract_defined_abbreviations(md_file))
    
    # Check metadata.yaml in same directory
    metadata_yaml = html_file.parent / 'metadata.yaml'
    if metadata_yaml.exists():
        defined_abbrevs.update(extract_defined_abbreviations(metadata_yaml))
    
    # Filter out Leipzig abbreviations and combinations
    leipzig_used = set()
    for abbrev in list(used_abbrevs):
        if abbrev in LEIPZIG_ABBREVIATIONS or is_leipzig_combo(abbrev, LEIPZIG_ABBREVIATIONS):
            leipzig_used.add(abbrev)
    
    # Calculate undefined abbreviations
    undefined = used_abbrevs - defined_abbrevs - leipzig_used
    custom_defined = defined_abbrevs - LEIPZIG_ABBREVIATIONS
    
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
        
        if custom_defined:
            print(f"✓ Custom abbreviations defined: {', '.join(sorted(custom_defined))}")
        
        if leipzig_used:
            print(f"✓ Leipzig abbreviations used: {', '.join(sorted(leipzig_used))}")
        
        print()
        
        sys.exit(1)
    else:
        custom_used = used_abbrevs - leipzig_used
        
        print(f"✓ All {len(used_abbrevs)} glossing abbreviations are defined")
        
        if leipzig_used:
            print(f"  Leipzig: {', '.join(sorted(leipzig_used))}")
        if custom_used:
            print(f"  Custom: {', '.join(sorted(custom_used))}")
        
        sys.exit(0)


if __name__ == '__main__':
    main()
