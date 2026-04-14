---
title: "Linguistic Markdown Template"
subtitle: "Feature Demonstration"
author: "Florian Matter"
date: "2026-04-10"
bibliography: [demo.bib]
mainfont: Linux Libertine
abstract: |
  This document serves as a demonstration of the capabilities of a Markdown template designed for linguistic writing. It includes examples of interlinear glossing, cross-references, citations, and semantic markup.

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

## Basic markdown {#sec:basic}

_Basic_ **Markdown** ~capabilities~ ^are^ _**of course**_ ~~not~~ `supported`.


---

1. Lists
   a. Nested lists
   b. [hyperlinks](https://www.example.com)

- unordered lists
  - 'bulletpoints'
  - etc
    1. nested lists
    2. can be numbered again

---

> Blockquotes can be used for highlighting important information or quoting someone.

![Images have captions](figures/pekodiantree.svg){#fig:id width=30%}

## Extended markdown

Simple tables:^[See below for complex tables.]

| Header 1 | Header 2 |
| -------- | -------- |
| data     | data     |

: Table caption {#tbl:table-1}

Codeblocks:[^split-footnote]

```json
{
    "dc:description": "A reference to the meaning denoted by the form",
    "datatype": "string",
    "propertyUrl": "http://cldf.clld.org/v1.0/terms.rdf#parameterReference",
    "required": true,
    "name": "Parameter_ID"
},
{
    "dc:description": "The written expression of the form. If possible the transcription system used for the written form should be described in CLDF metadata (e.g. via adding a common property `dc:conformsTo` to the column description using concept URLs of the GOLD Ontology (such as [phonemicRep](http://linguistics-ontology.org/gold/2010/phonemicRep) or [phoneticRep](http://linguistics-ontology.org/gold/2010/phoneticRep)) as values).",
    "dc:extent": "singlevalued",
    "datatype": "string",
    "propertyUrl": "http://cldf.clld.org/v1.0/terms.rdf#form",
    "required": true,
    "name": "Form"
}
```

[^split-footnote]: This is an excerpt from a [CLDF]{.mark} metadata file.


vowel
  : not a consonant

word
  : depends on who you ask



- [ ] Task 1
- [x] Task 2

[Poems]{.smallcaps}:

| You want to have lines?
| Just make use of these line blocks!
| They will be useful.

# Crossreferences
You can manually refer to [any label in the same document](#sec:basic), could be [a figure](#fig:id) or [a table](#tbl:table-1).
With [pandoc-crossref](https://github.com/lierdakil/pandoc-crossref), you can also do things like @sec:basic or @fig:id or @tbl:table-1.

# Bibliography
@Croft2003

# Linguistic stuff

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
\*The cat sitted on the mat.
:::

## Interlinear Glossing {#sec:glossing}

::: {#ex:mapudungunS .ex formatGloss=true}
a.
| Mapudungun 1
| amuymi
| amu-imi
| go-IND.2SG
| 'You went' (Smeets 2007, 39)
b.
| Mapudungun 2
| feymew fütra amuy Antonio
| fejmew fɨt͡ʂa amu-i-Ø antonjo
| then far go-IND-3 Antonio
| 'Then, Antonio went far away.' ([antonio]{.smallcaps}: 61)
:::

## Sub-examples

::: ex
a. The dog barked.
b. The cat meowed.
c. The bird sang.
:::

## Grammaticality Judgments

::: ex
^\* Who do you think that will come?
:::

::: ex
^? This sentence is marginally acceptable.
:::

::: ex
Who do you think will come?
:::

# Subtables {#sec:subtables}

::: {#tbl:arapers}
**The Arara person marking system**

Table: Transitive {#tbl:arapers-trans}

| [A]{.gl}/[P]{.gl} | [1]{.gl}            | [2]{.gl}   | [1+2]{.gl}  | [3]{.gl}                                                  |
| ----------------- | ------------------- | ---------- | ----------- | --------------------------------------------------------- |
| [1]{.gl}          |                     | [ko-]{.ob} |             | [j-]{.ob}/[in(i)-]{.ob}                                   |
| [2]{.gl}          | [ugu-]{.ob}         |            |             | [m(i)-]{.ob}                                              |
| [1+2]{.gl}        |                     |            |             | [kut(i)-]{.ob}                                            |
| [3]{.gl}          | [j-]{.ob}/[ɨ-]{.ob} | [o-]{.ob}  | [ugu-]{.ob} | [i-]{.ob}/Ø/[t(ɨ)-]{.ob} **or** [n(i)-]{.ob}/[n(ɨ)-]{.ob} |

Table: Intransitive {#tbl:arapers-intrans}

|            | [S~A~]{.gl}         | [S~P~]{.gl}                               |
| ---------- | ------------------- | ----------------------------------------- |
| [1]{.gl}   | [w-]{.ob}/[k-]{.ob} | [j-]{.ob}[/ɨ-]{.ob}                       |
| [2]{.gl}   | [m-]{.ob}           | [o-]{.ob}                                 |
| [1+2]{.gl} | [kut-]{.ob}         | [ugu-]{.ob}                               |
| [3]{.gl}   | Ø **or** [n-]{.ob}  | Ø/[i-]{.ob}/[t-]{.ob} **or** [n(ɨ)-]{.ob} |

:::

# Data {#sec:data}

## Tables

| Phoneme | IPA | Example            |
| ------- | --- | ------------------ |
| /p/     | p   | [pun]{.ob} 'night' |
| /t/     | t   | [tun]{.ob} 'many'  |
| /k/     | k   | [kuy]{.ob} 'sand'  |

: Consonant inventory {#tbl:inventory}



## Tables Without Headers {#sec:tables-noheader}

Test tables with empty header rows (these get stretched to full width):

|                   |                                                                                  |
| ----------------- | -------------------------------------------------------------------------------- |
| [ps]{.smallcaps}  | privileged syntactic argument (primary argument) of the preceding clause         |
| [act]{.smallcaps} | occurs in previous clause, but not as the PSA, including mentions as a possessor |
| [old]{.smallcaps} | does not occur in the previous clause, but earlier in the text                   |
| [new]{.smallcaps} | first occurrence in the text                                                     |

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

|                     |                    |
| ------------------- | ------------------ |
| [new]{.smallcaps}   | 430/452 (95.13%)   |
| [given]{.smallcaps} | 1480/3459 (42.79%) |

: Lexicality test table {#tbl:lextest}

## Figures

![Hypothetical syntactic tree](figures/tree.png){#fig:tree width=80%}

> This is a blockquote. It can be used to highlight important information or to quote someone.

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
