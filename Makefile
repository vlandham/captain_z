
BOOK_FILE_NAME = captain_z
TEMP_DIR = out

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

PDF_BUILDER = pandoc
PDF_BUILDER_FLAGS = \
	--latex-engine xelatex \
	--template ../_layouts/pdf-template.tex \
	--listings

EPUB_BUILDER = pandoc
EPUB_BUILDER_FLAGS = \
	--epub-cover-image

MOBI_BUILDER = kindlegen


combine:
	mkdir -p $(TEMP_DIR)
	cat _posts/*.md | tools/remove_header.rb > $(TEMP_DIR)/$(BOOK_FILE_NAME).md
	cp -r img/ ${TEMP_DIR}/img

tex: combine
	cd $(TEMP_DIR) && $(PDF_BUILDER) $(PDF_BUILDER_FLAGS) $(BOOK_FILE_NAME).md -o $(BOOK_FILE_NAME).tex

pdf: combine
	cd $(TEMP_DIR) && $(PDF_BUILDER) $(PDF_BUILDER_FLAGS) $(BOOK_FILE_NAME).md -o $(BOOK_FILE_NAME).pdf

epub: tex
	# cd $(TEMP_DIR) && $(EPUB_BUILDER) $(EPUB_BUILDER_FLAGS) img/title.png $(BOOK_FILE_NAME).md -o $(BOOK_FILE_NAME).epub
	cd $(TEMP_DIR) && $(EPUB_BUILDER) $(BOOK_FILE_NAME).tex -o $(BOOK_FILE_NAME).epub

mobi: epub
	cd $(TEMP_DIR) && $(MOBI_BUILDER) $(BOOK_FILE_NAME).epub

clean:
	rm -f $(BOOK_FILE_NAME).pdf
	rm -rf $(TEMP_DIR)
