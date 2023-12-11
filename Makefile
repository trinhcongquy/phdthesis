#SOURCES := UUThesisTemplate.cls $(wildcard *.tex) $(wildcard img/*.tex) $(wildcard experiments/*.tex) $(wildcard experiments/*.txt)
SOURCES := $(wildcard settings/*.tex) settings/UUThesisTemplate.cls thesis.tex \
	   $(wildcard misc/*.tex) \
	   $(wildcard chapters/verification/*.tex) \
	   $(wildcard chapters/parameterized-systems/*.tex) \
	   $(wildcard chapters/monotonic-abstraction/*.tex) \
	   $(wildcard chapters/view-abstraction/*.tex) \
           $(wildcard chapters/shape-analysis/*.tex) \
	   $(wildcard img/*.tex) \
           $(wildcard experiments/*.tex) $(wildcard experiments/code/*.txt)
#	   misc/references.bib \

ERROR ?= no 
ifeq ($(ERROR),yes)
FLAGS?=-interaction=errorstopmode -file-line-error -halt-on-error
REDIRECT?=
else
FLAGS?=-interaction=batchmode
REDIRECT?= > /dev/null
endif

export TEXMFVAR = settings
LATEX := pdflatex --shell-escape
BIBTEX := bibtex -terse
MAKEINDEX := makeindex -q
CURRDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
BUILD := $(CURRDIR)_build

.SUFFIXES: .pdf .tex .txt .bb .map .enc .ttf .vf .tfm
.PHONY: all web img experiments fonts force

## ==== Thesis ==================================================
all: $(BUILD)/thesis.pdf

e:
	@make ERROR=yes

ps:
	@latex -interaction=errorstopmode -file-line-error -halt-on-error -output-directory=$(BUILD) thesis.tex

$(BUILD)/thesis.pdf: thesis.tex settings/builddir.tex $(SOURCES) 
	@echo Compiling thesis.tex
	@$(LATEX) $(FLAGS) -output-directory=$(BUILD) $< $(REDIRECT)

force:
	@echo "Compiling thesis.tex [forcing]"
	@$(LATEX) $(FLAGS) -output-directory=$(BUILD) thesis.tex $(REDIRECT)

final: thesis.tex settings/builddir.tex $(SOURCES) fonts bib index
	@echo "Second compilation"
	@$(LATEX) $(FLAGS) -output-directory=$(BUILD) $< $(REDIRECT)
	@echo "Final compilation"
	@$(LATEX) $(FLAGS) -output-directory=$(BUILD) $< $(REDIRECT)

## ==== Bibtex ==================================================
# Must use the TEXMFOUTPUT variable or change the openout_any=a in the texmf.cnf settings file
$(BUILD)/thesis.bbl: misc/references.bib $(BUILD)/thesis.aux
	@echo "Compiling the bibliography"
	@export TEXMFOUTPUT=$(BUILD); $(BIBTEX) $(BUILD)/thesis || true
$(BUILD)/thesis.aux: $(BUILD)/thesis.pdf
bib: $(BUILD)/thesis.bbl

## ==== makeindex ==================================================
$(BUILD)/thesis.ind: $(BUILD)/thesis.idx
	@echo "Creating the index"
	@export TEXMFOUTPUT=$(BUILD); $(MAKEINDEX) $(BUILD)/thesis.idx
$(BUILD)/thesis.idx: $(BUILD)/thesis.pdf
index: $(BUILD)/thesis.ind


settings/builddir.tex:
	@mkdir $(BUILD)
	@echo "\\\newcommand\\\builddir{\detokenize{$(BUILD)}}" > $@
#	@for c in {parameterized-systems,verification,monotonic-abstraction,view-abstraction,shape-analysis}; do mkdir -p $(BUILD)/chapters/$${c}; done

## ==== Test ==================================================
test: test.tex settings/builddir.tex
	pdflatex -shell-escape -output-directory=$(BUILD) $@

cleantest:
	@rm -f $(BUILD)/test.*

## ==== Pics & Experiments ==================================================
PICS1 := symbolic-representations approximations
PICS2 := topologies transition \
        ticks-iteration ticks-escape ticks-terminal
PICS3 := subword upward-closure monotonicity \
        universal-not-monotonic abstract-monotonic \
        pre-image sbr tree-transition tree-abstract-transition \
        pn-example pn-entailement pn-bad
PICS4 := view-example-abstraction small-preconditions \
        contexts-projection contexts-projection-view \
        na-projection na-ticks-iteration na-ticks-escape na-ticks-terminal \
	cut-off small-model-property view-method
PICS5 := shape-heap shape-observers shape-analysis data-independence linearizability \
	shape-merging shape-abstraction shape-interference

EXPERIMENTS := szymanski-diagram treiber/code

PICS := $(PICS1) $(PICS2) $(PICS3) $(PICS4) $(PICS5)

# Not used
#       pn_read_write         

pics: img experiments 

img: $(PICS:%=$(BUILD)/img/%.pdf)
img1: $(PICS1:%=$(BUILD)/img/%.pdf)
img2: $(PICS2:%=$(BUILD)/img/%.pdf)
img3: $(PICS3:%=$(BUILD)/img/%.pdf)
img4: $(PICS4:%=$(BUILD)/img/%.pdf)
img5: $(PICS5:%=$(BUILD)/img/%.pdf)
experiments: $(EXPERIMENTS:%=$(BUILD)/experiments/%.pdf)

cleanpics: 
	@rm -f $(PICS:%=$(BUILD)/img/%.pdf) $(EXPERIMENTS:%=$(BUILD)/experiments/%.pdf)

$(BUILD)/%.pdf: %.tex settings/builddir.tex settings/styles.tex
	@mkdir -p $(@D)
	@echo "Compiling $*"
	@export TEXMFOUTPUT=$(BUILD); $(LATEX) -output-directory=$(BUILD) $(FLAGS) --jobname $(BUILD)/$* thesis.tex $(REDIRECT)
#	@rm -f $(@:.pdf=.log) $(@:.pdf=.aux)

# =============================================================================
# Web interface
# =============================================================================
#BIBHVA=bibhva
web: thesis.html

thesis.html: $(SOURCES)
	@mkdir -p $(BUILD)/web
	hevea thesis.tex

cleanweb: 
	rm -rf $(BUILD)/web

# =============================================================================
# Fonts
# =============================================================================
fonts:
	@echo "Preparing the fonts"
	@make -s -C settings/fonts

# =============================================================================
# Cleaning
# =============================================================================
cleantilde:
	@find . -type f -iname '*~' -exec  rm {} \;

clean: cleantilde
	@rm -f $(BUILD)/thesis.*

cleanfonts:
	@make -s -C settings/fonts clean

cleanall: cleantilde cleanfonts
	@rm -rf $(BUILD)
	@rm -f settings/builddir.tex

