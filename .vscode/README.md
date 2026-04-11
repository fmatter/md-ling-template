# VS Code Setup for Linguistic Writing

This directory contains VS Code configuration for the md-ling-template workflow.

## Quick Start

### Build your document
- **Ctrl+Shift+B** (Cmd+Shift+B on Mac) → Build PDF (default)
- **Ctrl+P** then type `task ` → See all available tasks

### Available Tasks
1. **Build PDF (current file)** - Generate PDF from your markdown (default build task)
2. **Build HTML (current file)** - Generate HTML output
3. **Build LaTeX (current file)** - Generate intermediate .tex file for debugging
4. **Run tests** - Run the pytest test suite
5. **Clean outputs** - Remove generated PDF/HTML/TeX files

### Preview
- **Ctrl+K V** (Cmd+K V on Mac) → Open markdown preview side-by-side
- Preview uses actual Pandoc with all filters, so linguistic examples render correctly!

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
- `subfigs` → Subfigures with subcaptions
- `subtables` → Subtables with subcaptions
- `abbrinline` → Inline abbreviations list

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
