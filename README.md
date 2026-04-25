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
# Shows e.g.: pandoc-crossref v0.3.23 ... built with pandoc 3.9
```

**2. pandoc** (must match `pandoc-crossref` version)

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
- build tasks (Ctrl+Shift+B on Windows/Linux, Cmd+Shift+B on Mac)
- markdown preview (Ctrl+K V on Windows/Linux, Cmd+K V on Mac)
- citation & crossref autocompletion

**Optional keyboard shortcuts for semantic markup:**

You can add shortcuts to wrap selected text in linguistic markup. Open Command Palette (Ctrl+Shift+P / Cmd+Shift+P), type "Preferences: Open Keyboard Shortcuts (JSON)", and add:

```json
[
  {
    "key": "ctrl+alt+shift+g",
    "command": "editor.action.insertSnippet",
    "when": "editorTextFocus && editorLangId == markdown",
    "args": {
      "snippet": "[${TM_SELECTED_TEXT:${1:text}}]{.gl}"
    }
  },
  {
    "key": "ctrl+alt+shift+o",
    "command": "editor.action.insertSnippet",
    "when": "editorTextFocus && editorLangId == markdown",
    "args": {
      "snippet": "[${TM_SELECTED_TEXT:${1:text}}]{.ob}"
    }
  },
  {
    "key": "ctrl+alt+shift+r",
    "command": "editor.action.insertSnippet",
    "when": "editorTextFocus && editorLangId == markdown",
    "args": {
      "snippet": "[${TM_SELECTED_TEXT:${1:text}}]{.rc}"
    }
  }
]
```

Then: Select text → Ctrl+Alt+Shift+G → `[text]{.gl}` (on Mac, use Cmd+Option+Shift)

**Note:** Throughout this documentation, keyboard shortcuts are shown as `Ctrl+Key`. On macOS, use `Cmd` (⌘) instead of `Ctrl`.

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

**Template files and what they do:**

- `pandoc/filters/` - Lua filters that process your markdown (linguistic markup, tables, examples). Work automatically.
- `pandoc/templates/default.latex` - LaTeX template for PDF output. Pre-configured.
- `pandoc/defaults.yaml` - Pandoc configuration (filters, settings). Rarely needs editing.
- `pandoc/style.css` - HTML styling. Pre-configured.
- `pandoc/crossref-*.yaml` - Language-specific labels (Figure, Table, etc.). Use as-is or copy to customize.
- `.vscode/` - VS Code tasks and settings. Work automatically.
- `justfile` - Build commands. Works out of the box.

You typically only edit your own `.md` files and `sources.bib`. For advanced customization, use `project.yaml` (see below).

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

**Author with affiliations:**

The `author` field supports structured metadata for including affiliations (shown as footnotes in PDF):

```yaml
author:
  - name: Alice Smith
    affiliation: Department of Linguistics, University of Somewhere
  - name: Bob Jones
    affiliation: Institute of Language Studies, University of Nowhere
```

Simple string format is also supported for backward compatibility:

```yaml
author:
  - Alice Smith
  - Bob Jones
```

### VS Code preview

**Important:** VS Code's Markdown Preview Enhanced extension only works for **`.md` files in the top-level directory** of your workspace.

**Works:** `content.md`, `article.md`, `01-intro.md` (top level)

**Doesn't work:** `blueprints/article.md`, `chapters/intro.md` (subdirectories)

**Why?** The preview uses `pandoc/defaults.yaml` which references filters and resources using relative paths from the workspace root. Files in subdirectories break these paths.

**Workaround:** If you need to preview blueprint files:
1. Copy the blueprint to the top level: `cp blueprints/article.md test.md`
2. Open `test.md` and use preview
3. Delete when done

For actual writing, keep your content files in the top level (recommended structure above).

### Building

**With `just` (recommended):**

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

# With custom template
python3 pandoc/build.py content.md --template my-template.latex -o output.pdf
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

### Post-editing LaTeX files

To manually edit the generated LaTeX before compilation:

```bash
# 1. Generate .tex file
just tex content.md

# 2. Edit content.tex as needed
vim content.tex

# 3. Compile with lualatex (requires -shell-escape for SVG support)
lualatex -shell-escape content.tex
lualatex -shell-escape content.tex # Run twice for references
```

**Important:** The `-shell-escape` flag is required if your document contains SVG figures. This allows the LaTeX `svg` package to call Inkscape for SVG-to-PDF conversion during compilation.

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
  position: after # 'after' (before references) or null (no automatic list)
  title: "List of Glossing Abbreviations"
```

