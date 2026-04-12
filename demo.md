---
title: "Linguistic Markdown Template: Feature Demonstration"
author: "Template Demo"
date: "2026-04-10"
bibliography: [demo.bib]
mainfont: Linux Libertine

glossing-abbreviations:
  APPL: applicative
  INV: inverse voice
  IND: indicative
  3: third person
  3ACT: third person actor
  DEF: definite
  NOM: nominative
  3SG: third person singular

abbreviations:
  e.g.: for example
  i.e.: that is
  cf.: compare

glossing-list:
  position: after
  title: "List of Glossing Abbreviations"
  warn-undefined: true
---




# Introduction {#sec:intro}

This document demonstrates the template's capabilities for linguistic writing: interlinear glossing, cross-references, citations, and semantic markup.^[Glossing abbreviations used: [...]{.glossing-abbreviations-inline}]


## Semantic Markup {#sec:markup}

**Gloss abbreviations (`.gl`):** The word has [nom]{.gl} case and [3sg]{.gl} agreement.

**Object language (`.ob`):** German [Haus]{.ob} means 'house'.

**Reconstructed forms (`.rc`):** PIE [bʰer-]{.rc} became Latin [ferre]{.ob}.

**Inline abbreviations list:**

::: glossing-abbreviations-inline
:::

# Linguistic Examples {#sec:examples}

## Numbered Examples

::: ex
The cat sat on the mat.
:::

::: ex
*The cat sitted on the mat.
:::



## Interlinear Glossing {#sec:glossing}

::: {.ex formatGloss=true}
| Mapudungun (Isolate)
| amuy chi weñi
| go.IND.3 DEF man
| 'The man went.'
:::

::: {.ex formatGloss=true}
| Mapudungun (Isolate)
| küpatueyew chi ḻuan
| come-APPL-INV-IND-3-3ACT DEF guanaco
| 'The guanaco came to him.'
:::

## Sub-examples

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

# Cross-References {#sec:xref}

Section references: [@sec:intro], [@sec:examples], [@sec:glossing]

Table references: [@tbl:inventory], [@tbl:consonants], [@tbl:fricatives]

Figure references: [@fig:tree], [@fig:direct], [@fig:inverse]

# Citations

In-text: @comrie1989 proposes a typological framework.

Parenthetical: Previous work [@bickel2005; @dubois1987] demonstrates variation.

With page: @dubois1987 [p. 805] notes discourse constraints.

With prefix: [see @augusta1903, for Mapudungun]

# Data {#sec:data}

## Tables

| Phoneme | IPA | Example |
|---------|-----|---------|
| /p/     | p   | [pun]{.ob} 'night' |
| /t/     | t   | [tun]{.ob} 'many' |
| /k/     | k   | [kuy]{.ob} 'sand' |

: Consonant inventory {#tbl:inventory}

## Subtables {#sec:subtables}

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

## Tables Without Headers {#sec:tables-noheader}

Test tables with empty header rows (these get stretched to full width):

|        |                                          |
|--------|------------------------------------------|
| [ps]{.gl}  | privileged syntactic argument (primary argument) of the preceding clause |
| [act]{.gl} | occurs in previous clause, but not as the PSA, including mentions as a possessor |
| [old]{.gl} | does not occur in the previous clause, but earlier in the text |
| [new]{.gl} | first occurrence in the text |

: Information status categories {#tbl:infocategories}


Another test:



Table: Animacy categories {#tbl:animcategories}

|                         |                                                |
| ----------------------- | ---------------------------------------------- |
| [hum]{.smallcaps}       | human or human-like                            |
| [anim]{.smallcaps}      | animate, but not human-like                    |
| [inan.agt]{.smallcaps}  | inanimate, but with some agent-like properties |
| [inan.nagt]{.smallcaps} | inanimate with no agency                       |
| [abs]{.smallcaps}       | abstract, immaterial concepts                  |


Another test without header (short first column, long second column):

|            |                                                                  |
|------------|------------------------------------------------------------------|
| [new]{.gl} | 430/452 (95.13%)                                                |
| [given]{.gl} | 1480/3459 (42.79%)                                            |

: Lexicality test table {#tbl:lextest}

## Figures

![Hypothetical syntactic tree](figures/tree.png){#fig:tree width=80%}

## Subfigures {#sec:subfigures}

<div id="fig:comparison">
![Direct construction](figures/tree.png){#fig:direct width=45%}

![Inverse construction](figures/tree.png){#fig:inverse width=45%}

Voice construction comparison
</div>

### Four-subfigure grid (testing larger grid)

<div id="fig:IPQ">
![Newness and IPQ based on all new referents (r^2^ = 0.76, SE = 0.05)](figures/2a.png){#fig:IPQallnew width=45%}

![Lexicality and IPQ based on all new referents (r^2^ = 0.05, SE = 0.12)](figures/2b.png){#fig:IPQalllex width=45%}

![Newness and IPQ based on new human referents (r^2^ = 0.84, SE = 0.04)](figures/2c.png){#fig:IPQhumnew width=45%}

![Lexicality and IPQ based on new human referents (r^2^ = 0.08, SE = 0.12)](figures/2d.png){#fig:IPQhumlex width=45%}

Newness and lexicality of S in 25 texts depending on IPQ
</div>

