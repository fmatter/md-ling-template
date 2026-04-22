# md-ling-template

A Pandoc template for writing linguistic articles with professional typesetting of interlinear glosses, tables, and semantic markup.

---

## Quick start

1. Install pandoc-crossref: <https://github.com/lierdakil/pandoc-crossref/releases>
2. Install matching Pandoc version: <https://github.com/jgm/pandoc/releases>
3. Click "Use this template" on GitHub ([link](https://github.com/new?template_name=md-ling-template&template_owner=fmatter))
4. Clone your new repository
5. Create `content.md` (see [`blueprints/article.md`](blueprints/article.md) for examples)
6. Build HTML: `pandoc content.md --defaults=pandoc/defaults.yaml -o output.html`

For easier building and PDF support, continue with full installation below.

---

## Installation

### Minimal installation (HTML output only)

**1. pandoc-crossref** (install first - determines which Pandoc version you need)

Download from releases: <https://github.com/lierdakil/pandoc-crossref/releases>

- macOS: Download `pandoc-crossref-macOS.tar.xz`
- Linux: Download `pandoc-crossref-Linux.tar.xz`
- Windows: Download `pandoc-crossref-Windows.7z`

Extract and move to your PATH, then check which Pandoc version it expects:

```bash
pandoc-crossref --version
# Shows e.g.: pandoc-crossref v0.3.23 git commit ... built with pandoc 3.9, v1.23.1.1 and GHC 9.8.4
```

**2. pandoc** (must match pandoc-crossref version)

Download matching version from: <https://github.com/jgm/pandoc/releases>

- macOS: `.pkg` installer or via Homebrew
- Linux: `.deb` or `.tar.gz`
- Windows: `.msi` installer

Verify versions match:

```bash
pandoc --version
pandoc-crossref --version
```

With these two tools, you can render HTML output. For PDF and easier building, continue below.

### Full installation

#### LaTeX (for PDF output)

Download and install:

- macOS: [MacTeX](https://www.tug.org/mactex/) (large, ~4GB)
- Linux: `sudo apt install texlive-full` or download from [TUG](https://www.tug.org/texlive/)
- Windows: [MiKTeX](https://miktex.org/) or [TeX Live](https://www.tug.org/texlive/)

For minimal install (Linux), you need: `texlive-latex-base, texlive-fonts-recommended, texlive-latex-extra, texlive-luatex`

Verify: `lualatex --version`

#### `just` (build tool, optional but recommended)

Makes building easier with simple commands like `just pdf` and `just html`.

Install:

- macOS: `brew install just`
- Linux: `curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin`
- Windows: `cargo install just` or download from [releases](https://github.com/casey/just/releases)
- All platforms: see <https://github.com/casey/just#installation>

#### Fonts (recommended)

Install at least one linguistics-friendly font with good Unicode coverage:

- [Linux Libertine](https://libertine-fonts.org/) - Classic, excellent for linguistics
- [Noto Serif](https://fonts.google.com/noto/specimen/Noto+Serif) - Google's pan-Unicode font
- [Charis SIL](https://software.sil.org/charis/)

#### Editor (optional)

[VS Code](https://code.visualstudio.com/) or [VSCodium](https://vscodium.com/) (no MS telemetry) recommended for:

- syntax highlighting for Markdown
- integrated terminal for building
- build tasks (Ctrl/Cmd+Shift+B)
- markdown preview
- citation & crossref autocompletion
- snippets for common structures (see [`.vscode/README.md`](.vscode/README.md))

---

## How to use

### Project structure

**Single-file projects:**

Create `content.md` with your article content. The simplest structure:

```
your-article/
├── content.md          # Your article
├── sources.bib         # Bibliography
├── pandoc/             # Template files (from md-ling-template)
└── justfile            # Build commands (optional)
```

**Multi-file projects:**

For longer documents (theses, books), split content across multiple files:

```
your-thesis/
├── project.yaml        # Lists input files
├── metadata.yaml       # Shared frontmatter
├── 01-intro.md
├── 02-background.md
├── 03-analysis.md
├── sources.bib
└── pandoc/             # Template files
```

Set up multi-file structure:

```bash
cp project.yaml.template project.yaml
cp metadata.yaml.template metadata.yaml
```

Edit `project.yaml` to list your chapters:

```yaml
input-files:
  - 01-intro.md
  - 02-background.md
  - 03-analysis.md

metadata-files:
  - metadata.yaml
```

**Option 1:** Put shared metadata in `metadata.yaml` (referenced in `project.yaml`):

```yaml
---
title: "My Thesis"
author: "Your Name"
bibliography: [sources.bib]
documentclass: scrbook
---
```

**Option 2:** Put metadata inline in `project.yaml`:

```yaml
input-files:
  - 01-intro.md
  - 02-background.md
  - 03-analysis.md

metadata:
  title: "My Thesis"
  author: "Your Name"
  bibliography: [sources.bib]
  documentclass: scrbook
```

Both options work identically.

### Building

**With just (recommended):**

```bash
just pdf      # Auto-detects content.md or project.yaml
just html
just docx
just tex

# Specific file:
just pdf my-article.md
```

**With Python build script:**

```bash
# Single file
python3 pandoc/build.py content.md -o output.pdf

# Multi-file project
python3 pandoc/build.py --project -o output.pdf
```

**With pandoc directly:**

```bash
# Single file
pandoc content.md \
  --defaults=pandoc/defaults.yaml \
  --template=pandoc/templates/default.latex \
  -o output.pdf

# Multi-file
pandoc --defaults=pandoc/defaults.yaml \
  --defaults=project.yaml \
  --template=pandoc/templates/default.latex \
  -o output.pdf
```

### Example documents

The `blueprints/` directory contains example documents:

- [`blueprints/article.md`](blueprints/article.md) - journal article demonstrating all features
- [`blueprints/book.md`](blueprints/book.md) - book/thesis structure
- [`blueprints/slides.md`](blueprints/slides.md) - Beamer presentation (Metropolis theme)

Build all example formats:

```bash
just blueprints
```

Or build individual examples:

```bash
just pdf blueprints/article.md
```

---

## Features

### Semantic markup for linguistic data

Implementation: [`pandoc/filters/linguistic-markup.lua`](pandoc/filters/linguistic-markup.lua)

| semantics       | markup               | output             |
| --------------- | -------------------- | ------------------ |
| object language | `[tuttugu]{.ob}`     | _tuttugu_            |
| reconstructed   | `[qalejaw]{.rc}`     | \*_qalejaw_        |
| gloss           | `[nom]{.gl}`         | [nom]{.smallcaps}  |
| phonetic        | `[ˈfɾɛjhɛjtː]{.pnt}` | [ˈfɾɛjhɛjtː]{.pnt} |
| phonemic        | `[θ]{.pnm}`          | [θ]{.pnm}          |

### Interlinear glossing with `pandoc-ling`

Bundled enhanced fork of [pandoc-ling](https://github.com/cysouw/pandoc-ling) (implementation: [`pandoc/filters/pandoc-ling.lua`](pandoc/filters/pandoc-ling.lua)):

```markdown
::: {.ex formatGloss=true}
Example preamble:

a.
| {#ex:dutch} Dutch (Germanic)
| Deze zin is in het nederlands.
| DEM sentence AUX in DET dutch.
| This sentence is dutch.

b.
| {#ex:mapudungun} Mapudungun (Isolate)
| küpatueyew chi ḻuan
| kɨpa-tu-e-i-Ø-mew t͡ʃi l̪uan
| come-APPL-INV-IND-3-3ACT DEF guanaco
| 'The guanaco came to him.'
:::

The contrast between @ex:dutch and @ex:mapudungun shows...
```


### Glossing Abbreviations Management

- implementation: [`pandoc/filters/glossing-list.lua`](pandoc/filters/glossing-list.lua)
- define abbreviations in your metadata:

```yaml
glossing-abbreviations:
  NOM: nominative
  ACC: accusative
  3SG: third person singular

glossing-list:
  position: after # 'before' (after intro) or 'after' (before references)
  title: "List of Glossing Abbreviations"
```

- inline list format: `[...]{.glossing-abbreviations-inline}`

- check for missing abbreviations:

```bash
just check              # Scans HTML output for undefined abbreviations
```

### Table formatting

**Subtables** (side-by-side tables with unified caption):

```markdown
::: {#tbl:main}
**Person marking in Set I and Set II**

Table: Set I {#tbl:set1}

| Person     | Prefix    |
| ---------- | --------- |
| [1SG]{.gl} | [n-]{.ob} |

Table: Set II {#tbl:set2}

| Person     | Prefix     |
| ---------- | ---------- |
| [1SG]{.gl} | [ha-]{.ob} |

:::
```


implementation:

- [`pandoc/filters/subtables.lua`](pandoc/filters/subtables.lua)
- [`pandoc/filters/simple-tables.lua`](pandoc/filters/simple-tables.lua) (for auto-width tables)

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
- **vowel** - Vowel charts with `\vowel` command

See [`figures/README.md`](figures/README.md) and [`figures/example-tree.tex`](figures/example-tree.tex) for more details.

---

## Customization

### Fonts

Set fonts in your document metadata:

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
  - pandoc-crossref # Keep crossref near end but before citeproc
```

**Note:** Filter order matters! Most custom filters should run before `pandoc-crossref`. In turn, `pandoc-crossref` should run before `citeproc` (if using citations).

### Document class

Set document class in your metadata:

```yaml
---
documentclass: scrartcl  # KOMA-Script article (recommended)
# Or: article, scrreprt, scrbook, book, report
---
```

KOMA-Script classes (`scrartcl`, `scrreprt`, `scrbook`) provide better typography than standard classes.

### Standard Pandoc features

The template works with all standard Pandoc features:

- page layout: `geometry`, `fontsize`, `papersize`
- citations: `bibliography`, `csl`
- custom LaTeX: `header-includes`

---

## Technical details

### LaTeX template

The [`pandoc/templates/default.latex`](pandoc/templates/default.latex) template provides:

- Linguistic markup commands (`\gl`, `\ob`, `\rc`, `\pnt`, `\pnm`) required by filters
- Underline support (lua-ul) for `.underline` class in tables
- Pandoc 3.9+ xmpquote fix
- Subtable environment fallback
- Keywords display below abstract
- KOMA-Script conditionals

Default document class is `scrartcl` (set via build.py when not specified).

### Build system

Three equivalent ways to build:

**1. just (recommended):**

```bash
just pdf      # Auto-detects content.md or project.yaml
just html
just docx
```

**2. Python build script:**

```bash
python3 pandoc/build.py content.md -o output.pdf
python3 pandoc/build.py --project  # Multi-file
```

The build script:
- Auto-detects Beamer presentations (`documentclass: beamer`)
- Sets default document class to `scrartcl` if not specified
- Applies appropriate output format flags

**3. pandoc directly:**

```bash
pandoc content.md \
  --defaults=pandoc/defaults.yaml \
  --template=pandoc/templates/default.latex \
  --metadata=documentclass:scrartcl \
  -o output.pdf
```

Implementation: [`justfile`](justfile), [`pandoc/build.py`](pandoc/build.py), [`.vscode/tasks.json`](.vscode/tasks.json)


### File structure

```
md-ling-template/
├── justfile               # Build commands
├── blueprints/            # Example documents
├── figures/               # LaTeX diagrams → SVG
├── unibe/                 # University of Bern theme
├── pandoc/
│   ├── defaults.yaml      # Pandoc configuration
│   ├── build.py           # Build script with auto-detection
│   ├── check_gloss_markup.py
│   ├── style.css          # HTML styling
│   ├── filters/           # Lua filters
│   │   ├── linguistic-markup.lua
│   │   ├── glossing-list.lua
│   │   ├── subtables.lua
│   │   ├── simple-tables.lua
│   │   └── pandoc-ling.lua
│   └── templates/
│       └── default.latex
└── .vscode/               # VS Code tasks & snippets
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

## Updating the template

If you want to pull in te updates after creating your article:

One-time setup:

```bash
cd your-article/
git remote add template https://github.com/fmatter/md-ling-template.git
```

Update to new version (tags are branches that are always available):

```bash
git fetch template
git merge template/v1.0.0 --allow-unrelated-histories

# Or cherry-pick specific files:
git checkout template/v1.0.0 -- pandoc/filters/ pandoc/templates/ .github/
git commit -m "Update template to v1.0.0"
```

Update these: `pandoc/filters/`, `pandoc/templates/`, `.github/`, `justfile`

Keep yours: `content.md`, `sources.bib`, `README.md`

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

Template based on Pandoc's default templates. Includes:

- Enhanced fork of `pandoc-ling.lua` (originally by Michael Cysouw, ISC license)