**Features:**
- Leipzig Glossing Rules abbreviations (APPL, IND, DEF, etc.) automatically get tooltips in HTML
- Only user-defined abbreviations appear in the generated list
- Insert list manually anywhere in your document:
  - Full table: `::: glossing-abbreviations-list`
  - Inline list: `[...]{.glossing-abbreviations-inline}`

Check for missing abbreviations:

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

See [`figures/README.md`](figures/README.md) and [`figures/vowels.tex`](figures/vowels.tex) for more details.

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

**Built-in languages:** English (`en-US`) and German (`de-DE`)

To use German labels (Abbildung, Tabelle, Beispiel):

1. Edit `pandoc/defaults.yaml`:
   ```yaml
   metadata-files:
     - pandoc/crossref-de-DE.yaml # Change from en-US
   ```

2. Set `lang: de-DE` in your document metadata:
   ```yaml
   ---
   lang: de-DE
   ---
   ```

**For other languages:**

1. Create a crossref language file (e.g., `pandoc/crossref-fr-FR.yaml`):
   ```yaml
   # French labels for pandoc-crossref
   figureTitle: "Figure"
   tableTitle: "Tableau"
   listingTitle: "Liste"
   figPrefix: "fig."
   eqnPrefix: "éq."
   tblPrefix: "tabl."
   lstPrefix: "list."
   secPrefix: "sec."
   # Add more as needed - see pandoc-crossref documentation
   ```

2. Reference it in `pandoc/defaults.yaml` or your document:
   ```yaml
   metadata-files:
     - pandoc/crossref-fr-FR.yaml
   ```

3. Set the language in your document:
   ```yaml
   ---
   lang: fr-FR
   ---
   ```

**Tip:** Copy an existing crossref file as a starting point:
```bash
cp pandoc/crossref-en-US.yaml pandoc/crossref-fr-FR.yaml
# Then edit the labels
```

See [pandoc-crossref documentation](https://lierdakil.github.io/pandoc-crossref/#settings-file) for all available labels.

### Custom Configuration

**Using project.yaml for customization:**

For custom settings or multi-file projects, create `project.yaml`:

```yaml
# project.yaml
input-files:
  - 01-intro.md
  - 02-background.md

metadata:
  title: "My Thesis"
  fontsize: 12pt
  geometry: margin=1in
```

Build with:
```bash
just pdf              # Automatically picks up project.yaml
# Or:
python3 pandoc/build.py --project
```

`project.yaml` is loaded **after** `pandoc/defaults.yaml`, so your settings override the template defaults.

**For single-file projects:** You can also use `project.yaml` for single files if you need custom settings:

```yaml
# project.yaml (single-file)
input-files:
  - content.md

metadata:
  fontsize: 12pt
```

**Adding custom filters:**

Add filters to `project.yaml` (recommended) or edit `pandoc/defaults.yaml`:

```yaml
# In project.yaml
filters:
  - filters/my-custom-filter.lua  # Your filter
```

Or if you need to modify the filter chain, copy the entire filters section from `pandoc/defaults.yaml` to `project.yaml` and modify it there.

**Important:** Filter order matters!
- Filters that modify content should run **before** `pandoc-crossref`
- `pandoc-crossref` must run **before** `citeproc`
- `citeproc` must run **before** `subtables.lua` (processes citations in captions)
- Custom filters usually go at the beginning (before crossref)

**Current filter order in `pandoc/defaults.yaml`:**
```yaml
filters:
  - pandoc/filters/linguistic-markup.lua   # Semantic markup
  - pandoc/filters/glossing-list.lua       # Glossing abbreviations
  - pandoc/filters/pandoc-ling.lua         # Linguistic examples
  - pandoc-crossref                        # BEFORE citeproc
  - citeproc                               # Process citations
  - pandoc/filters/subtables.lua           # AFTER citeproc (needs processed citations)
  - pandoc/filters/simple-tables.lua       # Table formatting
  - pandoc/filters/docx-styles.lua         # DOCX post-processing
```

**Using custom templates:**

```bash
# Create your custom template based on the default
cp pandoc/templates/default.latex my-template.latex
# Edit my-template.latex as needed

# Build with your template
python3 pandoc/build.py content.md --template my-template.latex -o output.pdf
```

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

## How do I...

### Use traditional paragraph indentation instead of spacing?

By default, pandoc uses the `parskip` package which adds space between paragraphs and removes first-line indentation.
Setting `indent: true` in your metadata disables this, giving you traditional LaTeX formatting with indented first lines and no paragraph spacing.

```yaml
indent: true
```

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
python3 pandoc/build.py content.md --template my-template.latex  # Custom template
```

The build script:
- Auto-detects Beamer presentations (`documentclass: beamer`)
- Sets default document class to `scrartcl` if not specified
- Applies appropriate output format flags
- Accepts `--template` option for custom LaTeX templates

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
