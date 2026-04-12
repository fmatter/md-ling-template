# VS Code Setup for Linguistic Writing

This directory contains VS Code configuration for the md-ling-template workflow.

## Quick Start

### Build your document
- **Ctrl+Shift+B** (Cmd+Shift+B on Mac) → Build with default task
- **Ctrl+P** then type `task ` → See all available tasks

### Available Tasks

**Default task** (Ctrl+Shift+B):
- **Build PDF (current file)** - Builds current file with its frontmatter metadata

**Single-file projects:**
1. **Build PDF (current file)** - Uses metadata from YAML frontmatter
2. **Build HTML (current file)** - HTML output from current file
3. **Build LaTeX (current file)** - Generate .tex for debugging

**Multi-file projects** (metadata in frontmatter):
1. **Build PDF (all .md files)** - Compile all `*.md` files, uses frontmatter from first file
2. **Build HTML (all .md files)** - HTML output combining all markdown files

**Multi-file projects with metadata.yaml:**
1. **Build PDF (with metadata.yaml)** - Compile all `*.md` files + `metadata.yaml`
2. **Build HTML (with metadata.yaml)** - HTML output with external metadata
3. **Build with Makefile** - Use project's Makefile (if present)

**Other tasks:**
1. **Run tests** - Run the pytest test suite
2. **Clean outputs** - Remove generated PDF/HTML/TeX files

### Preview
- **Ctrl+K V** (Cmd+K V on Mac) → Open markdown preview side-by-side
- Preview uses actual Pandoc with all filters AND custom CSS styling!
  - Linguistic examples render correctly with pandoc-ling
  - Glossing abbreviations show in smallcaps
  - Citations and cross-references work

**For single-file projects:**
- Put metadata (title, author, bibliography) in YAML frontmatter (between `---` lines)
- Preview will use this metadata automatically

**For multi-file projects with `metadata.yaml`:**
- Citations in preview won't work by default (uses current file's frontmatter only)
- To enable full metadata in preview, create `.vscode/settings.json` in your project:
  ```json
  {
    "markdown-preview-enhanced.pandocArguments": [
      "--defaults=pandoc/defaults.yaml",
      "--metadata-file=metadata.yaml",
      "--citeproc",
      "--css=pandoc/style.css",
      "--resource-path=.:pandoc"
    ]
  }
  ```
- This overrides the template's default settings for your project only

## Recommended Extensions

When you first open this workspace, VS Code will suggest these extensions:

- **Markdown Preview Enhanced** - Live preview with Pandoc integration
- **Markdown All in One** - Shortcuts for lists, tables, etc.
- **Code Spell Checker** - Catch typos while writing
- **LaTeX Workshop** - Syntax highlighting for .tex files
- **vscode-pandoc** - Additional pandoc integration

## Features Configured

### Editor
- Word wrap enabled for markdown files
- 80-character ruler for readability
- Trailing whitespace automatically trimmed
- Final newline automatically added

### Preview
- Uses your actual Pandoc defaults.yaml
- Shows linguistic examples with pandoc-ling filter
- Citations and cross-references work
- What you see matches the PDF output

### File Management
- Python cache files hidden from explorer
- PDF/TEX files excluded from search
- Clean workspace view focused on source files

## Custom Keyboard Shortcuts

The template includes code snippets for quick markdown input. Type the trigger and press Tab:

### Linguistic Examples
- `ex` → Simple numbered example
- `exgloss` → Interlinear glossed example with formatGloss
- `exsub` → Sub-examples (a, b, c)

### Semantic Markup
- `gl` → Gloss abbreviation [nom]{.gl}
- `ob` → Object language [word]{.ob}
- `rc` → Reconstructed form [*form]{.rc}

### Tables & Figures
- `tbl` → Table with caption and ID
- `fig` → Figure with caption and ID
- `subfigs` → Subfigures in div wrapper (blank lines between each)
- `subtables` → Subtables with subcaptions
- `abbrinline` → Inline abbreviations list (block version)
- `abbrspan` → Inline abbreviations (for footnotes)

### Cross-References
- `refsec` → [@sec:id]
- `reffig` → [@fig:id]
- `reftbl` → [@tbl:id]
- `refex` → [@ex:id]

### Citations
- `cite` → In-text citation @citekey
- `citep` → Parenthetical [@citekey]
- `citepage` → Citation with page [@citekey, p. 123]

### Sections
- `sec` → Section heading with ID

All snippets use tab stops for quick navigation through placeholders.

## Troubleshooting

**Preview not showing linguistic examples?**
- Make sure Markdown Preview Enhanced extension is installed
- Check that pandoc is in your PATH
- Verify pandoc-crossref is installed

**Build task fails?**
- Check Terminal output for error messages
- Ensure all paths in defaults.yaml are correct
- Try building with `--verbose` flag for more details

**Fonts missing in PDF?**
- Install recommended fonts: Noto Serif, Linux Libertine, or Charis SIL
- Template will fall back to Latin Modern if fonts unavailable
