# md-ling-template

A complete Pandoc template for writing linguistic articles and books with professional typesetting of interlinear glosses, cross-references, and citations.

**See [`demo.md`](demo.md) for a comprehensive showcase of all features.**

**Template blueprints** in the `blueprints/` folder:
- [`blueprints/article.md`](blueprints/article.md) - Starter template for journal articles
- [`blueprints/book.md`](blueprints/book.md) - Starter template for books/theses
- [`blueprints/slides.md`](blueprints/slides.md) - Starter template for presentations

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
mainfont: "Noto Serif"
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

# Create a minimal sources.bib in your project root
cat > sources.bib << 'EOF'
@article{example2024,
  author  = {Smith, John},
  title   = {An Example Article},
  journal = {Journal of Examples},
  year    = {2024}
}
EOF
```

### 3. Build Your Document

**To build a PDF in VS Code:**
1. Open your markdown file
2. Press **Ctrl+Shift+B** (Cmd+Shift+B on Mac)
3. PDF appears next to your markdown file

**To preview while writing:**
1. Open your markdown file
2. Press **Ctrl+K V** (Cmd+K V on Mac)
3. Preview pane opens and updates as you type

**To build HTML:**
1. Press **Ctrl+Shift+P** (Cmd+Shift+P on Mac)
2. Type "run task" and press Enter
3. Choose "Build HTML (current file)"
4. HTML appears next to your markdown file

**To build DOCX (for sharing/editing in Word):**
1. Press **Ctrl+Shift+P** (Cmd+Shift+P on Mac)
2. Type "run task" and press Enter
3. Choose "Build DOCX (current file)"
4. DOCX appears next to your markdown file

**Note on DOCX output:** DOCX is useful for sharing drafts and collaborative editing, but has limitations:
- Interlinear examples use tables that don't break across pages (manual intervention needed for long examples)
- Table column widths may need manual optimization in Word (select table → AutoFit → AutoFit to Contents)
- Use PDF for final typesetting and publication

**For multi-file projects:**
- See the [Multi-File Projects](#multi-file-projects) section below
- Quick answer: Customize the included Makefile with your file list

**Command line alternative:**

```bash
# Build PDF
pandoc content.md \
  --defaults=pandoc/defaults.yaml \
  --template=pandoc/templates/default.latex \
  -o output.pdf

# Build HTML
pandoc content.md \
  --defaults=pandoc/defaults.yaml \
  -o output.html

# Build DOCX
pandoc content.md \
  --defaults=pandoc/defaults.yaml \
  -o output.docx
