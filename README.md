# md-ling-template

A complete Pandoc template for writing linguistic articles and books with professional typesetting of interlinear glosses, cross-references, and citations.

**See [`demo.md`](demo.md) for a comprehensive showcase of all features.**

**Template blueprints** in the `blueprints/` folder:
- [`blueprints/article.md`](blueprints/article.md) - Starter template for journal articles
- [`blueprints/book.md`](blueprints/book.md) - Starter template for books/theses
- [`blueprints/slides.md`](blueprints/slides.md) - Starter template for presentations

**Copy a blueprint to start your work** (don't edit them directly - they're under version control).

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

**Recommended: Install a linguistics-friendly font**

The template supports these fonts (install at least one, then specify it in your document):
1. **Noto Serif** - [Download from Google Fonts](https://fonts.google.com/noto/specimen/Noto+Serif)
2. **Linux Libertine** - [Download from libertine-fonts.org](https://libertine-fonts.org/)
3. **Charis SIL** - [Download from SIL](https://software.sil.org/charis/)

Then add to your document metadata (replace "Noto Serif" with your installed font):
```yaml
---
mainfont: "Noto Serif"
---
```

### 2. Start Your Document

**Copy a blueprint:**
```bash
# Copy the template to your project
cp -r md-ling-template my-article/
cd my-article/

# Copy a blueprint as your starting point
cp blueprints/article.md content.md
# Or: cp blueprints/book.md content.md
# Or: cp blueprints/slides.md my-slides.md

# Create a bibliography file
cat > sources.bib << 'EOF'
@article{example2024,
  author  = {Smith, John},
  title   = {An Example Article},
  journal = {Journal of Examples},
  year    = {2024}
}
EOF
```

The blueprints contain starter content showing how to use all features. Edit and customize them for your work.

### 3. Build Your Document

**Single-file mode** (simplest - edit one .md file):

In VS Code:
1. Open your markdown file
2. Press **Ctrl+Shift+B** (Cmd+Shift+B on Mac)
3. PDF appears next to your markdown file

Command line:
```bash
# If you created content.md (from Quick Start above):
just pdf      # Auto-detects content.md and builds output.pdf

# Or build any markdown file directly:
python3 pandoc/build.py my-article.md
```

**Multi-file mode** (for books, theses, multi-chapter works):

1. Copy `project.yaml.template` to `project.yaml`
2. Copy `metadata.yaml.template` to `metadata.yaml` (for shared metadata)
3. List your chapter files in `project.yaml`:
   ```yaml
   input-files:
     - 01-introduction.md
     - 02-analysis.md
     - 03-conclusion.md
   
   metadata-files:
     - metadata.yaml
   ```
4. Edit your metadata in `metadata.yaml`
5. Build with VS Code: "Build PDF (project)" task
6. Or command line: `just pdf` (auto-detects project.yaml)

**Other formats:**
```bash
just html     # Build HTML (auto-detects project.yaml or content.md)
just docx     # Build DOCX with auto-formatting
just tex      # Generate LaTeX source
```

**Note:** `just` is a modern, cross-platform build tool (like Make but better).
- Install: `brew install just` (macOS) | `apt install just` (Linux) | `winget install Casey.Just` (Windows)
- Or use `python3 pandoc/build.py` directly (no `just` needed)
- `just pdf/html/docx` auto-detect whether to use `project.yaml` or `content.md`

**To preview while writing:**
1. Open your markdown file  
2. Press **Ctrl+K V** (Cmd+Shift+P on Mac)
3. Preview pane opens and updates as you type

### 4. Explore the Demo

Build the included demo to see all features:

```bash
cd md-ling-template/

# Build PDF
pandoc demo.md \
  --defaults=pandoc/defaults.yaml \
  --template=pandoc/templates/default.latex \
  -o demo.pdf

# Build HTML
pandoc demo.md \
  --defaults=pandoc/defaults.yaml \
  -o demo.html

# Build DOCX
pandoc demo.md \
  --defaults=pandoc/defaults.yaml \
  -o demo.docx
```

The demo showcases interlinear glossing, cross-references, citations, semantic markup, tables, and more.

## Features

### Presentation Slides

Create professional presentation slides from your markdown:

**Quick start:**
```bash
# Copy the slides blueprint
cp blueprints/slides.md my-talk.md

# Edit my-talk.md, then build:
pandoc my-talk.md --defaults=pandoc/defaults.yaml -t beamer --pdf-engine=lualatex -o my-talk.pdf
pandoc my-talk.md --defaults=pandoc/defaults.yaml -t slidy --embed-resources --standalone -o my-talk.html
pandoc my-talk.md --defaults=pandoc/defaults.yaml -o my-talk.pptx
```

**Supported formats:**
- **PDF (Beamer)** - LaTeX-based slides with excellent linguistic support
- **HTML (Slidy)** - W3C standard, customizable, works well for linguistics
- **PPTX (PowerPoint)** - Editable slides for collaboration

**Features:**
- ✓ Full support for interlinear glossing and linguistic examples
- ✓ Cross-references and citations work
- ✓ Incremental lists, two-column layouts
- ✓ Customizable styling via CSS (for Slidy) or themes (for Beamer)

**See [SLIDES.md](SLIDES.md) for complete documentation**

**Note:** Don't edit `blueprints/slides.md` directly - copy it to your own file first!

**Note on Beamer/PDF slides:** the template uses the [Metropolis](https://github.com/matze/mtheme) theme. If you installed a minimal LaTeX distribution (TinyTeX or BasicTeX), you may need to install it manually: `tlmgr install beamer metropolis pgfopts`.

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
See [@fig:tree] for the structure.
```

**Subfigures and subtables:**

Subfigures (use Pandoc div notation, each subfigure in separate paragraph):
```markdown
::: {#fig:trees}
![Subfigure A](tree-a.png){#fig:a width=45%}

![Subfigure B](tree-b.png){#fig:b width=45%}

Main caption for both
:::

Reference: [@fig:trees] or individual [@fig:a]

Note: For 2x2 grids, put images on separate lines (blank line = new row):
::: {#fig:grid}
![Image 1](a.png){#fig:a width=45%}

![Image 2](b.png){#fig:b width=45%}

![Image 3](c.png){#fig:c width=45%}

![Image 4](d.png){#fig:d width=45%}

Grid caption
:::
```

Subtables (custom filter):
```markdown
::: {#tbl:main}
**Main caption for both tables**

Table: First subtable {#tbl:first}

| Data | Value |
|------|-------|
| A    | 1     |

Table: Second subtable {#tbl:second}

| Data | Value |
|------|-------|
| B    | 2     |
:::

Reference: [@tbl:first] or [@tbl:second]
```

**Note:** In PDF/LaTeX, subtables are rendered using `\subfloat` with a single parent table and caption. In HTML, tables are visually grouped but numbered separately - reference individual tables only (`[@tbl:first]`), not the parent div.

**Tables without headers (auto-width):**

For tables that are essentially lists (no meaningful column headers), use empty header rows to trigger auto-width columns:

```markdown
|     |                                                      |
|-----|------------------------------------------------------|
| [ps]{.gl}  | privileged syntactic argument of the preceding clause |
| [act]{.gl} | occurs in previous clause, but not as the PSA |

: Information status categories {#tbl:infocategories}
```

In LaTeX, these render as `tabular` with auto-width columns (`ll`) instead of full-width `longtable` with percentage-based columns. The relative width of spaces/dashes in the empty header row hints at the desired column proportions.

### Citations

Add a `sources.bib` file and cite with:

```markdown
---
bibliography: [sources.bib]
---

According to @smith2020, we find that...
Previous work [@jones2019; @doe2021] shows...
```

(Use array format `[sources.bib]` for compatibility with pandoc-citer extension.)

**Customize citation style:**
```yaml
---
bibliography: [sources.bib]
csl: https://www.zotero.org/styles/unified-style-sheet-for-linguistics
---
```

Common linguistics styles: `unified-style-sheet-for-linguistics`, `language`, `linguistic-inquiry`, `glossa`. Download from [Zotero Style Repository](https://www.zotero.org/styles) or use URLs directly. See [Citation and Bibliography Formatting](#citation-and-bibliography-formatting) for more options.

### Semantic Markup for Object Language

The template provides CSS classes for semantic markup of linguistic data. These work across HTML, PDF, and DOCX outputs:

**Gloss abbreviations (smallcaps):**
```markdown
The word has [nom]{.gl} case marking.
```
Shorthand for the more verbose `.gloss` class from pandoc-ling.

**Object language (italics):**
```markdown
The Bernese German word [äue]{.ob} has a rich history.
```
Semantic alternative to explicit italics: `_äue_`

**Reconstructed forms (asterisk + italics):**
```markdown
The Proto-Indo-European root [bʰer-]{.rc} means 'to carry'.
```
Don't include the asterisk in the content - it's added automatically.

**Why use semantic markup?** While you can use underscores for italics (`_text_`), semantic classes make your intent explicit and allow for consistent formatting changes later. However, for quick drafts, plain Markdown formatting works fine.

### Glossing Abbreviations List

The template automatically manages glossing abbreviations. This feature:

1. **Lists** all abbreviations defined in metadata
2. **Links** abbreviations in running text (`.gl` spans) to definitions in HTML output (hover for tooltip)
3. **Generates** a formatted table of abbreviations
4. **Warns** about abbreviations used in running text but not defined in metadata

**Setup in YAML frontmatter:**

```yaml
glossing-abbreviations:
  APPL: applicative
  INV: inverse voice
  IND: indicative
  3: third person
  DEF: definite
  NOM: nominative

glossing-list:
  position: after  # 'before' (after intro) or 'after' (before references) or null (no list)
  title: "List of Glossing Abbreviations"
  warn-undefined: true
```

**How it works:**
- All abbreviations defined in `glossing-abbreviations` are listed in alphabetical order
- In running text, `[nom]{.gl}` becomes an `<abbr>` tag with tooltip in HTML
- The filter auto-discovers abbreviations from `.gl` spans and warns if not defined
- **Important**: Abbreviations in interlinear glosses must be manually added to metadata
- The list appears before References (or after Introduction if `position: before`)

**Inline abbreviation list:**
You can insert a comma-separated inline list of all abbreviations anywhere in your document:

For use inside footnotes or other inline contexts (where blank lines aren't allowed):

```markdown
Examples use Leipzig Glossing Rules.^[Abbreviations: [...]{.glossing-abbreviations-inline}]
```

This renders as: "appl (applicative), def (definite), ind (indicative), nom (nominative), ..."

Each abbreviation is formatted with the `.gl` class and gets tooltips in HTML output.

**Best practices:**
- Include ALL abbreviations you use, including those only in interlinear examples
- Define abbreviations you deviate from or those not in Leipzig Glossing Rules
- Test with `just html` to see tooltips (hover over `[nom]{.gl}` in running text)
- Use `warn-undefined: true` to catch missing definitions in running text
- Use inline list for space-constrained documents (no full table needed)

### Multi-File Projects

For longer documents (theses, books, complex papers), organize your content across multiple markdown files.

**Setup:**

1. Copy `project.yaml.template` to `project.yaml` (gitignored - your personal config)
2. List your chapter files in order
3. Build using VS Code "Build * (project)" tasks or `just` commands

**Example project structure:**

```
my-thesis/
├── project.yaml        # Your config (gitignored)
├── 01-introduction.md
├── 02-background.md
**Example project structure:**

```
my-thesis/
├── project.yaml        # Your config (gitignored)
├── metadata.yaml       # Shared metadata (can be tracked in git)
├── 01-introduction.md
├── 02-background.md
├── 03-method.md
├── 04-results.md
├── 05-conclusion.md
├── sources.bib
└── pandoc/
    └── ...
```

**project.yaml:**
```yaml
input-files:
  - 01-introduction.md
  - 02-background.md
  - 03-method.md
  - 04-results.md
  - 05-conclusion.md

metadata-files:
  - metadata.yaml
```

**metadata.yaml:**
```yaml
---
title: "My Dissertation Title"
author: "Your Name"
date: "2026"
bibliography: [sources.bib]
---
```

**Build with:**

- **VS Code**: Press **Ctrl+Shift+B** → "Build PDF (project)"
- **Command line**: `just pdf` (auto-detects project.yaml)
- **Or directly**: `python3 pandoc/build.py --project`
- **Other formats**: `just html`, `just docx`, `just tex`

**Metadata options:**

1. **Separate metadata.yaml** (shown above): Recommended for multi-file projects
2. **In first markdown file**: Put YAML frontmatter in `01-introduction.md`
3. **Mixed**: Frontmatter in first file + metadata.yaml for shared settings

**Cross-references work across files:**

```markdown
# Introduction {#sec:intro}      # in 01-introduction.md
# Method {#sec:method}            # in 03-method.md

See [@sec:intro] for background.  # works from any file!
```

**Note:** `project.yaml` is gitignored so your personal config (file lists, custom fonts, etc.) doesn't conflict with other users. The template infrastructure (`pandoc/defaults.yaml`, filters, etc.) stays under version control.

## File Structure

```
md-ling-template/
├── README.md              # This file
├── project.yaml.template  # Template for multi-file projects (copy to project.yaml)
├── metadata.yaml.template # Template for multi-file metadata (copy to metadata.yaml)
├── justfile               # CLI build commands (cross-platform, like Make)
├── Makefile               # Legacy build automation (optional, still works)
├── demo.md                # Feature showcase document
├── demo.bib               # Example bibliography
├── .vscode/               # VS Code configuration
│   ├── settings.json      # Editor settings
│   ├── tasks.json         # Build tasks (Ctrl+Shift+B)
│   ├── extensions.json    # Recommended extensions
│   ├── markdown.code-snippets  # Markdown snippets (ex, gl, ob, etc.)
│   └── README.md          # VS Code usage guide
├── pandoc/                # Pandoc configuration
│   ├── defaults.yaml      # Default pandoc settings
│   ├── build.py           # Cross-platform build helper (Python)
│   ├── crossref-*.yaml    # Language-specific labels
│   ├── lang-de.yaml       # German language settings
│   ├── style.css          # HTML styling
│   ├── slidy-style.css    # HTML slides styling
│   ├── filters/           # Lua filters
│   │   ├── linguistic-markup.lua  # Semantic markup (.gl, .ob, .rc)
│   │   ├── glossing-list.lua  # Abbreviations management
│   │   ├── subtables.lua  # Subtable support (custom)
│   │   ├── simple-tables.lua  # Auto-width tables for empty headers
│   │   └── pandoc-ling.lua  # Bundled v1.6 (2026-03-19)
│   └── templates/         # Output templates
│       ├── default.html
│       └── default.latex
├── tests/                 # Test suite with examples
└── requirements.txt       # Python dependencies for tests
```

**Bundled Filters:**
- `linguistic-markup.lua` - Converts semantic markup classes (`.gl`, `.ob`, `.rc`) to appropriate formatting in all output formats
- `glossing-list.lua` - Auto-discovers and links glossing abbreviations, generates abbreviations table/list
- `subtables.lua` - Custom filter for grouping related tables (like subfigures)
- `simple-tables.lua` - Converts tables with empty headers to auto-width `tabular` (LaTeX), avoiding full-page stretching
- `pandoc-ling.lua` - Version 1.6 from [Michael Cysouw's repository](https://github.com/cysouw/pandoc-ling) for professional linguistic examples

## Customization

### Document Formatting via Metadata

The template supports extensive customization through document metadata without editing the template itself. Add these to your YAML frontmatter or `metadata.yaml`:

**Page layout:**
```yaml
# Margins and paper size
geometry:
  - left=2.4cm
  - right=2.4cm
  - top=2.5cm
  - bottom=2.4cm
papersize: a4         # or: letter
fontsize: 11pt        # or: 10pt, 12pt

# Two-sided printing with alternating headers
classoption:
  - twoside
```

**Fonts:**
```yaml
mainfont: "Linux Libertine"    # or: "Noto Serif", "Charis SIL"
# Template will auto-detect common linguistics fonts if not specified
```

**Headers and footers:**
```yaml
header-includes:
  - |
    ```{=latex}
    \usepackage{fancyhdr}
    \pagestyle{fancy}
    \lhead[\thepage]{Short Title}
    \rhead[Short Title]{\thepage}
    \cfoot{}
    ```
```

**Line spacing:**
```yaml
header-includes:
  - |
    ```{=latex}
    \usepackage{setspace}
    \onehalfspacing
    ```
```

**Custom LaTeX packages and commands:**
```yaml
header-includes:
  - |
    ```{=latex}
    \usepackage{lineno}
    \usepackage{draftwatermark}
    \SetWatermarkLightness{0.95}
    \newcommand{\mycommand}[1]{\textbf{#1}}
    ```
```

**Including external LaTeX configuration files:**
```yaml
header-includes:
  - |
    ```{=latex}
    \input{my-custom-config.tex}
    ```
```
(Put `my-custom-config.tex` in the same directory as your markdown file, or use a relative path like `\input{stuff/config.tex}`)

**Important:** Use ````{=latex}` code blocks to mark raw LaTeX content (requires `raw_attribute` extension, enabled by default). This prevents Pandoc from interpreting backslashes and braces as Markdown.

**Complete example** (single-file document):
```yaml
---
title: "My Article"
author: "Your Name"
date: "2026"
bibliography: [sources.bib]

# Layout
geometry: [left=2.4cm, right=2.4cm, top=2.5cm, bottom=2.4cm]
fontsize: 11pt
papersize: a4
classoption: [twoside]

# Typography
mainfont: "Linux Libertine"

# Custom LaTeX
header-includes:
  - |
    ```{=latex}
    \usepackage{fancyhdr}
    \pagestyle{fancy}
    \lhead[\thepage]{My Article}
    \rhead[My Article]{\thepage}
    \cfoot{}
    
    \usepackage{lineno}
    % \linenumbers  % Uncomment for draft mode
    ```
---

# Introduction

Your content here...
```

**See [examples/custom-formatting.md](examples/custom-formatting.md) for a complete production-grade example** with headers, spacing, custom commands, and more.

**For multi-file projects,** put customizations in `metadata.yaml`:
```yaml
---
title: "My Dissertation"
author: "Your Name"
mainfont: "Linux Libertine"
geometry: [margin=1in]
fontsize: 12pt
documentclass: book     # For chapters instead of sections
---
```

### Adding Custom Lua Filters

To add your own filters:

1. Place your `.lua` file in `pandoc/filters/`
2. Add it to `pandoc/defaults.yaml`:
   ```yaml
   filters:
     - pandoc/filters/linguistic-markup.lua
     - pandoc/filters/my-custom-filter.lua  # Add your filter
     - pandoc/filters/pandoc-ling.lua
     # ... rest of filters
   ```

**Note:** Filter order matters! Filters that modify AST should typically run before `pandoc-crossref` and `citeproc`.

### LaTeX Template Customization

For major structural changes, edit `pandoc/templates/default.latex`:
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

The template supports English (default) and German with language-specific labels:

**English (default):**
- Figure → "Figure", Table → "Table", Example → "Example"
- References section → "References"
- Uses `pandoc/crossref-en-US.yaml` (loaded by default in `defaults.yaml`)

**German:**
To switch to German, edit `pandoc/defaults.yaml` and change the metadata-files line:

```yaml
metadata-files:
  - pandoc/crossref-de-DE.yaml  # Change from crossref-en-US.yaml
```

This provides:
- Figure → "Abbildung", Table → "Tabelle", Example → "Beispiel"
- References section → "Literatur"

You can also set language in your document metadata:

```yaml
---
lang: de-DE
---
```

Or use the command line:
```bash
pandoc content.md \
  --defaults=defaults.yaml \
  --metadata-file=pandoc/crossref-de-DE.yaml \
  -o output.pdf
```

### Citation and Bibliography Formatting

The template uses Pandoc's `citeproc` for citations. Customize via metadata:

**Citation style (CSL):**
```yaml
---
bibliography: [sources.bib]
csl: https://www.zotero.org/styles/unified-style-sheet-for-linguistics
# Or use a local file:
# csl: my-style.csl
---
```

**Common linguistics citation styles:**
- Unified Style Sheet for Linguistics: `unified-style-sheet-for-linguistics`
- Language (journal): `language`  
- Linguistic Inquiry: `linguistic-inquiry`
- Glossa: `glossa`

Download CSL files from the [Zotero Style Repository](https://www.zotero.org/styles) and place them in your project directory, or use URLs directly.

**Citation format options:**
```yaml
---
link-citations: true        # Make citations clickable (default: true in template)
citation-abbreviations: abbreviations.json  # Define abbreviations
suppress-bibliography: false  # Set to true to hide bibliography
reference-section-title: "References"  # Customize bibliography heading
---
```

**Bibliography formatting in LaTeX/PDF:**

For more advanced control (BibLaTeX features), use `header-includes`:
```yaml
header-includes:
  - |
    ```{=latex}
    % Override citeproc with biblatex (advanced users only)
    % \usepackage[backend=biber,
    %             style=authoryear-comp,
    %             maxcitenames=2]{biblatex}
    % \addbibresource{sources.bib}
    ```
```

**Note:** The template defaults to `citeproc` (works for all output formats). For LaTeX-only projects needing advanced bibliography features, you can switch to BibLaTeX, but this will break HTML/DOCX output.

## VS Code Integration

The template includes complete VS Code configuration with code snippets for all custom markdown features:

### How to Build Your Document

**Quick build (default):**
- Press **Ctrl+Shift+B** (Cmd+Shift+B on Mac)
- Builds PDF from current file using metadata from YAML frontmatter

**All build options:**
- Press **Ctrl+Shift+P** (Cmd+Shift+P on Mac) → type "run task" → choose:
  - **Build PDF (current file)** - Single file with frontmatter metadata
  - **Build PDF (project)** - Multi-file using project.yaml configuration
  - **Build HTML (current file)** / **Build HTML (project)**
  - **Build DOCX (current file)** / **Build DOCX (project)**
  - **Build Slides (PDF/Beamer)**, **Build Slides (HTML/Slidy)**
  - **Check glossing abbreviations** - Validate HTML output

**Live preview:**
- Press **Ctrl+K V** (Cmd+K V on Mac)
- Preview updates as you type
- Shows linguistic examples, citations, and cross-references

**For multi-file projects:**
Copy `project.yaml.template` to `project.yaml`, list your chapter files, then use "Build * (project)" tasks or `just` commands (see [Multi-File Projects](#multi-file-projects) section).

**For multi-file preview with metadata.yaml:**
Edit `.vscode/settings.json` and uncomment the metadata-file line:
```json
"markdown-preview-enhanced.pandocArguments": [
  "--defaults=pandoc/defaults.yaml",
  "--metadata-file=metadata.yaml",  // ← Uncomment this line
  "--resource-path=.:pandoc"
]
```

### Code Snippets
Type trigger + Tab for instant markdown templates:

**Examples:** `ex`, `mex`
**Tables/Figures:** `tbl`, `fig`, `subfigs`, `subtables`

See [`.vscode/README.md`](.vscode/README.md) for complete documentation and all available shortcuts.

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

## DOCX Output for Collaborative Editing

While PDF (via LaTeX) is recommended for final typesetting, DOCX output is useful for:
- Sharing drafts with collaborators
- Getting feedback from non-LaTeX users
- Submission to journals that require Word format

### Known Limitations

**Interlinear examples don't break across pages:**
- Pandoc-ling uses tables for interlinear glosses
- DOCX tables cannot intelligently break across pages like LaTeX can
- **Workaround:** Keep examples reasonably short, or manually split long examples in Word

**Table column widths need optimization:**
- Default table behavior may not look optimal
- **Solution:** The template includes automatic post-processing! All DOCX build tasks automatically run `fix_docx.py` to optimize table columns and apply custom styles.
- **Note:** The autofit setting enables Word's automatic column adjustment. The visual effect may not be immediately obvious, but it ensures columns will resize properly when you edit content in Word.

**Extra spacing between examples:**
- Word inserts paragraphs after tables by design
- **Workaround:** In Word, select the paragraph mark after a table → Format → Font → Size: 1pt

### Automatic Post-Processing

All DOCX builds automatically run a post-processing script that:
1. **Sets all tables to autofit (minimal column width)** - Enables automatic column width adjustment in Word
2. **Ensures custom character styles are defined** - Makes [text]{.gl}, [text]{.ob}, [text]{.rc} markup work with proper formatting:
   - `.gl` (gloss abbreviations) → small caps
   - `.ob` (object language) → italic
   - `.rc` (reconstructed forms) → *italic (with asterisk prefix)

**How it works:** Lua filters apply formatting during conversion → Python post-processor ensures styles exist and tables are configured properly. For print-quality output with serif fonts and professional styling, also use a reference.docx template (see below).

The script runs automatically when using:
- VS Code build tasks
- `just docx` command
- `pandoc/build.py` script

**Manual usage:**
```bash
# Build DOCX
pandoc content.md --defaults=pandoc/defaults.yaml -o output.docx

# Post-process to fix tables and styles
python3 pandoc/filters/fix_docx.py output.docx

# Or in one command:
pandoc content.md --defaults=pandoc/defaults.yaml -o output.docx && \
  python3 pandoc/filters/fix_docx.py output.docx
```

**Dependencies:**
The post-processing script requires `python-docx`:
```bash
pip install -r requirements.txt
```

### Best Practices for DOCX Output

1. **Use DOCX for drafts and sharing only** - Use PDF for final publication
2. **Keep examples reasonably short** - Very long interlinear examples may need manual breaking
3. **Build frequently** - Check output as you write to catch issues early
4. **Provide both formats** - Share both PDF and DOCX so readers can choose

### Building DOCX

**VS Code:** 
- Single file: Ctrl+Shift+P → "Run Task" → "Build DOCX (current file)"
- Multi-file: Ctrl+Shift+P → "Run Task" → "Build DOCX (project)" (uses project.yaml)

**Command line:**
```bash
# Recommended: Use 'just'
just docx             # Single file or project.yaml

# Or directly with build.py
python3 pandoc/build.py content.md  # Single file
python3 pandoc/build.py --project   # Multi-file (reads project.yaml)

# Or raw pandoc (no auto-post-processing)
pandoc content.md --defaults=pandoc/defaults.yaml -o output.docx
python3 pandoc/filters/fix_docx.py output.docx  # Manual post-processing
```

### Print-Quality DOCX Output

For **print-quality** DOCX with serif fonts and professional formatting:

1. **Generate a reference template:**
   ```bash
   cd pandoc/
   ./generate_reference_docx.sh
   ```

2. **Customize in Word:**
   - Open `pandoc/reference.docx` in Microsoft Word
   - Set Normal text to serif font (Libertinus Serif, Times New Roman, etc.)
   - Change heading colors from blue to black
   - Configure table styles with minimal borders (top/mid/bottom only)
   - Save and close

3. **Build with reference:**
   ```bash
   pandoc content.md \
     --defaults=pandoc/defaults.yaml \
     --reference-doc=pandoc/reference.docx \
     -o output.docx && \
     python3 pandoc/filters/fix_docx.py output.docx
   ```

**See [pandoc/DOCX-WORKFLOW.md](pandoc/DOCX-WORKFLOW.md) for complete documentation:**
- Why post-processing is necessary
- Detailed reference.docx setup instructions
- Recommended fonts for linguistics
- Table formatting (booktabs-style borders)
- Troubleshooting common issues

## Troubleshooting

**Preview doesn't show linguistic examples?**
- Install Markdown Preview Enhanced extension
- Verify pandoc is in PATH: `which pandoc`
- Check pandoc-crossref is installed: `which pandoc-crossref`

**PDF build fails?**
- Ensure LuaLaTeX is installed: `which lualatex`
- Check terminal output for specific LaTeX errors

**Fonts not rendering properly in PDF?**

The template tries several linguistics-friendly fonts, but the `\IfFontExistsTF` fallback doesn't always work correctly.

**Solution:** Explicitly set a font in your document metadata:
```yaml
---
mainfont: "Noto Serif"
# Or: "Linux Libertine" or "Charis SIL"
---
```

**Install at least one of these fonts:**
1. **Noto Serif** - [Download](https://fonts.google.com/noto/specimen/Noto+Serif)
2. **Linux Libertine** - [Download](https://libertine-fonts.org/)
3. **Charis SIL** - [Download](https://software.sil.org/charis/)

Without an explicitly specified font, the template may fall back to Latin Modern Roman which lacks many IPA characters and extended diacritics.

**Cross-references not working?**
- Verify pandoc-crossref is installed and in PATH
- Check that IDs use correct prefixes: `#sec:`, `#tbl:`, `#fig:`
- Ensure IDs are unique

**LaTeX Error: Environment subfigure undefined?**
- The template uses `subfig` package (not `subcaption`)
- This is configured via `subfigGrid: true` in crossref YAML files
- If using custom pandoc-crossref settings, ensure subfigGrid is enabled

**Check for undefined glossing abbreviations:**

After building HTML output, check for abbreviations that appear in your examples but aren't defined in metadata:
```bash
just check              # Check output.html (default)
just check my-file.html # Check a specific HTML file
# or directly: python3 check_gloss_markup.py my-file.html
```

This scans the HTML output for small-caps abbreviations created by pandoc-ling and warns if any are missing from your `glossing-abbreviations` metadata. It provides a ready-to-copy YAML block with placeholders:
```yaml
glossing-abbreviations:
  NOM: DEFINITION
  ACC: DEFINITION
  3SG: DEFINITION
```

The Lua filter already warns during build, but this post-processing check catches all missing abbreviations in one go and makes it easy to add them.

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
