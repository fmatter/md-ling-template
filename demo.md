---
title: "Demonstration of Linguistic Markdown Template Features"
author: "Template Demo"
date: "2026-04-10"
bibliography: demo.bib

# Glossing abbreviations auto-discovery and linking
glossing-abbreviations:
  APPL: applicative
  INV: inverse voice
  IND: indicative
  3: third person
  3ACT: third person actor
  DEF: definite
  NOM: nominative
  3SG: third person singular

glossing-list:
  position: after  # 'before' (after intro) or 'after' (before references) or null (no list)
  title: "List of Glossing Abbreviations"
  warn-undefined: true  # warn about used but undefined abbreviations
---

# Introduction {#sec:intro}

This document demonstrates all features provided by the linguistic Markdown template, including interlinear glossing, cross-references, citations, and semantic markup for object language data.

As shown in [@sec:examples], the template supports professional typesetting of linguistic examples using the pandoc-ling filter [@cysouw2023]. For theoretical background, see [@sec:theory].

## Object Language Markup {#sec:markup}

The template provides three semantic markup classes for linguistic data:

1. **Gloss abbreviations**: The word has [nom]{.gl} case and [3sg]{.gl} agreement.
2. **Object language**: The German word [Haus]{.ob} means 'house'.
3. **Reconstructed forms**: Proto-Indo-European [bʰer-]{.rc} became Latin [ferre]{.ob}.

You can also use traditional Markdown formatting: _Haus_, but semantic markup is more explicit about intent.

# Linguistic Examples {#sec:examples}

## Simple Numbered Examples

Basic examples are numbered automatically:

::: ex
The cat sat on the mat.
:::

::: ex
*The cat sitted on the mat.
:::

## Interlinear Glossing {#sec:glossing}

The template uses pandoc-ling for professional interlinear glosses:

::: {.ex formatGloss=true}
| Mapudungun (Isolate)
| amuy chi weñi
| go.IND.3 DEF man
| 'The man went.'
:::

Example with inverse marking:

::: {.ex formatGloss=true}
| Mapudungun (Isolate)
| küpatueyew chi ḻuan
| come-APPL-INV-IND-3-3ACT DEF guanaco
| 'The guanaco came to him.'
:::

As discussed by @augusta1903, Mapudungun has a rich system of verbal morphology.

## Sub-examples

Examples can have multiple parts:

::: ex
a. The dog barked.
b. The cat meowed.
c. The bird sang.
:::

## Grammaticality Judgments

::: ex
^* Who do you think that will come?
:::

::: ex
^? This sentence is marginally acceptable.
:::

::: ex
Who do you think will come?
:::

# Theoretical Background {#sec:theory}

Following @comrie1989, we adopt a framework based on semantic roles. The cross-linguistic work by @bickel2005 demonstrates the diversity of argument marking strategies.

According to @dubois1987 [p. 805], discourse factors play a crucial role in determining argument structure patterns:

> One does not lightly embark on the proliferation of nouns in actual discourse.

## Cross-References

Cross-references work for sections, examples, figures, and tables:

- See [@sec:intro] for the introduction
- See [@sec:glossing] for interlinear examples  
- See [@tbl:inventory] for the phoneme inventory
- See [@fig:tree] for the syntactic structure
- See [@sec:subfigures] for subfigures and [@fig:comparison] for an example
- Reference individual subfigures: [@fig:direct] vs [@fig:inverse]
- See [@sec:subtables] for subtables and [@tbl:consonants] for an example
- Reference individual subtables: [@tbl:consonants] and [@tbl:fricatives]

# Data and Analysis {#sec:data}

## Tables

Tables can be created with Pandoc's table syntax:

| Phoneme | IPA | Example |
|---------|-----|---------|
| /p/     | p   | [pun]{.ob} 'night' |
| /t/     | t   | [tun]{.ob} 'many' |
| /k/     | k   | [kuy]{.ob} 'sand' |

: Consonant inventory of Mapudungun {#tbl:inventory}

For complex tables with special formatting, use images instead (see [@fig:tree]).

## Figures

![Hypothetical syntactic tree structure (placeholder)](figures/tree.png){#fig:tree width=80%}

Note: For this demo, create a `figures/` directory and add images as needed.

## Subfigures {#sec:subfigures}

Subfigures allow you to group related images with individual subcaptions and a main caption. Reference the main figure with [@fig:comparison] or individual subfigures like [@fig:direct] or [@fig:inverse].

![Direct construction tree](figures/tree.png){#fig:direct width=45%}
![Inverse construction tree](figures/tree.png){#fig:inverse width=45%}

: Comparison of direct and inverse voice constructions {#fig:comparison}

You can also use letter labels that appear automatically (a), (b), etc.

## Subtables {#sec:subtables}

Subtables group related tables together. In PDF/LaTeX, they render as a single grouped table with subcaptions. In HTML, they're visually grouped but numbered separately. Reference individual tables: [@tbl:consonants] and [@tbl:fricatives].

::: {#tbl:phonemes}
**Mapudungun obstruent inventory**

Table: Consonants {#tbl:consonants}

| Stop | Place |
|------|-------|
| p    | Bilabial |
| t    | Alveolar |
| k    | Velar |

Table: Fricatives {#tbl:fricatives}

| Fricative | Place |
|-----------|-------|
| f         | Labiodental |
| s         | Alveolar |
:::

# Multiple Citation Styles

- Single citation: @comrie1989
- Parenthetical: [@comrie1989]
- Multiple sources: [@comrie1989; @bickel2005; @dubois1987]
- With page numbers: [@dubois1987, p. 805]
- With prefix: [see @comrie1989, chapter 3]

# Conclusion {#sec:conclusion}

This template provides comprehensive support for linguistic writing, combining:

1. Professional interlinear glossing via pandoc-ling
2. Cross-references via pandoc-crossref
3. Bibliography management via citeproc
4. Semantic markup for object language data
5. Multi-format output (PDF, HTML, DOCX)

For German documents, use `lang: de-DE` in the YAML frontmatter and include `crossrefYaml: pandoc/crossref-de-DE.yaml` for localized labels.

# References {-}

<!-- Bibliography will be automatically generated here -->
