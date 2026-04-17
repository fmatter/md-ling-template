---
title: "Linguistic Markdown Template"
subtitle: "Feature Demonstration"
author:
  - Florian Matter
  - Another Author
date: "2026-04-10"
bibliography: [blueprints/sources.bib]
mainfont: Linux Libertine
abstract: |
  This document serves as a demonstration of the capabilities of a Markdown template designed for linguistic writing. It includes examples of interlinear glossing, cross-references, citations, and semantic markup.
keywords: [markdown, linguistics, template, demonstration]

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
It also allows subfigures -- @fig:subfigures, @fig:tree2.


::: {#fig:subfigures}
![A tree](figures/pekodiantree.svg){#fig:tree1 width=40%}

![The same tree again](figures/pekodiantree.svg){#fig:tree2 width=40%}

The same tree twice.

:::

# Bibliography
- @Croft2003
- [@Bickel_Nichols2013]
- @Lehmann1982[321]
- [@Croft2003, 12-32]
- Croft's -@Croft2003 idea
- Croft's -@Croft2003[23-34] idea.

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

# More on tables {#sec:moretables}
The template supports subtables (@tbl:arapers) and tables without headers (@tbl:animcategories).


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


Table: Animacy categories {#tbl:animcategories}

|                         |                                                |
| ----------------------- | ---------------------------------------------- |
| [hum]{.smallcaps}       | human or human-like                            |
| [anim]{.smallcaps}      | animate, but not human-like                    |
| [inan.agt]{.smallcaps}  | inanimate, but with some agent-like properties |
| [inan.nagt]{.smallcaps} | inanimate with no agency                       |
| [abs]{.smallcaps}       | abstract, immaterial concepts                  |
