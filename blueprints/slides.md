---
title: "Linguistic Presentations with Pandoc"
author: "Your Name"
date: "April 2026"
documentclass: beamer
mainfont: Noto Sans
bibliography: [blueprints/sources.bib]

# Slide-specific settings
slide-level: 2  # Level 2 headings (##) create individual slides
aspectratio: 169  # 16:9 ratio (also: 43, 1610, 149, 54)

# Beamer-specific settings (for PDF slides)
beamertheme: metropolis
beamercolortheme: default

# Slidy-specific settings (for HTML slides)
css: pandoc/slidy-style.css

# Glossing abbreviations
glossing-abbreviations:
  CISL: cislocative
  RE: repetitive
  REP: repetitive
  IND: indicative
  NONF: non-finite
  3: third person
---

<!--
SLIDE STRUCTURE GUIDE:

# Level 1 Headings → Section headers (title slides)
  Creates a section divider in Beamer, a full-screen title in reveal.js

## Level 2 Headings → Individual slides
  Each ## creates a NEW slide with that heading as the title

Content under ## appears ON THAT SLIDE.

Example:
  # Linguistic Examples        ← Section header slide
  ## Simple Examples           ← Slide 1: "Simple Examples"
  Content for simple examples
  ## Interlinear Glossing      ← Slide 2: "Interlinear Glossing"
  Content for interlinear examples

To allow Beamer slides to break across multiple frames (if content is too long):
  ## Long Slide {.allowframebreaks}
  lots of content...
-->

# Introduction

## What This Template Offers

- Professional typesetting for linguistic examples
- Interlinear glossing with `pandoc-ling`
- Citations and cross-references
- Multiple output formats: PDF (Beamer), HTML (reveal.js), PPTX

## Why Markdown for Slides?

::: incremental
- **write once, present anywhere**: Same source → PDF, HTML, PPTX
- **version control friendly**: Plain text, easy to diff
- **focus on content**: Separation of content and presentation
- **linguistic examples**: Full support for glossing and examples
:::

# Linguistic Examples

## Simple Examples

Basic numbered examples work seamlessly:

::: ex
This is a simple linguistic example.
:::

::: ex
*This is ungrammatical.
:::

## Interlinear Glossing

Standard interlinear examples:

::: {.ex formatGloss=true}
| German (Germanic)
| Der Mann gibt dem Kind das Buch
| DEF.M.NOM man give.3SG DEF.N.DAT child DEF.N.ACC book
| The man gives the book to the child.
:::

## Multi-part Examples

Examples can have sub-parts:

::: ex
a. The dog barked.
b. The cat meowed.
c. The bird sang.
:::

## Complex Glossing Example

Real-world example from Mapudungun:

::: {#ex:nonlex .ex formatGloss=true}
a.
| yepaturkey kiñe pichi müṉa def {#ex:agree}
| je-pa-tu-ʐke-i-Ø kiɲe pit͡ʃi mɨn̪a θef
| bring-CISL-RE-REP-IND-3 one small very rope
| 'He~Ø~ brought a small rope.' ([tesoro]{.smallcaps}:14)
b.
| inanelu kiñe pichi rüpü {#ex:zero}
| ina-ne-lu kiɲe pit͡ʃi ʐɨpɨ
| follow-have-NONF one small path
| 'While he~Ø~ was following a small path…' ([tesoro]{.smallcaps}:3)
:::

# Cross-References and Citations

## Cross-Referencing

You can refer to examples:

- [@ex:nonlex] shows complex morphology
- Sub-example [@ex:agree] demonstrates agreement
- [@ex:zero] illustrates zero marking

## Citations
- @Croft2003
- [@Bickel_Nichols2013]
- @Lehmann1982[321]
- [@Croft2003, 12-32]
- Croft's -@Croft2003 idea
- Croft's -@Croft2003[23-34] idea.

# Tables and Figures

## Simple Tables

| Phoneme | Example | Gloss |
|---------|---------|-------|
| /p/     | [pun]{.ob} | 'night' |
| /t/     | [tun]{.ob} | 'many' |
| /k/     | [kuy]{.ob} | 'sand' |

: Consonant inventory {#tbl:consonants}

## Figures

<!--
![Syntax tree](figures/tree.png){#fig:tree width=60%}

Cross-reference: See [@fig:tree] for the structure.
-->

Example of how to include figures:

```markdown
![Caption](path/to/image.png){#fig:id width=60%}
```

Cross-reference with `[@fig:id]`

# Semantic Markup

## Custom Markup for Linguistics

The template provides specialized markup:

- **Gloss abbreviations**: [nom]{.gl} case marking
- **Object language**: German [Haus]{.ob} means 'house'
- **Reconstructed forms**: PIE [*bʰer-]{.rc} → Latin [ferre]{.ob}

## Inline Abbreviations

List glossing abbreviations inline:

Abbreviations used: [*]{.glossing-abbreviations-inline}

# Output Formats

## PDF (Beamer)

**Pros:**
- Professional LaTeX typesetting
- Excellent font support (Unicode, IPA)
- Perfect for conferences and print

**Build:**
```bash
make slides-pdf
# or: pandoc slides.md -t beamer -o slides.pdf
```

## HTML (reveal.js)

**Pros:**
- Interactive, web-based
- Beautiful animations and transitions
- Works on any device with a browser

**Build:**
```bash
make slides-html
# or: pandoc slides.md -t revealjs -o slides.html
```

## PowerPoint (PPTX)

**Pros:**
- Editable in PowerPoint
- Familiar interface for collaborators
- Easy to add animations manually

**Build:**
```bash
make slides-pptx
# or: pandoc slides.md -o slides.pptx
```

# Tips and Tricks

## Speaker Notes {.notes}

Use `.notes` class for speaker notes (works in reveal.js and Beamer):

::: notes
These notes won't appear on the slide, only in speaker view.
Great for reminders and additional context.
:::

## Columns

:::::: {.columns}
::: {.column width="50%"}
**Left column**

- Point one
- Point two
:::

::: {.column width="50%"}
**Right column**

- Point three
- Point four
:::
::::::

## Incremental Lists

Use `::: incremental` for bullet points that appear one at a time:

::: incremental
- First point
- Second point
- Third point
:::

# Conclusion

## Summary

- ✓ Same markdown source → multiple formats
- ✓ Full support for linguistic examples
- ✓ Citations and cross-references
- ✓ Professional output for presentations

## Next Steps

1. Edit `slides.md` with your content
2. Build: `make slides-pdf` or `make slides-html`
3. Present!

**Questions?**
