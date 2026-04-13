---
title: "Article Title"
author: "Your Name"
date: "2026"
bibliography: [sources.bib]

# Glossing abbreviations (define all abbreviations used in your examples)
glossing-abbreviations:
  NOM: nominative
  ACC: accusative
  GEN: genitive
  SG: singular
  PL: plural
  1: first person
  2: second person
  3: third person

# Glossing list settings
glossing-list:
  position: after  # or 'before' to place before references
  title: "List of Glossing Abbreviations"
  warn-undefined: true  # warn about undefined abbreviations

# Common abbreviations
abbreviations:
  e.g.: for example
  i.e.: that is
  cf.: compare
---

# Introduction {#sec:intro}

Your introduction here. You can cite sources [@authorYEAR] and cross-reference sections like @sec:examples.

## Background {#sec:background}

Use subsections to organize your content.

# Examples {#sec:examples}

Demonstrate linguistic examples using pandoc-ling syntax:

(@good) Here is a basic example.
    ```
    (@) This  is    an   example
        [Dis]{.ob} [is]{.ob}   [ən]{.ob}  [ɪɡˈzæmpəl]{.ob}
        this be.3SG ART example
        'This is an example.'
    ```

Cross-reference your examples: As shown in (@good), examples can be referenced.

## Interlinear Glossing {#sec:glossing}

Use `.gl` for gloss abbreviations, `.ob` for object language, and `.rc` for reconstructed forms:

- The word has [nom]{.gl} case
- German [Haus]{.ob} means 'house'
- PIE [bʰer-]{.rc} 'to carry'

# Analysis {#sec:analysis}

Your analysis here.

# Conclusion {#sec:conclusion}

Your conclusion here.

# References {-}

<!-- References will be automatically inserted here by pandoc-citeproc -->
