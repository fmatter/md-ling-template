---
title: "Linguistic Markdown Template: Feature Demonstration"
author: "Template Demo"
date: "2026-04-10"
bibliography: demo.bib

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
  position: after
  title: "List of Glossing Abbreviations"
  warn-undefined: true
---

# Introduction {#sec:intro}

This document demonstrates the template's capabilities for linguistic writing: interlinear glossing, cross-references, citations, and semantic markup.

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

## Figures

![Hypothetical syntactic tree](figures/tree.png){#fig:tree width=80%}

## Subfigures {#sec:subfigures}

![Direct construction](figures/tree.png){#fig:direct width=45%}
![Inverse construction](figures/tree.png){#fig:inverse width=45%}

: Voice construction comparison {#fig:comparison}

# References {-}
