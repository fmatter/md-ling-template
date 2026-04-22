#!/usr/bin/env python3
"""
Cross-platform build helper for md-ling-template.

This script provides a unified interface for building documents in both
single-file and multi-file (project) modes, with proper DOCX post-processing.

Usage:
    # Single file
    python3 pandoc/build.py input.md [-o output.pdf]
    
    # Multi-file project (uses project.yaml)
    python3 pandoc/build.py --project [-o output.pdf]
    
    # DOCX with post-processing
    python3 pandoc/build.py input.md -o output.docx
    python3 pandoc/build.py --project -o output.docx
"""

import argparse
import re
import subprocess
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    yaml = None


def extract_yaml_frontmatter(markdown_file):
    """
    Extract and parse YAML frontmatter from a markdown file.
    Returns a dict with the metadata, or None if no frontmatter or parsing fails.
    """
    try:
        content = Path(markdown_file).read_text(encoding='utf-8')
        
        # Check for YAML frontmatter (--- at start, --- after metadata)
        if not content.startswith('---'):
            return None
        
        # Find the closing ---
        lines = content.split('\n')
        end_idx = None
        for i in range(1, len(lines)):
            if lines[i].strip() in ('---', '...'):
                end_idx = i
                break
        
        if end_idx is None:
            return None
        
        # Extract YAML content
        yaml_content = '\n'.join(lines[1:end_idx])
        
        # Parse YAML if pyyaml is available
        if yaml:
            try:
                return yaml.safe_load(yaml_content)
            except yaml.YAMLError:
                return None
        else:
            # Fallback: simple regex-based extraction for documentclass
            match = re.search(r'^\s*documentclass:\s*(\S+)', yaml_content, re.MULTILINE)
            if match:
                return {'documentclass': match.group(1)}
            return {}
    except Exception:
        return None


def run_pandoc(args_list):
    """Run pandoc with the given arguments."""
    try:
        result = subprocess.run(
            ["pandoc"] + args_list,
            check=True,
            capture_output=True,
            text=True
        )
        return result.returncode == 0
    except subprocess.CalledProcessError as e:
        print(f"Error running pandoc:", file=sys.stderr)
        print(e.stderr, file=sys.stderr)
        sys.exit(1)
    except FileNotFoundError:
        print("Error: pandoc not found. Please install pandoc.", file=sys.stderr)
        sys.exit(1)


def run_fix_docx(docx_file):
    """Run the DOCX post-processing script."""
    try:
        subprocess.run(
            ["python3", "pandoc/filters/fix_docx.py", str(docx_file)],
            check=True
        )
    except subprocess.CalledProcessError as e:
        print(f"Warning: DOCX post-processing failed: {e}", file=sys.stderr)
    except FileNotFoundError:
        print("Warning: fix_docx.py not found. Skipping post-processing.", file=sys.stderr)


def build_single_file(input_file, output_file):
    """Build a single markdown file."""
    input_path = Path(input_file)
    
    if not input_path.exists():
        print(f"Error: Input file not found: {input_file}", file=sys.stderr)
        sys.exit(1)
    
    # Determine output file if not specified
    if output_file is None:
        output_file = input_path.with_suffix(".pdf")
    
    output_path = Path(output_file)
    
    # Check if this is a Beamer presentation
    metadata = extract_yaml_frontmatter(input_path)
    is_beamer = metadata and metadata.get('documentclass') == 'beamer'
    has_documentclass = metadata and 'documentclass' in metadata
    
    # Build pandoc arguments
    pandoc_args = [
        str(input_path),
        "--defaults=pandoc/defaults.yaml"
    ]
    
    # Set default documentclass to scrartcl if not specified in document
    if not has_documentclass:
        pandoc_args.append("--metadata=documentclass:scrartcl")
    
    # Add format-specific flags
    if output_path.suffix in ['.pdf', '.tex']:
        if is_beamer:
            # Beamer presentations need -t beamer
            pandoc_args.extend(["-t", "beamer"])
        else:
            # Regular documents use the custom template
            pandoc_args.append("--template=pandoc/templates/default.latex")
        
        # For .tex output, extract media (converts SVGs to PDFs, etc.)
        if output_path.suffix == '.tex':
            media_dir = output_path.parent / (output_path.stem + "_media")
            pandoc_args.append(f"--extract-media={media_dir}")
    elif output_path.suffix == '.html' and is_beamer:
        # Beamer presentations to HTML use slidy
        pandoc_args.extend(["-t", "slidy", "--embed-resources", "--standalone"])
    
    pandoc_args.extend(["-o", str(output_path)])
    
    print(f"Building {input_path} → {output_path}")
    run_pandoc(pandoc_args)
    
    # Post-process DOCX files
    if output_path.suffix == '.docx':
        print(f"Post-processing {output_path}")
        run_fix_docx(output_path)
    
    print(f"✓ Created {output_path}")


def build_project(output_file):
    """Build using project.yaml configuration."""
    project_yaml = Path("project.yaml")
    
    if not project_yaml.exists():
        print("Error: project.yaml not found.", file=sys.stderr)
        print("Copy project.yaml.template to project.yaml and configure it for your project.", file=sys.stderr)
        sys.exit(1)
    
    # Determine output file
    if output_file is None:
        output_file = "output.pdf"
    
    output_path = Path(output_file)
    
    # Build pandoc arguments
    pandoc_args = [
        "--defaults=pandoc/defaults.yaml",
        "--defaults=project.yaml"
        
        # For .tex output, extract media (converts SVGs to PDFs, etc.)
        if output_path.suffix == '.tex':
            media_dir = output_path.parent / (output_path.stem + "_media")
            pandoc_args.append(f"--extract-media={media_dir}")
    ]
    
    # Add template for LaTeX/PDF output
    if output_path.suffix in ['.pdf', '.tex']:
        pandoc_args.append("--template=pandoc/templates/default.latex")
    
    pandoc_args.extend(["-o", str(output_path)])
    
    print(f"Building project → {output_path}")
    run_pandoc(pandoc_args)
    
    # Post-process DOCX files
    if output_path.suffix == '.docx':
        print(f"Post-processing {output_path}")
        run_fix_docx(output_path)
    
    print(f"✓ Created {output_path}")


def main():
    parser = argparse.ArgumentParser(
        description="Build documents with md-ling-template",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Single file to PDF
  python3 pandoc/build.py article.md
  
  # Single file to HTML
  python3 pandoc/build.py article.md -o article.html
  
  # Multi-file project (uses project.yaml)
  python3 pandoc/build.py --project
  
  # Multi-file to DOCX with custom name
  python3 pandoc/build.py --project -o thesis.docx
        """
    )
    
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "input",
        nargs="?",
        help="Input markdown file (for single-file mode)"
    )
    group.add_argument(
        "--project",
        action="store_true",
        help="Build using project.yaml (for multi-file projects)"
    )
    
    parser.add_argument(
        "-o", "--output",
        help="Output file (default: input filename with .pdf extension)"
    )
    
    args = parser.parse_args()
    
    if args.project:
        build_project(args.output)
    else:
        build_single_file(args.input, args.output)


if __name__ == "__main__":
    main()