```

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

Create professional presentation slides from the same markdown source:

**Supported formats:**
- **PDF (Beamer)** - LaTeX-based slides with excellent linguistic support
- **HTML (Slidy)** - W3C standard, customizable, works well for linguistics
- **PPTX (PowerPoint)** - Editable slides for collaboration

**Quick start:**
```bash
# Edit blueprints/slides.md, then build:
make slides-pdf       # PDF slides (Beamer) - ★ Best quality
make slides-html      # HTML slides (Slidy) - ★ Web delivery
make slides-pptx      # PowerPoint slides
make slides-all       # Build all formats
```

**Features:**
- ✓ Full support for interlinear glossing and linguistic examples
- ✓ Cross-references and citations work
- ✓ Incremental lists, two-column layouts
- ✓ Customizable styling via CSS (for Slidy) or themes (for Beamer)
- ✓ Configuration in metadata, not command-line flags

**See [SLIDES.md](SLIDES.md) for complete documentation**

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

Subfigures (use div wrapper, each subfigure in separate paragraph):
```markdown
<div id="fig:trees">
![Subfigure A](tree-a.png){#fig:a width=45%}

![Subfigure B](tree-b.png){#fig:b width=45%}

Main caption for both
</div>

Reference: [@fig:trees] or individual [@fig:a]

Note: For 2x2 grids, put images on separate lines (blank line = new row):
<div id="fig:grid">
![Image 1](a.png){#fig:a width=45%}

![Image 2](b.png){#fig:b width=45%}

![Image 3](c.png){#fig:c width=45%}

![Image 4](d.png){#fig:d width=45%}

Grid caption
</div>
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
bibliography: sources.bib
---

According to @smith2020, we find that...
Previous work [@jones2019; @doe2021] shows...
```

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

```markdown
This paper uses the following abbreviations:

::: glossing-abbreviations-inline
:::
```

For use inside footnotes or other inline contexts (where blank lines aren't allowed):

```markdown
Examples use Leipzig Glossing Rules.^[Abbreviations: [...]{.glossing-abbreviations-inline}]
```

Both render as: "appl (applicative), def (definite), ind (indicative), nom (nominative), ..."

Each abbreviation is formatted with the `.gl` class and gets tooltips in HTML output.

**Best practices:**
- Include ALL abbreviations you use, including those only in interlinear examples
- Define abbreviations you deviate from or those not in Leipzig Glossing Rules
- Test with `make html` to see tooltips (hover over `[nom]{.gl}` in running text)
- Use `warn-undefined: true` to catch missing definitions in running text
- Use inline list for space-constrained documents (no full table needed)

### Multi-File Projects

For longer documents (theses, books, complex papers), organize your content across multiple markdown files.

**Metadata options:**

1. **YAML frontmatter** (default): Put metadata in the first markdown file
2. **metadata.yaml file** (optional): For shared metadata across many files

**Option 1: Frontmatter in first file**

```
my-thesis/
├── 01-introduction.md   # Contains metadata frontmatter
├── 02-background.md
├── 03-method.md
├── 04-results.md
├── 05-conclusion.md
├── sources.bib
└── pandoc/
    └── ...
```

In `01-introduction.md`:
```markdown
---
title: "My Dissertation Title"
author: "Your Name"
date: "2026"
bibliography: sources.bib
---

# Introduction {#sec:intro}

...
```

Build with: Customize Makefile or VS Code task (see below)

**Option 2: Separate metadata.yaml file**

```
my-thesis/
├── metadata.yaml       # Shared metadata
├── 01-introduction.md
├── 02-background.md
├── 03-method.md
├── 04-results.md
├── 05-conclusion.md
├── sources.bib
└── pandoc/
    └── ...
```

**metadata.yaml:**
```yaml
---
title: "My Dissertation Title"
author: "Your Name"
date: "2026"
bibliography: sources.bib
---
```

**Build all chapters together:**

**Recommended: Use a Makefile to specify file order explicitly**

The template includes an example Makefile. Customize it for your project:

```makefile
CHAPTERS := 01-introduction.md 02-background.md 03-method.md 04-results.md 05-conclusion.md

thesis.pdf: $(CHAPTERS) metadata.yaml sources.bib
	pandoc $(CHAPTERS) \
	  --defaults=pandoc/defaults.yaml \
	  --metadata-file=metadata.yaml \
	  --template=pandoc/templates/default.latex \
	  -o thesis.pdf

.PHONY: clean
clean:
	rm -f thesis.pdf
```

Then simply run: `make thesis.pdf`

Or in VS Code: **Ctrl+Shift+P** → type "run task" → **Build with Makefile**

**Alternative: Command line with explicit file list**

```bash
# Using metadata.yaml file - list files in desired order
pandoc 01-introduction.md \
       02-background.md \
       03-method.md \
       04-results.md \
       05-conclusion.md \
  --defaults=pandoc/defaults.yaml \
  --metadata-file=metadata.yaml \
  --template=pandoc/templates/default.latex \
  -o thesis.pdf
```

**Important: Argument order matters!** Pandoc processes arguments in order, so later values override earlier ones. Always put `--defaults` before `--metadata-file` to allow your metadata.yaml to override template defaults (e.g., font selection).

**Or customize the VS Code task:**
Edit `.vscode/tasks.json` and update the "Build PDF (multi-file with metadata.yaml)" task to list your actual filenames in the desired order.

**Cross-references work across files:**

```markdown
# Introduction {#sec:intro}      # in 01-introduction.md
# Method {#sec:method}            # in 03-method.md

See [@sec:intro] for background.  # works from any file!
```

## File Structure

```
md-ling-template/
├── README.md           # This file
├── Makefile            # Example build automation (customize for your project)
├── demo.md             # Feature showcase document
├── demo.bib            # Example bibliography
├── .vscode/            # VS Code configuration
│   ├── settings.json   # Editor settings
│   ├── tasks.json      # Build tasks (Ctrl+Shift+B)
│   ├── extensions.json # Recommended extensions
│   ├── markdown.code-snippets  # Markdown snippets (ex, gl, ob, etc.)
│   └── README.md       # VS Code usage guide
├── pandoc/             # Pandoc configuration
│   ├── defaults.yaml   # Default pandoc settings
│   ├── crossref-*.yaml # Language-specific labels
│   ├── lang-de.yaml    # German language settings
│   ├── style.css       # HTML styling
│   ├── filters/        # Lua filters
│   │   ├── linguistic-markup.lua  # Semantic markup (.gl, .ob, .rc)
│   │   ├── glossing-list.lua  # Abbreviations management
│   │   ├── subtables.lua  # Subtable support (custom)
│   │   ├── simple-tables.lua  # Auto-width tables for empty headers
│   │   └── pandoc-ling.lua  # Bundled v1.6 (2026-03-19)
│   └── templates/      # Output templates
│       ├── default.html
│       └── default.latex
├── tests/              # Test suite with examples
└── requirements.txt    # Python dependencies for tests
```

**Bundled Filters:**
- `linguistic-markup.lua` - Converts semantic markup classes (`.gl`, `.ob`, `.rc`) to appropriate formatting in all output formats
- `glossing-list.lua` - Auto-discovers and links glossing abbreviations, generates abbreviations table/list
- `subtables.lua` - Custom filter for grouping related tables (like subfigures)
- `simple-tables.lua` - Converts tables with empty headers to auto-width `tabular` (LaTeX), avoiding full-page stretching
- `pandoc-ling.lua` - Version 1.6 from [Michael Cysouw's repository](https://github.com/cysouw/pandoc-ling) for professional linguistic examples

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

## VS Code Integration

The template includes complete VS Code configuration with code snippets for all custom markdown features:

### How to Build Your Document

**Quick build (default):**
- Press **Ctrl+Shift+B** (Cmd+Shift+B on Mac)
- Builds PDF from current file using metadata from YAML frontmatter

**All build options:**
- Press **Ctrl+Shift+P** (Cmd+Shift+P on Mac) → type "run task" → choose:
  - **Build PDF (current file)** - Single file with frontmatter metadata
  - **Build PDF (multi-file with metadata.yaml)** - Customize file list in task, uses external metadata.yaml
  - **Build HTML (current file)** - HTML from single file
  - **Build HTML (multi-file with metadata.yaml)** - Customize file list in task, uses external metadata.yaml
  - **Build with Makefile** - Recommended for multi-file projects (see below)

**Live preview:**
- Press **Ctrl+K V** (Cmd+K V on Mac)
- Preview updates as you type
- Shows linguistic examples, citations, and cross-references

**For multi-file projects:**
The multi-file tasks include placeholder filenames (`01-intro.md`, `02-chapter.md`, `03-conclusion.md`). **Edit [.vscode/tasks.json](.vscode/tasks.json) to match your actual files**, or better yet, use a Makefile (see [Multi-File Projects](#multi-file-projects) section).

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
- The Makefile (`make docx`)

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

**VS Code:** Press Ctrl+Shift+P → "Run Task" → "Build DOCX (current file)"

**Command line:**
```bash
# Single file
pandoc content.md --defaults=pandoc/defaults.yaml -o output.docx

# Multi-file with metadata.yaml
pandoc *.md --defaults=pandoc/defaults.yaml --metadata-file=metadata.yaml -o article.docx
```

**Makefile:**
```bash
make docx  # If using the template's Makefile
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
make check-gloss
# or directly: python3 check_gloss_markup.py demo.html demo.md
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
