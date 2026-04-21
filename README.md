# md-ling-template

A Pandoc template for writing linguistic articles with professional typesetting of interlinear glosses, tables, and semantic markup.

**What this template provides:**

- custom Lua filters for linguistics-specific formatting
- LaTeX template optimized for linguistic articles
- enhanced [pandoc-ling](https://github.com/cysouw/pandoc-ling) fork with additional features
- build system (justfile, Python script, VS Code tasks)
- starter blueprints for articles and books

---

## Quick Start

### Install Dependencies

```bash
# macOS (Homebrew)
brew install pandoc pandoc-crossref just
brew install --cask mactex

# Linux (Debian/Ubuntu)
sudo apt install pandoc pandoc-crossref just texlive-full

# Or download from:
# - Pandoc: https://pandoc.org/installing.html
# - pandoc-crossref: https://github.com/lierdakil/pandoc-crossref/releases
# - just: https://github.com/casey/just
```

**Recommended: Install a linguistics-friendly font** ([Noto Serif](https://fonts.google.com/noto/specimen/Noto+Serif), [Linux Libertine](https://libertine-fonts.org/), or [Charis SIL](https://software.sil.org/charis/))

### Create Your Article

```bash
# Use this template on GitHub (click "Use this template" button)
# Or download/clone to get started

# Copy a blueprint as your starting point
cp blueprints/article.md content.md

# Build PDF
just pdf
```

### Explore the Blueprints

- [`blueprints/article.md`](blueprints/article.md) - Journal article with all features demonstrated
- [`blueprints/book.md`](blueprints/book.md) - Book/thesis structure

Build the article example to see all features:

```bash
just demo  # Builds blueprints/article.md to PDF, HTML, DOCX

# Or with pandoc directly:
pandoc blueprints/article.md \
  --defaults=pandoc/defaults.yaml \
  --template=pandoc/templates/default.latex \
  -o article.pdf
```

---

## Features

### Semantic Markup for Linguistic Data

Custom span classes that work across all output formats (PDF, HTML, DOCX):

**Gloss abbreviations (smallcaps):**

```markdown
The word has [nom]{.gl} case marking.
Use [s~a~]{.gl} for subscripted glosses.
```

**Object language (italics):**

```markdown
[tuttugu]{.ob} 'twenty'
```

**Reconstructed forms (asterisk + italics):**

```markdown
[qalejaw]{.rc} 'day'
```

**Phonetic notation (brackets):**

```markdown
The pronunciation is [ˈfɹiːdəm]{.pnt}.
```

**Phonemic notation (slashes):**

```markdown
The phoneme [θ]{.pnm} is rare cross-linguistically.
```

**Implementation:** [`pandoc/filters/linguistic-markup.lua`](pandoc/filters/linguistic-markup.lua)

### Glossing Abbreviations Management

Automatically manages glossing abbreviations used in your article:

```yaml
---
glossing-abbreviations:
  NOM: nominative
  ACC: accusative
  3SG: third person singular

glossing-list:
  position: after # 'before' (after intro) or 'after' (before references)
  title: "List of Glossing Abbreviations"
---
```

**Features:**

- auto-generates formatted table of abbreviations
- links abbreviations in running text to definitions (hover tooltips in HTML)
- warns about undefined abbreviations during build
- inline list format: `[...]{.glossing-abbreviations-inline}` for footnotes

**Implementation:** [`pandoc/filters/glossing-list.lua`](pandoc/filters/glossing-list.lua)

**Check for missing abbreviations:**

```bash
just check              # Scans HTML output for undefined abbreviations
```

### Professional Table Formatting

**Auto-width columns** (sized to content, not stretched full-width):

```markdown
|            |                               |
| ---------- | ----------------------------- |
| [ps]{.gl}  | privileged syntactic argument |
| [act]{.gl} | active voice                  |

: Information status categories {#tbl:categories}
```

**Subtables** (side-by-side tables with unified caption):

```markdown
::: {#tbl:main}
**Person marking in Set I and Set II**

Table: Set I {#tbl:set1}

| Person | Prefix |
| ------ | ------ |
| 1SG    | n-     |

Table: Set II {#tbl:set2}

| Person | Prefix |
| ------ | ------ |
| 1SG    | ha-    |

:::
```

**Formatting:**

- Captions above tables (linguistics convention)
- Auto-width columns (no forced stretching)
- Professional rules (booktabs style in LaTeX)

**Implementation:** [`pandoc/filters/simple-tables.lua`](pandoc/filters/simple-tables.lua), [`pandoc/filters/subtables.lua`](pandoc/filters/subtables.lua)

### LaTeX Figures and Diagrams

Create complex linguistic diagrams (syntax trees, autosegmental representations, etc.) as standalone LaTeX files and compile them to SVG for inclusion in your documents.

**1. Create a LaTeX figure** in `figures/`:

```latex
% figures/my-tree.tex
\documentclass[dvisvgm]{standalone}
\usepackage{forest}

\begin{document}
\begin{forest}
  [TP
    [DP [John]]
    [VP [slept]]
  ]
\end{forest}
\end{document}
```

**2. Compile to SVG:**

```bash
just figures  # Compiles all .tex files in figures/ to SVG

# Or manually:
cd figures && dvilualatex my-tree.tex && dvisvgm --no-fonts my-tree
```

**3. Include in your document:**

```markdown
The structure is shown in @fig:tree.

![Sentence structure](figures/my-tree.svg){#fig:tree width=60%}
```

**Supported packages:**

- **forest** - Modern syntax trees (recommended)
- **tikz-qtree** - Alternative tree package
- **tikz** - General diagrams, autosegmental representations
- **pst-asr** - Autosegmental representations (use with `latex` instead of `lualatex`)
- **gb4e** / **linguex** - Example numbering with trees

See [`figures/README.md`](figures/README.md) and [`figures/example-tree.tex`](figures/example-tree.tex) for more details.

### Interlinear Glossing with pandoc-ling

Bundled enhanced fork of [pandoc-ling](https://github.com/cysouw/pandoc-ling) with additional functionality for professional linguistic examples:

```markdown
::: {.ex formatGloss=true}
| Mapudungun (Isolate)
| amuy chi weñi
| go.IND.3 DEF man
| 'The man went.'
:::
```

### Multi-File Projects

For longer documents (theses, books, complex papers), organize content across multiple markdown files using `project.yaml`.

**Setup:**

```bash
# Copy template files
cp project.yaml.template project.yaml
cp metadata.yaml.template metadata.yaml
```

**project.yaml** - lists your chapter files:

```yaml
input-files:
  - 01-introduction.md
  - 02-background.md
  - 03-analysis.md
  - 04-conclusion.md

metadata-files:
  - metadata.yaml
```

**metadata.yaml** - shared frontmatter:

```yaml
---
title: "My Thesis"
author: "Your Name"
bibliography: [sources.bib]
---
```

**Build:**

```bash
just pdf              # Auto-detects project.yaml
python3 pandoc/build.py --project -o output.pdf
```

Cross-references work across all files. The template configuration (filters, defaults) stays the same.

### LaTeX Template

The [`pandoc/templates/default.latex`](pandoc/templates/default.latex) template provides:

**Essential features:**
- Linguistic markup commands (`\gl`, `\ob`, `\rc`, `\pnt`, `\pnm`) - required by filters
- Underline support (lua-ul) for `.underline` in tables
- Pandoc 3.9+ xmpquote fix
- Subtable environment fallback
- Keywords display below abstract

**Default document class:**
- Uses standard LaTeX `article` class by default
- Recommended: KOMA-Script classes (`scrartcl`, `scrreprt`, `scrbook`) for better typography
- Customizable via metadata:

```yaml
---
documentclass: scrartcl  # or: article, report, book, etc.
---
```

The template is compatible with both standard and KOMA-Script classes.

### Build System

Multiple ways to build your documents:

**VS Code:**

- Press **Ctrl+Shift+B** (Cmd+Shift+B on Mac) → select build task

**Command line with just:**

```bash
just pdf      # Auto-detects content.md or project.yaml
just html
just tex
just figures  # Compile .tex files in figures/ to SVG
just demo     # Build blueprints/article.md to all formats
```

**Direct Python:**

```bash
python3 pandoc/build.py content.md -o output.pdf
python3 pandoc/build.py --project  # Multi-file from project.yaml
```

**Implementation:** [`justfile`](justfile), [`pandoc/build.py`](pandoc/build.py), [`.vscode/tasks.json`](.vscode/tasks.json)

---

## Customization

### Fonts

Explicitly set fonts in your document metadata:

```yaml
---
mainfont: "Noto Serif"
# Or: "Linux Libertine", "Charis SIL", etc.
---
```

### Language Settings

For German labels (Abbildung, Tabelle, Beispiel):

Edit `pandoc/defaults.yaml`:

```yaml
metadata-files:
  - pandoc/crossref-de-DE.yaml # Change from en-US
```

Also set `lang: de-DE` in your document metadata.

### Adding Custom Filters

Edit `pandoc/defaults.yaml` to add your own Lua filters:

```yaml
filters:
  - pandoc/filters/linguistic-markup.lua
  - pandoc/filters/my-custom-filter.lua # Your filter
  - pandoc-crossref # Keep crossref near end
```

**Note:** Filter order matters! Most custom filters should run before `pandoc-crossref`.

### Standard Pandoc Features

The template works with all standard Pandoc features:

- **page layout:** `geometry`, `fontsize`, `papersize`
- **citations:** `bibliography`, `csl`
- **custom LaTeX:** `header-includes`
- **multi-file projects:** `project.yaml`

---

## File Structure

```
md-ling-template/
├── README.md              # This file
├── CHANGELOG.md           # Version history
├── justfile               # Build commands
├── blueprints/            # Starter templates
│   ├── article.md
│   └── book.md
├── .vscode/               # VS Code configuration
│   ├── tasks.json         # Build tasks
│   └── markdown.code-snippets  # ex, gl, ob snippets
├── pandoc/
│   ├── defaults.yaml      # Pandoc settings
│   ├── build.py           # Build script
│   ├── check_gloss_markup.py  # Abbreviation checker
│   ├── style.css          # HTML styling
│   ├── filters/
│   │   ├── linguistic-markup.lua   # .gl, .ob, .rc spans
│   │   ├── glossing-list.lua       # Abbreviations management
│   │   ├── subtables.lua           # Side-by-side tables
│   │   ├── simple-tables.lua       # Auto-width tables
│   │   └── pandoc-ling.lua         # Interlinear glossing
│   └── templates/
│       ├── default.latex
│       └── default.html
└── tests/                 # Example documents
```

---

## Troubleshooting

**Fonts not rendering properly in PDF?**

Explicitly set a font in your metadata:

```yaml
---
mainfont: "Noto Serif"
---
```

Install at least one of: [Noto Serif](https://fonts.google.com/noto/specimen/Noto+Serif), [Linux Libertine](https://libertine-fonts.org/), [Charis SIL](https://software.sil.org/charis/)

**PDF build fails?**

- ensure LuaLaTeX is installed: `lualatex --version`
- check terminal output for specific LaTeX errors

**Preview doesn't show linguistic examples?**

Install the [Markdown Preview Enhanced](https://marketplace.visualstudio.com/items?itemName=shd101wyy.markdown-preview-enhanced) extension for VS Code.

**Cross-references not working?**

- install pandoc-crossref: `brew install pandoc-crossref` (macOS) or from [releases](https://github.com/lierdakil/pandoc-crossref/releases)
- check IDs use correct prefixes: `#sec:`, `#tbl:`, `#fig:`, `#ex:`

**Check for undefined glossing abbreviations:**

```bash
just check              # Scans output.html
just check my-file.html # Specific file
```

---

## Updating the Template

If you want to pull in template updates after creating your article:

**One-time setup:**

```bash
cd your-article/
git remote add template https://github.com/fmatter/md-ling-template.git
git fetch template
```

**Update to new version:**

```bash
git fetch template
git merge template/v1.0.0 --allow-unrelated-histories

# Or cherry-pick specific files:
git checkout template/v1.0.0 -- pandoc/filters/ pandoc/templates/ .github/
git commit -m "Update template to v1.0.0"
```

**Update these:** `pandoc/filters/`, `pandoc/templates/`, `.github/`, `justfile`

**Keep yours:** `content.md`, `sources.bib`, `README.md`

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

Template based on Pandoc's default templates. Includes:

- Enhanced fork of `pandoc-ling.lua` (originally by Michael Cysouw, ISC license)
