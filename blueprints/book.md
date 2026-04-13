---
title: "Book Title"
subtitle: "A Subtitle if Needed"
author: "Your Name"
date: "2026"
bibliography: [sources.bib]

# Book-specific settings
documentclass: book
# Alternative: scrbook (KOMA-Script), memoir

# Table of contents
toc: true
toc-depth: 2

# Numbering
numbersections: true
secnumdepth: 2

# Glossing abbreviations (define all abbreviations used throughout the book)
glossing-abbreviations:
  NOM: nominative
  ACC: accusative
  GEN: genitive
  DAT: dative
  SG: singular
  PL: plural
  1: first person
  2: second person
  3: third person
  MASC: masculine
  FEM: feminine
  NEUT: neuter

# Glossing list settings
glossing-list:
  position: before  # Place abbreviations before references
  title: "List of Glossing Abbreviations"
  warn-undefined: true

# Common abbreviations
abbreviations:
  e.g.: for example
  i.e.: that is
  cf.: compare
  viz.: namely
---

# Preface {-}

The preface is unnumbered (note the `{-}` after the heading).

# Introduction {#ch:intro}

Your introduction here. For books, use chapter-level organization.

## Research Questions {#sec:questions}

Subsections within chapters.

## Structure of the Book {#sec:structure}

Brief overview of the book's organization.

# Theoretical Background {#ch:theory}

Second chapter content.

## Previous Research {#sec:previous}

Review of literature.

## Theoretical Framework {#sec:framework}

Your theoretical approach.

# Methodology {#ch:method}

Describe your methods.

## Data Collection {#sec:data}

How you collected your data.

## Analytical Approach {#sec:approach}

How you analyzed the data.

# Analysis {#ch:analysis}

Main analysis chapter.

## Case Study 1 {#sec:case1}

First case study.

### Interlinear Examples {#subsec:examples1}

Use three levels of headings for detailed organization:

(@ex1) An example sentence.
    ```
    (@) Example sentence here
        [Example]{.ob} [sentence]{.ob} [here]{.ob}
        example sentence here
        'An example sentence.'
    ```

## Case Study 2 {#sec:case2}

Second case study.

# Discussion {#ch:discussion}

Interpret your findings.

## Theoretical Implications {#sec:implications}

What do your findings mean for the theory?

## Limitations {#sec:limitations}

Acknowledge limitations of your study.

# Conclusion {#ch:conclusion}

Summarize your findings and contributions.

# References {-}

<!-- References will be automatically inserted here by pandoc-citeproc -->

# Appendices {-}

# Appendix A: Additional Data {#app:data -}

Supplementary materials.

# Appendix B: Technical Details {#app:technical -}

Additional technical information.
