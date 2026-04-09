# md-ling-template

A complete Pandoc template for writing linguistic articles and books with professional typesetting of interlinear glosses, cross-references, and citations.

## Quick Start

### 1. Install Dependencies

```bash
# macOS (Homebrew)
brew install pandoc pandoc-crossref
brew install --cask mactex  # or: brew install basictex

# Linux (Debian/Ubuntu)
sudo apt install pandoc texlive-full pandoc-crossref

# Or download from:
# - Pandoc: https://pandoc.org/installing.html
# - TeX Live: https://www.tug.org/texlive/
# - pandoc-crossref: https://github.com/lierdakil/pandoc-crossref/releases
```

### 2. Create Your Document

```bash
# Copy the template to your project
cp -r md-ling-template my-article/
cd my-article/

# Create your content
cat > content.md << 'EOF'
---
title: My Linguistic Paper
author: Your Name
bibliography: sources.bib
---

# Introduction {#sec:intro}

This paper examines Mapudungun inverse constructions.

::: ex
| Mapudungun (Isolate)
| küpatueyew chi ḻuan
| come-APPL-INV-IND-3-3ACT DEF guanaco
| 'The guanaco came to him.'
:::

See [@sec:intro] for details.
EOF
```

### 3. Build Output

**Using VS Code:**
- Press **Ctrl+Shift+B** (Cmd+Shift+B on Mac) to build PDF
- Or: **Ctrl+P** → type `task` → select format

**Using Command Line:**

```bash
# From the pandoc/ directory:
cd pandoc/

# Build PDF
pandoc ../content.md \
  --defaults=defaults.yaml \
  --citeproc \
  --template=templates/default.latex \
  --pdf-engine=lualatex \
  -o ../output.pdf

# Build HTML
pandoc ../content.md \
  --defaults=defaults.yaml \
  --citeproc \
  --template=templates/default.html \
  --css=style.css \
  -o ../output.html
```

## Features

### Linguistic Examples with pandoc-ling

The template includes Michael Cysouw's [pandoc-ling](https://github.com/cysouw/pandoc-ling) filter for professional typesetting of linguistic examples.

**Simple numbered examples:**
```markdown
::: ex
This is a simple example.
:::
```

**Interlinear glossing:**
```markdown
::: {.ex formatGloss=true}
| Mapudungun (Isolate)
| amuy chi weñi
| go.IND.3 DEF man
| 'The man went.'
:::
```

**Sub-examples:**
```markdown
::: ex
a. First example
b. Second example
c. Third example
:::
```

**Grammaticality judgments:**
```markdown
::: ex
^* This is ungrammatical.
:::
```

See `tests/` for more examples.

### Cross-References with pandoc-crossref

Reference sections, figures, tables, and examples:

```markdown
# Introduction {#sec:intro}

See [@sec:intro] for background.
See [@ex:passive] for an example.
See [@tbl:results] for data.
```

### Citations

Add a `sources.bib` file and cite with:

```markdown
---
bibliography: sources.bib
---

According to @smith2020, we find that...
Previous work [@jones2019; @doe2021] shows...
```

## File Structure

```
md-ling-template/
├── README.md           # This file
├── .vscode/            # VS Code configuration
│   ├── settings.json   # Editor settings
│   ├── tasks.json      # Build tasks (Ctrl+Shift+B)
│   └── extensions.json # Recommended extensions
├── pandoc/             # Pandoc configuration
│   ├── defaults.yaml   # Default pandoc settings
│   ├── crossref-*.yaml # Language-specific labels
│   ├── lang-de.yaml    # German language settings
│   ├── style.css       # HTML styling
│   ├── filters/        # Lua filters
│   │   └── pandoc-ling.lua  # Bundled v1.6 (2026-03-19)
│   └── templates/      # Output templates
│       ├── default.html
│       └── default.latex
├── tests/              # Test suite with examples
└── requirements.txt    # Python dependencies for tests
```

**Note:** The `pandoc-ling.lua` filter is bundled directly in this template for portability. It's version 1.6 from [Michael Cysouw's repository](https://github.com/cysouw/pandoc-ling).

## Customization

### LaTeX Template

Edit `pandoc/templates/default.latex` to customize:
- Document class (line 18: `scrartcl` → `article`)
- Fonts (lines 33-66)
- Linguex spacing (lines 83-87)
- Page geometry, margins, line spacing

### Pandoc Defaults

Edit `pandoc/defaults.yaml` to customize:
- Filters and their order
- Section numbering
- Cross-reference settings

### Language Settings

For German documents, add to your YAML metadata:

```yaml
---
lang: de-DE
reference-section-title: "Literaturverzeichnis"
crossrefYaml: crossref-de-DE.yaml
---
```

Or use the command line:
```bash
pandoc content.md \
  --defaults=defaults.yaml \
  --metadata-file=pandoc/lang-de.yaml \
  -o output.pdf
```

## VS Code Integration

The template includes complete VS Code configuration:

- **Live Preview**: Ctrl+K V (uses actual Pandoc with all filters!)
- **Build Tasks**: Ctrl+Shift+B for default build
- **Extensions**: Automatic suggestions for helpful extensions
- **Settings**: Optimized for Markdown editing

See `.vscode/README.md` for details.

## Testing

The template includes a test suite to verify everything works:

```bash
# Install test dependencies
pip install -r requirements.txt

# Run tests
pytest
```

Tests verify:
- Bibliography generation
- Cross-reference labels (English/German)
- Section numbering
- Small caps formatting

## Troubleshooting

**Preview doesn't show linguistic examples?**
- Install Markdown Preview Enhanced extension
- Verify pandoc is in PATH: `which pandoc`
- Check pandoc-crossref is installed: `which pandoc-crossref`

**PDF build fails?**
- Ensure LuaLaTeX is installed: `which lualatex`
- Check terminal output for specific LaTeX errors
- Try building intermediate .tex: `invoke mpas --fmt=tex`

**Fonts missing in PDF?**
- Install recommended fonts: Noto Serif, Linux Libertine, or Charis SIL
- Template falls back to Latin Modern if unavailable
- Or specify a font in your metadata: `mainfont: "Charis SIL"`

**Cross-references not working?**
- Verify pandoc-crossref is installed and in PATH
- Check that IDs use correct prefixes: `#sec:`, `#tbl:`, `#fig:`
- Ensure IDs are unique

## License

The template configuration files are provided as-is for educational use.

- LaTeX template based on Pandoc's default template
- `pandoc-ling.lua` (v1.6) by Michael Cysouw, bundled with permission (ISC license)
  - Original: https://github.com/cysouw/pandoc-ling
  - Bundled for portability; users can update independently if desired

## Resources

- [Pandoc User's Guide](https://pandoc.org/MANUAL.html)
- [pandoc-ling documentation](https://github.com/cysouw/pandoc-ling)
- [pandoc-crossref documentation](https://github.com/lierdakil/pandoc-crossref)
- [Linguex package documentation](docs/linguex-doc.pdf)
