.PHONY : ebook plain slide handout clean help

## make all : regenerate all results.
all:slide ebook plain  handout

## make slide: the silde version
slide: build/slide.pdf
	rm -f slide.tex

## make ebook: the version for ebook
ebook: build/ebook.pdf
	rm -f ebook.tex

## make plain : the plain version
plain: build/plain.pdf
	rm -f plain.tex

handout: build/handout.pdf
	rm -f handout.tex

ebook.tex: build
	echo "\documentclass[ebook]{myslide}" > ebook.tex
	awk 'FNR>4' main.tex >> ebook.tex

plain.tex: build
	echo "\documentclass[plain]{myslide}" > plain.tex
	awk 'FNR>4' main.tex >> plain.tex

slide.tex: build
	echo "\documentclass[slide]{myslide}" > slide.tex
	awk 'FNR>4' main.tex >> slide.tex

handout.tex: build
	echo "\documentclass[slide,handout]{myslide}" > handout.tex
	awk 'FNR>4' main.tex >> handout.tex

## make *.pdf : generate the pdf files
build/%.pdf: %.tex
	xelatex -output-directory="./build" $<
	biber ./build/$(basename $<)
	xelatex -output-directory="./build" $<
	xelatex -output-directory="./build" $<

## make clean: clean the temp files
clean:
	git clean -fXd --exclude='*.pdf'
	# git ls-files --others | xargs gio trash
	@echo Removing ebook.tex
	@rm -f ebook.tex
	@echo Removing book.tex
	@rm -f book.tex
	@echo Removing todo.tex
	@rm -f todo.tex

## make build: create directory build
build:
	mkdir build

## make help : show this message.
help :
	@grep -h -E '^##' ${MAKEFILE_LIST} | sed -e 's/## //g' \
		| column -t -s ':'
