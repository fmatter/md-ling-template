# md-ling-template build recipes
# ================================
# Cross-platform build commands using 'just' (https://github.com/casey/just)
#
# Install just:
#   macOS:   brew install just
#   Linux:   apt install just  (or see https://github.com/casey/just#packages)
#   Windows: winget install Casey.Just
#
# Usage:
#   just              # Show available recipes
#   just pdf          # Build to PDF (auto-detects project.yaml or content.md)
#   just pdf my.md    # Build specific file to PDF
#   just html         # Build to HTML
#   just docx my.md   # Build specific file to DOCX
#   just check        # Check for undefined glossing abbreviations in output.html

# Display available recipes
default:
    @just --list

# Build to PDF (optional: specify filename, or auto-detects project.yaml/content.md)
pdf file="":
    #!/usr/bin/env bash
    if [ -n "{{file}}" ]; then \
        python3 pandoc/build.py "{{file}}"; \
    elif [ -f project.yaml ]; then \
        python3 pandoc/build.py --project -o output.pdf; \
    elif [ -f content.md ]; then \
        python3 pandoc/build.py content.md -o output.pdf; \
    else \
        echo "Error: No file specified and no project.yaml or content.md found."; \
        echo "Usage: just pdf [filename.md]"; \
        echo "Or create project.yaml (multi-file) or content.md (single-file)"; \
        exit 1; \
    fi

# Build to HTML (optional: specify filename, or auto-detects project.yaml/content.md)
html file="":
    #!/usr/bin/env bash
    if [ -n "{{file}}" ]; then \
        FILE="{{file}}"; \
        python3 pandoc/build.py "$FILE" -o "${FILE%.md}.html"; \
    elif [ -f project.yaml ]; then \
        python3 pandoc/build.py --project -o output.html; \
    elif [ -f content.md ]; then \
        python3 pandoc/build.py content.md -o output.html; \
    else \
        echo "Error: No file specified and no project.yaml or content.md found."; \
        echo "Usage: just html [filename.md]"; \
        echo "Or create project.yaml (multi-file) or content.md (single-file)"; \
        exit 1; \
    fi

# Build to DOCX with post-processing (optional: specify filename, or auto-detects project.yaml/content.md)
docx file="":
    #!/usr/bin/env bash
    if [ -n "{{file}}" ]; then \
        FILE="{{file}}"; \
        python3 pandoc/build.py "$FILE" -o "${FILE%.md}.docx"; \
    elif [ -f project.yaml ]; then \
        python3 pandoc/build.py --project -o output.docx; \
    elif [ -f content.md ]; then \
        python3 pandoc/build.py content.md -o output.docx; \
    else \
        echo "Error: No file specified and no project.yaml or content.md found."; \
        echo "Usage: just docx [filename.md]"; \
        echo "Or create project.yaml (multi-file) or content.md (single-file)"; \
        exit 1; \
    fi

# Build to LaTeX (optional: specify filename, or auto-detects project.yaml/content.md)
tex file="":
    #!/usr/bin/env bash
    if [ -n "{{file}}" ]; then \
        FILE="{{file}}"; \
        pandoc "$FILE" --defaults=pandoc/defaults.yaml --template=pandoc/templates/default.latex -o "${FILE%.md}.tex"; \
    elif [ -f project.yaml ]; then \
        pandoc --defaults=pandoc/defaults.yaml --defaults=project.yaml --template=pandoc/templates/default.latex -o output.tex; \
    elif [ -f content.md ]; then \
        pandoc content.md --defaults=pandoc/defaults.yaml --template=pandoc/templates/default.latex -o output.tex; \
    else \
        echo "Error: No file specified and no project.yaml or content.md found."; \
        echo "Usage: just tex [filename.md]"; \
        echo "Or create project.yaml (multi-file) or content.md (single-file)"; \
        exit 1; \
    fi

# Build demo.md to all formats and check glossing
demo:
    python3 pandoc/build.py demo.md -o demo.tex
    python3 pandoc/build.py demo.md -o demo.pdf
    python3 pandoc/build.py demo.md -o demo.html
    python3 pandoc/build.py demo.md -o demo.docx
    python3 check_gloss_markup.py demo.html demo.md

# Check HTML file for undefined glossing abbreviations (defaults to output.html)
check htmlfile="output.html":
    python3 check_gloss_markup.py {{htmlfile}}

# Sync MPE CSS (run after editing pandoc/style.css)
sync-css:
    @echo "/* Auto-generated from pandoc/style.css - DO NOT EDIT DIRECTLY */" > .crossnote/style.less
    @echo "/* Run: just sync-css to update */" >> .crossnote/style.less
    @echo "" >> .crossnote/style.less
    @cat pandoc/style.css >> .crossnote/style.less
    @echo "✓ Synced pandoc/style.css → .crossnote/style.less"

# Clean generated files
clean:
    rm -f output.pdf output.html output.docx output.tex
    rm -f demo.pdf demo.html demo.docx demo.tex demo_postprocessed.docx

# Show template version info
info:
    @echo "md-ling-template"
    @echo "================"
    @echo ""
    @pandoc --version | head -2
    @echo ""
    @python3 --version
    @echo ""
    @if [ -f project.yaml ]; then \
        echo "✓ Mode: Multi-file (project.yaml configured)"; \
    elif [ -f content.md ]; then \
        echo "✓ Mode: Single-file (content.md found)"; \
    else \
        echo "⚠ No project.yaml or content.md - create one to get started"; \
    fi
