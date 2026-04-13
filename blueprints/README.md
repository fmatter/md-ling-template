# Template Blueprints

This folder contains starter templates for different types of linguistic documents.

## Available Templates

### [article.md](article.md)
Starter template for journal articles, conference papers, and shorter academic works.

**Features:**
- Standard article structure (Introduction, Analysis, Conclusion)
- Configured for single-column PDF output
- Glossing abbreviations with automated list generation
- Cross-references and citations

**To use:**
```bash
# Copy to your project
cp blueprints/article.md my-article.md

# Edit the content
# Build with: Ctrl+Shift+B (single-file mode)

# OR for multi-file projects:
# 1. Copy project.yaml.template to project.yaml
# 2. List your files: input-files: [my-article.md, appendix.md]
# 3. Use "Build * (project)" tasks in VS Code
```

### [book.md](book.md)
Starter template for books, theses, dissertations, and longer multi-chapter works.

**Features:**
- Book-class document with chapters
- Three-level heading structure (chapter, section, subsection)
- Table of contents configuration
- Preface and appendices
- Chapter-level organization with `\chapter`

**To use:**
```bash
# Copy to your project
cp blueprints/book.md my-thesis.md

# Configure multi-file build:
# 1. Copy project.yaml.template to project.yaml  
# 2. List chapters: input-files: [ch1-intro.md, ch2-theory.md, ...]
# 3. Use "Build * (project)" tasks

# Or for multi-file projects:
mkdir my-thesis
cp blueprints/book.md my-thesis/
# Split into multiple files: ch1-intro.md, ch2-theory.md, etc.
```

### [slides.md](slides.md)
Starter template for presentations (conference talks, lectures, etc.)

**Features:**
- Configured for Beamer (PDF), Slidy (HTML), and PPTX output
- Slide-level and theme settings in YAML frontmatter
- Two-level structure (sections and individual slides)
- Examples of incremental lists, two-column layouts

**To use:**
```bash
# Edit blueprints/slides.md directly, then:
make slides-pdf    # Professional PDF slides (Beamer)
make slides-html   # Web slides (Slidy)
make slides-pptx   # PowerPoint slides
make slides-all    # Build all formats
```

## Customization

All templates include:
- **YAML frontmatter** - Title, author, bibliography, fonts
- **Glossing abbreviations** - Define abbreviations for your examples
- **Bibliography** - References to `sources.bib` (create in project root)
- **Cross-references** - Section and example numbering

**Common customizations:**
```yaml
---
# Change font (install on your system first)
mainfont: "Noto Serif"  # or "Linux Libertine", "Charis SIL"

# Add subtitle
subtitle: "A subtitle here"

# Change language
lang: de-DE  # German (also updates cross-reference labels)

# Customize glossing list
glossing-list:
  position: before  # or 'after' (before/after references)
  title: "Abbreviations"
---
```

## File Organization

**Recommended structure for your project:**

```
my-project/
├── content.md           # Your main document (copied from blueprints/)
├──project/
├── project.yaml         # Central configuration (gitignored)
├── ch1-intro.md
├── ch2-theory.md
├── ch3-analysis.md
├── ch4-conclusion.md
├── sources.bib
└── figures/
```

Configure in `project.yaml`:
```yaml
input-files:
  - ch1-intro.md
  - ch2-theory.md
  - ch3-analysis.md
  - ch4-conclusion.md

output-file: output.pdf
```

Then build with:
```bash
# VS Code: "Build * (project)" tasks
# Command line: just pdf  (or just html, just docx)
# Or directly: python3 pandoc/build.py --project
├── ch2-theory.md
├── ch3-analysis.md
├── ch4-conclusion.md
├── sources.bib
└── figures/
```

Then build with:
```bash
pandoc *.md --metadata-file=metadata.yaml --defaults=pandoc/defaults.yaml -o book.pdf
```

## See Also

- [../README.md](../README.md) - Main template documentation
- [../SLIDES.md](../SLIDES.md) - Complete slides documentation
- [../demo.md](../demo.md) - Comprehensive feature showcase
