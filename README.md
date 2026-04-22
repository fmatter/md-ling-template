# md-ling-template

A Pandoc template for writing linguistic articles with professional typesetting of interlinear glosses, tables, and semantic markup.

---

## Quick Start

1. install dependencies

```bash
# macOS (Homebrew)
brew install pandoc pandoc-crossref just
# Linux (Debian/Ubuntu)
sudo apt install pandoc pandoc-crossref just
# Windows: Use WSL or install via Chocolatey:
choco install pandoc pandoc-crossref just

# Or download from:
# - Pandoc: https://pandoc.org/installing.html
# - pandoc-crossref: https://github.com/lierdakil/pandoc-crossref/releases
# - just: https://github.com/casey/just
```

2. click on the "Use this template" button on github ([Link](https://github.com/new?template_name=md-ling-template&template_owner=fmatter)) and clone the repo to your computer
   - alternatively, fork or clone the repo directly
3. add a file `content.md`; see [`blueprints/article.md`](blueprints/article.md) for an example
4. run `just html` to generate `output.html`

## Full installation

### Local PDF generation

For PDF output, you also need a LaTeX distribution with LuaLaTeX support:

```bash
# macOS
brew install --cask mactex
# Linux
sudo apt install texlive-full
# Windows
choco install miktex
```

### Fonts

Some suggestions:

- [Noto Serif](https://fonts.google.com/noto/specimen/Noto+Serif)
- [Linux Libertine](https://libertine-fonts.org/)
- [Charis SIL](https://software.sil.org/charis/)

### VS Code

[VS Code](https://code.visualstudio.com/) or [VSCodium](https://vscodium.com/) is recommended for editing markdown files and running build tasks.

## Project structure and building

`just pdf` or `just html` will auto-detect whether you have a `content.md` (single-file) or `project.yaml` (see [multi-file projects](#sec:multi-file)) and build accordingly.
You can also specify the file directly: `just pdf my-article.md`.
You can also run the build script directly with Python: `python3 pandoc/build.py content.md -o output.pdf`.

### Multi-file projects {#sec:multi-file}

For longer documents (theses, books, complex papers), it is recommended to organize content across multiple markdown files using `project.yaml` and `metadata.yaml` for shared frontmatter:

```bash
# Copy template files
cp project.yaml.template project.yaml
cp metadata.yaml.template metadata.yaml
```

`project.yaml` lists your chapter files:

```yaml
input-files:
  - 01-introduction.md
  - 02-background.md
  - 03-analysis.md
  - 04-conclusion.md

metadata-files:
  - metadata.yaml
```

`metadata.yaml` contains your shared frontmatter:

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
# or use build script directly:
python3 pandoc/build.py --project -o output.pdf
```

### The blueprints

- [`blueprints/article.md`](blueprints/article.md) - journal article with all features demonstrated
- [`blueprints/book.md`](blueprints/book.md) - book/thesis structure
- [`blueprints/slides.md`](blueprints/slides.md) - slide deck template (not fully featured yet)

Build the article example to see all features:

```bash
just blueprints/article.md

# Or with pandoc directly:
pandoc blueprints/article.md \
  --defaults=pandoc/defaults.yaml \
  --template=pandoc/templates/default.latex \
  -o article.pdf

# Or build all blueprints & all formats:
just blueprints
```

## Features

### Semantic markup for linguistic data

Implementation: [`pandoc/filters/linguistic-markup.lua`](pandoc/filters/linguistic-markup.lua)

| semantics       | markup               | output             |
| --------------- | -------------------- | ------------------ |
| object language | `[tuttugu]{.ob}`     | tuttugu            |
| reconstructed   | `[qalejaw]{.rc}`     | \*_qalejaw_        |
| gloss           | `[nom]{.gl}`         | [nom]{.smallcaps}  |
| phonetic        | `[ˈfɾɛjhɛjtː]{.pnt}` | [ˈfɾɛjhɛjtː]{.pnt} |
| phonemic        | `[θ]{.pnm}`          | [θ]{.pnm}          |

### Interlinear Glossing with pandoc-ling

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


- implementation:
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
documentclass: scrartcl # or: article, report, book, etc.
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
