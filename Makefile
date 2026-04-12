# Makefile for building documents with the md-ling-template
# This is an example - customize for your project

# Single file builds (using demo.md as example)
pdf:
	pandoc demo.md --defaults=pandoc/defaults.yaml --citeproc --template=pandoc/templates/default.latex --pdf-engine=lualatex -o demo.pdf

html:
	pandoc demo.md --defaults=pandoc/defaults.yaml --citeproc -o demo.html

tex:
	pandoc demo.md --defaults=pandoc/defaults.yaml --citeproc --template=pandoc/templates/default.latex -o demo.tex

# Multi-file project example (uncomment and customize for your project)
# CHAPTERS := 01-intro.md 02-method.md 03-results.md 04-conclusion.md
# 
# article.pdf: $(CHAPTERS) metadata.yaml sources.bib
# 	pandoc $(CHAPTERS) \
# 	  --metadata-file=metadata.yaml \
# 	  --defaults=pandoc/defaults.yaml \
# 	  --citeproc \
# 	  --template=pandoc/templates/default.latex \
# 	  --pdf-engine=lualatex \
# 	  -o article.pdf

.PHONY: clean
clean:
	rm -f demo.pdf demo.html demo.tex