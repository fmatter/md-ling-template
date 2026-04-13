#!/usr/bin/env python3
"""
Post-process DOCX files to fix table formatting and apply custom styles.

Usage: python fix_docx.py input.docx [output.docx]

This script:
1. Sets all tables to autofit (minimal column width)
2. Applies custom character styles for linguistic markup:
   - .gl (gloss) → small caps
   - .ob (object language) → italic
   - .rc (reconstructed) → italic with asterisk prefix

If no output file is specified, modifies the input file in place.
"""

import sys
from pathlib import Path
from docx import Document
from docx.shared import Pt
from docx.oxml.ns import qn
from docx.oxml import OxmlElement


def set_table_autofit(table):
    """
    Set a table to autofit to contents.
    
    This sets the table layout to 'autofit' which makes columns
    adjust to their content width automatically.
    """
    try:
        # Access the table's XML to set autofit
        tbl = table._element
        tblPr = tbl.tblPr
        
        # Create or get tblLayout element
        tblLayout = tblPr.find(qn('w:tblLayout'))
        if tblLayout is None:
            tblLayout = OxmlElement('w:tblLayout')
            tblPr.append(tblLayout)
        
        # Set type to "autofit"
        tblLayout.set(qn('w:type'), 'autofit')
        
        # Also set table width to auto
        tblW = tblPr.find(qn('w:tblW'))
        if tblW is None:
            tblW = OxmlElement('w:tblW')
            tblPr.append(tblW)
        tblW.set(qn('w:type'), 'auto')
        tblW.set(qn('w:w'), '0')
        
        return True
    except Exception as e:
        print(f"  Warning: Could not set autofit for table: {e}", file=sys.stderr)
        return False


def fix_table_columns(doc):
    """Set all tables to autofit to contents (minimal column width)."""
    table_count = 0
    for table in doc.tables:
        if set_table_autofit(table):
            table_count += 1
    return table_count


def apply_custom_styles(doc):
    """
    Apply custom formatting to spans with specific classes.
    
    Note: Pandoc converts markdown spans like [text]{.gl} to custom character
    styles in DOCX. This function ensures those styles are properly defined.
    """
    styles_applied = 0
    
    # Check if custom character styles exist, create if not
    styles = doc.styles
    
    # Define style names and their formatting
    style_definitions = {
        'gl': {'small_caps': True, 'italic': False},
        'gloss': {'small_caps': True, 'italic': False},  # Alternative name
        'ob': {'small_caps': False, 'italic': True},
        'rc': {'small_caps': False, 'italic': True},
    }
    
    for style_name, formatting in style_definitions.items():
        try:
            # Try to get or create the character style
            try:
                style = styles[style_name]
            except KeyError:
                # Style doesn't exist, create it
                from docx.enum.style import WD_STYLE_TYPE
                style = styles.add_style(style_name, WD_STYLE_TYPE.CHARACTER)
            
            # Apply formatting
            if formatting['small_caps']:
                style.font.small_caps = True
            if formatting['italic']:
                style.font.italic = True
            
            styles_applied += 1
        except Exception as e:
            print(f"Warning: Could not create/modify style '{style_name}': {e}", file=sys.stderr)
    
    return styles_applied


def process_docx(input_path, output_path=None):
    """Process a DOCX file with table and style fixes."""
    if output_path is None:
        output_path = input_path
    
    print(f"Processing {input_path}...")
    
    try:
        doc = Document(input_path)
    except Exception as e:
        print(f"Error: Could not open {input_path}: {e}", file=sys.stderr)
        return False
    
    # Fix tables
    table_count = fix_table_columns(doc)
    print(f"  ✓ Fixed {table_count} tables (set to autofit)")
    
    # Apply custom styles
    styles_count = apply_custom_styles(doc)
    print(f"  ✓ Ensured {styles_count} custom character styles are defined")
    
    # Save
    try:
        doc.save(output_path)
        print(f"  ✓ Saved to {output_path}")
        return True
    except Exception as e:
        print(f"Error: Could not save to {output_path}: {e}", file=sys.stderr)
        return False


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    
    input_path = Path(sys.argv[1])
    
    if not input_path.exists():
        print(f"Error: File not found: {input_path}", file=sys.stderr)
        sys.exit(1)
    
    if not input_path.suffix.lower() == '.docx':
        print(f"Error: Input file must be .docx, got: {input_path.suffix}", file=sys.stderr)
        sys.exit(1)
    
    output_path = Path(sys.argv[2]) if len(sys.argv) > 2 else input_path
    
    success = process_docx(input_path, output_path)
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
