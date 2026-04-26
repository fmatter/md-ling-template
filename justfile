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
#   just figures      # Compile LaTeX figures in figures/ to SVG
#   just check        # Check for undefined glossing abbreviations in output.html

# Display available recipes
default:
    @just --list

# Build to PDF (optional: specify filename, or auto-detects project.yaml/content.md)
# Optional template parameter: just pdf my.md templates/thesis.latex
pdf file="" template="":
    #!/usr/bin/env bash
    TEMPLATE_ARG=""; \
    if [ -n "{{template}}" ]; then \
        TEMPLATE_ARG="--template={{template}}"; \
    fi; \
    if [ -n "{{file}}" ]; then \
        python3 pandoc/build.py "{{file}}" $TEMPLATE_ARG; \
    elif [ -f project.yaml ]; then \
        python3 pandoc/build.py --project $TEMPLATE_ARG -o output.pdf; \
    elif [ -f content.md ]; then \
        python3 pandoc/build.py content.md $TEMPLATE_ARG -o output.pdf; \
    else \
        echo "Error: No file specified and no project.yaml or content.md found."; \
        echo "Usage: just pdf [filename.md] [template]"; \
        echo "Or create project.yaml (multi-file) or content.md (single-file)"; \
        exit 1; \
    fi

# Build to HTML (optional: specify filename, or auto-detects project.yaml/content.md)
# Optional template parameter: just html my.md templates/custom.html
html file="" template="":
    #!/usr/bin/env bash
    TEMPLATE_ARG=""; \
    if [ -n "{{template}}" ]; then \
        TEMPLATE_ARG="--template={{template}}"; \
    fi; \
    if [ -n "{{file}}" ]; then \
        FILE="{{file}}"; \
        python3 pandoc/build.py "$FILE" $TEMPLATE_ARG -o "${FILE%.md}.html"; \
    elif [ -f project.yaml ]; then \
        python3 pandoc/build.py --project $TEMPLATE_ARG -o output.html; \
    elif [ -f content.md ]; then \
        python3 pandoc/build.py content.md $TEMPLATE_ARG -o output.html; \
    else \
        echo "Error: No file specified and no project.yaml or content.md found."; \
        echo "Usage: just html [filename.md] [template]"; \
        echo "Or create project.yaml (multi-file) or content.md (single-file)"; \
        exit 1; \
    fi

# Build to DOCX with post-processing (optional: specify filename, or auto-detects project.yaml/content.md)
# Optional template parameter: just docx my.md templates/custom.latex
docx file="" template="":
    #!/usr/bin/env bash
    TEMPLATE_ARG=""; \
    if [ -n "{{template}}" ]; then \
        TEMPLATE_ARG="--template={{template}}"; \
    fi; \
    if [ -n "{{file}}" ]; then \
        FILE="{{file}}"; \
        python3 pandoc/build.py "$FILE" $TEMPLATE_ARG -o "${FILE%.md}.docx"; \
    elif [ -f project.yaml ]; then \
        python3 pandoc/build.py --project $TEMPLATE_ARG -o output.docx; \
    elif [ -f content.md ]; then \
        python3 pandoc/build.py content.md $TEMPLATE_ARG -o output.docx; \
    else \
        echo "Error: No file specified and no project.yaml or content.md found."; \
        echo "Usage: just docx [filename.md] [template]"; \
        echo "Or create project.yaml (multi-file) or content.md (single-file)"; \
        exit 1; \
    fi

# Build to LaTeX (optional: specify filename, or auto-detects project.yaml/content.md)
# Optional template parameter: just tex my.md templates/thesis.latex
tex file="" template="":
    #!/usr/bin/env bash
    TEMPLATE_ARG=""; \
    if [ -n "{{template}}" ]; then \
        TEMPLATE_ARG="--template={{template}}"; \
    fi; \
    if [ -n "{{file}}" ]; then \
        FILE="{{file}}"; \
        python3 pandoc/build.py "$FILE" $TEMPLATE_ARG -o "${FILE%.md}.tex"; \
    elif [ -f project.yaml ]; then \
        python3 pandoc/build.py --project $TEMPLATE_ARG -o output.tex; \
    elif [ -f content.md ]; then \
        python3 pandoc/build.py content.md $TEMPLATE_ARG -o output.tex; \
    else \
        echo "Error: No file specified and no project.yaml or content.md found."; \
        echo "Usage: just tex [filename.md] [template]"; \
        echo "Or create project.yaml (multi-file) or content.md (single-file)"; \
        exit 1; \
    fi

# Build blueprints/{article/book/slides}.md to all formats and check glossing
blueprints:
    @echo "Building article.md..."
    python3 pandoc/build.py blueprints/article.md -o blueprints/article.pdf
    python3 pandoc/build.py blueprints/article.md -o blueprints/article.html
    python3 pandoc/build.py blueprints/article.md -o blueprints/article.docx
    python3 pandoc/build.py blueprints/article.md -o blueprints/article.tex
    python3 pandoc/check_gloss_markup.py blueprints/article.html
    @echo ""
    @echo "Building book.md..."
    python3 pandoc/build.py blueprints/book.md -o blueprints/book.pdf
    python3 pandoc/build.py blueprints/book.md -o blueprints/book.html
    python3 pandoc/build.py blueprints/book.md -o blueprints/book.docx
    python3 pandoc/build.py blueprints/book.md -o blueprints/book.tex
    python3 pandoc/check_gloss_markup.py blueprints/book.html
    @echo ""
    @echo "Building slides.md (Beamer)..."
    python3 pandoc/build.py blueprints/slides.md -o blueprints/slides.pdf
    python3 pandoc/build.py blueprints/slides.md -o blueprints/slides.html
    python3 pandoc/build.py blueprints/slides.md -o blueprints/slides.docx
    python3 pandoc/build.py blueprints/slides.md -o blueprints/slides.tex
    python3 pandoc/check_gloss_markup.py blueprints/slides.html

# Check HTML file for undefined glossing abbreviations (defaults to output.html)
check htmlfile="output.html":
    python3 pandoc/check_gloss_markup.py {{htmlfile}}

# Compile all LaTeX figures to SVG (requires dvilualatex and dvisvgm)
figures:
    #!/usr/bin/env bash
    if [ ! -d figures ]; then \
        echo "No figures/ directory found"; \
        exit 0; \
    fi
    cd figures
    TEX_FILES=(*.tex)
    if [ ! -e "${TEX_FILES[0]}" ]; then \
        echo "No .tex files found in figures/"; \
        exit 0; \
    fi
    echo "Compiling LaTeX figures to SVG..."
    for tex_file in *.tex; do \
        base="${tex_file%.tex}"; \
        echo "  Processing $tex_file..."; \
        dvilualatex -interaction=nonstopmode "$tex_file" >/dev/null 2>&1; \
        if [ $? -eq 0 ]; then \
            dvisvgm --no-fonts "$base" >/dev/null 2>&1; \
            if [ $? -eq 0 ]; then \
                echo "    ✓ Created $base.svg"; \
            else \
                echo "    ✗ dvisvgm failed for $base"; \
            fi; \
        else \
            echo "    ✗ LaTeX compilation failed for $tex_file"; \
        fi; \
    done
    echo "Done. Cleaning up auxiliary files..."
    rm -f *.aux *.log *.dvi
    echo "✓ All figures compiled"

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
    rm -f article.pdf article.html article.docx article.tex article_postprocessed.docx

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
