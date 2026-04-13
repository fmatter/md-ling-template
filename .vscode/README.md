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
3. **Build DOCX (current file)** - DOCX output for sharing/editing in Word
4. **Build LaTeX (current file)** - Generate .tex for debugging

**Multi-file projects** (metadata in frontmatter):
1. **Build PDF (all .md files)** - Compile all `*.md` files, uses frontmatter from first file
2. **Build HTML (all .md files)** - HTML output combining all markdown files

**Multi-file projects with metadata.yaml:**
1. **Build PDF (with metadata.yaml)** - Compile all `*.md` files + `metadata.yaml`
2. **Build HTML (with metadata.yaml)** - HTML output with external metadata
3. **Build DOCX (with metadata.yaml)** - DOCX output with external metadata
4. **Build with Makefile** - Use project's Makefile (if present)

**Presentation slides** (edit blueprints/slides.md):
1. **Build Slides (PDF/Beamer)** - Professional LaTeX-based slides
2. **Build Slides (HTML/Slidy)** - Web-based slides (W3C standard, works well for linguistics)
3. **Build Slides (PPTX)** - PowerPoint slides for collaboration

**Other tasks:**
1. **Run tests** - Run the pytest test suite
2. **Clean outputs** - Remove generated PDF/HTML/TeX/DOCX files

**Note on DOCX output:**
- Useful for sharing drafts and collaborative editing
- **Tables are automatically optimized!** All DOCX builds run post-processing to set minimal column widths
- **Custom styles work:** [text]{.gl}, [text]{.ob}, [text]{.rc} are formatted properly (small caps, italic)
- Limitation: Tables don't break across pages (keep examples reasonably short)
- Use PDF for final typesetting and publication

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

## Required Extensions

When you first open this workspace, VS Code will prompt you to install:

- **Markdown Preview Enhanced** - Live preview with Pandoc integration
- **Pandoc Citer** - Autocomplete for citations and cross-references

These extensions provide:
- Live preview with actual Pandoc rendering (Markdown Preview Enhanced)
- IntelliSense autocomplete for `@citekey`, `@fig:id`, `@sec:id`, `@tbl:id` (Pandoc Citer)

**Optional:** If you want spell checking, install "Code Spell Checker" separately.

**Note for Pandoc Citer:**
- Configured to read from `metadata.yaml` for multi-file projects
- In markdown frontmatter: use `bibliography: [sources.bib]` (list notation required)
- In metadata.yaml: use `bibliography: sources.bib` (string notation works fine)

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

## Code Snippets

The template includes code snippets for quick markdown input.

**How to use snippets:**

1. **Make sure you've reloaded VS Code** after opening this workspace (the settings need to load)
2. Start typing a snippet prefix (e.g., `ex`)
3. A suggestion dropdown will appear automatically
4. Press **Tab** to expand the snippet (or press Enter to select it)
5. **Tab** moves between placeholders, **Shift+Tab** goes back

**If suggestions don't appear automatically:**
- Press **Ctrl+Space** to manually trigger them
- Make sure you're editing a `.md` file
- Try reloading the window: Ctrl+Shift+P → "Reload Window"

### Linguistic Examples
- `ex` → Interlinear glossed example with formatGloss
- `mex` → Multipart interlinear example (a, b)

### Semantic Markup (Keyboard Shortcuts)
- **Ctrl+Alt+Shift+G** → Wrap selection in [text]{.gl} (gloss abbreviation, smallcaps)
- **Ctrl+Alt+Shift+O** → Wrap selection in [text]{.ob} (object language, italics)
- **Ctrl+Alt+Shift+R** → Wrap selection in [text]{.rc} (reconstructed form, *italics)

**How to use:** Select text, then press the keyboard shortcut. Works in markdown files only.

### Tables & Figures
- `tbl` → Table with caption and ID
- `fig` → Figure with caption and ID
- `subfigs` → Subfigures in pandoc div wrapper (blank lines between each)
- `subtables` → Subtables with subcaptions
- `abbrinline` → Inline abbreviations list (block version)
- `abbrspan` → Inline abbreviations (for footnotes)

### Cross-References & Citations

**Pandoc Citer extension** provides autocomplete for:
- Citations: Type `@` to see bibliography entries
- Section references: Type `@sec:` to see available sections
- Figure references: Type `@fig:` to see available figures
- Table references: Type `@tbl:` to see available tables

**Snippet for example references** (not handled by Pandoc Citer):
- `refex` → [@ex:id]

### Sections
- `sec` → Section heading with ID

## Troubleshooting

**Snippets not appearing?**
- **First, reload VS Code window:** Ctrl+Shift+P → "Reload Window"
- Make sure you're editing a `.md` file
- Start typing the full prefix (e.g., `ex` not just `e`)
- Press Ctrl+Space to manually trigger suggestions
- Press **Tab** (not Enter) to expand the snippet

**Preview not showing linguistic examples?**
- Install Markdown Preview Enhanced extension (VS Code will prompt you)
- Check that pandoc is in your PATH: `which pandoc`
- Verify pandoc-crossref is installed: `which pandoc-crossref`

**Build task fails?**
- Check Terminal output for error messages
- Ensure LuaLaTeX is installed: `which lualatex`
- Try the command manually in Terminal to see detailed errors

**Fonts not rendering properly in PDF?**

The template defaults to **Noto Serif**, which has excellent Unicode and IPA support. This is set in `pandoc/crossref-en-US.yaml`.

If you see "Missing character" warnings in the build output, it means Noto Serif isn't installed on your system.

**Solution:** Install at least one linguistics-friendly font:
1. **Noto Serif** - [Download](https://fonts.google.com/noto/specimen/Noto+Serif) (recommended)
2. **Linux Libertine** - [Download](https://libertine-fonts.org/)
3. **Charis SIL** - [Download](https://software.sil.org/charis/)

**To override the default font** in your document:
```yaml
---
mainfont: "Linux Libertine"
---
```

**Why set it explicitly?** The template's `\IfFontExistsTF` fallback mechanism in LaTeX isn't reliable across systems. Setting `mainfont` in the crossref YAML provides a working default, and you can override it in any document's metadata.
