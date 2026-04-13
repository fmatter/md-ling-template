# Makefile for building documents with the md-ling-template
# This is an example - customize for your project

# Single file builds (using demo.md as example)
pdf:
	pandoc demo.md --defaults=pandoc/defaults.yaml --template=pandoc/templates/default.latex -o demo.pdf

pdf-deu:
	pandoc demo.md --defaults=pandoc/defaults.yaml --metadata-file=pandoc/crossref-de-DE.yaml --template=pandoc/templates/default.latex -o demo-deu.pdf

html:
	pandoc demo.md --defaults=pandoc/defaults.yaml -o demo.html

tex:
	pandoc demo.md --defaults=pandoc/defaults.yaml --template=pandoc/templates/default.latex -o demo.tex

docx:
	pandoc demo.md --defaults=pandoc/defaults.yaml -o demo.docx
	cp demo.docx demo_postprocessed.docx
	python3 pandoc/filters/fix_docx.py demo_postprocessed.docx

docx-print:
	@if [ ! -f pandoc/reference.docx ]; then \
		echo "Error: pandoc/reference.docx not found."; \
		echo "Run: cd pandoc && ./generate_reference_docx.sh"; \
		exit 1; \
	fi
	pandoc demo.md --defaults=pandoc/defaults.yaml --reference-doc=pandoc/reference.docx -o demo-print.docx
	python3 pandoc/filters/fix_docx.py demo-print.docx

# Slide builds (using blueprints/slides.md)
# Note: slide-level and beamertheme are configured in slides.md metadata
slides-pdf:
	pandoc blueprints/slides.md --defaults=pandoc/defaults.yaml -t beamer --pdf-engine=lualatex -o slides.pdf

slides-html:
	pandoc blueprints/slides.md --defaults=pandoc/defaults.yaml -t slidy --embed-resources --standalone -o slides.html

slides-pptx:
	pandoc blueprints/slides.md --defaults=pandoc/defaults.yaml --reference-doc=pandoc/reference.pptx -o slides.pptx

slides-all: slides-pdf slides-html slides-pptx

# Multi-file project example (uncomment and customize for your project)
# CHAPTERS := 01-intro.md 02-method.md 03-results.md 04-conclusion.md
#
# article.pdf: $(CHAPTERS) metadata.yaml sources.bib
# 	pandoc $(CHAPTERS) \
# 	  --defaults=pandoc/defaults.yaml \
# 	  --metadata-file=metadata.yaml \
# 	  --template=pandoc/templates/default.latex \
# 	  -o article.pdf

.PHONY: check-gloss
check-gloss: html
	python3 check_gloss_markup.py demo.html demo.md

.PHONY: clean
clean:
	rm -f demo.pdf demo.html demo.tex demo.docx demo_postprocessed.docx demo-print.docx
	rm -f slides.pdf slides.html slides.pptx
