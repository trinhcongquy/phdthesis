# =============================================================================
# Create the support files for the fonts
# =============================================================================

VERBOSE=--verbose
LOG=daz.log

# Do not delete the temporary files
.SECONDARY:

all: Chalkduster.fd Papyrus.fd Hyeenanhaukotus.fd map/pdftex/updmap/pdftex.map

%.fd:
	@echo "Generating the font definition for $*"
	@echo "\\ProvidesFile{$@}" > $@
	@echo "   [2015/04/30 Font definition file for LY1/$*]" >> $@
	@echo "" >> $@
	@echo "\\DeclareFontFamily{LY1}{$*}{}" >> $@
	@echo "" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {m}  {n}  {<-> LY1--$*}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {m}  {sc} {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {m}  {sl} {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {b}  {n}  {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {b}  {sc} {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {b}  {sl} {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {l}  {n}  {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {l}  {sc} {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {l}  {sl} {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {m}  {it} {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {bx} {n}  {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {bx} {sc} {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {bx} {sl} {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {b}  {it} {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {bx} {it} {<-> ssub * $*/m/n}{}" >> $@
	@echo "\\DeclareFontShape{LY1} {$*} {l}  {it} {<-> ssub * $*/m/n}{}" >> $@
	@echo "" >> $@
	@echo "\\endinput" >> $@

clean:
	rm -f *.fd *.log
	@rm -rf {enc,map,tfm,truetype,vf}

########################################
## USING LFCDtools
########################################

map/pdftex/updmap/pdftex.map: export TEXMFVAR=..
map/pdftex/updmap/pdftex.map: tfm/Chalkduster.tfm tfm/Papyrus.tfm tfm/Hyeenanhaukotus.tfm #tfm/TimesNewRoman.tfm tfm/TimesNewRomanB.tfm tfm/TimesNewRomanI.tfm tfm/TimesNewRomanBI.tfm
	@echo "Enabling the map file"
	@updmap --nomkmap --enable Map daz.map >> $(LOG) 2>&1
	@echo "Updating the local maps (TEXMFVAR: " $(abspath $(TEXMFVAR)) ")"
	@updmap >> $(LOG) 2>&1
	@rm -rf $(TEXMFVAR)/web2c

tfm/%.tfm: %.ttf
	@echo "Creating the support files for $*"
	@mkdir -p {tfm,truetype,map,enc,vf}
	@otftotfm -a -e texnansi $(VERBOSE) -fkern --typeface=$* --no-type1 --no-dotlessj --no-updmap \
	--tfm-directory=tfm \
	--vf-directory=vf \
	--encoding-directory=enc \
	--truetype-directory=truetype \
	--map-file=map/daz.map \
	$< LY1--$* >> $(LOG) 2>&1

# The small caps is not supported by Chalkduster, nor Papyrus
#--lf smcp

# Not Used
# --vpl-directory=vpl \
# --type1-directory=type1 \

##########################################
## Using Font Forge and Adobe Font Metrics
##########################################

# map/pdftex/updmap/pdftex.map: export TEXMFVAR=tds
# map/pdftex/updmap/pdftex.map: map/daz.map tfm/LY1--Chalkduster.tfm tfm/LY1--Papyrus.tfm #tfm/LY1--Chalkduster-smcp.tfm
# 	@echo "Enabling the map file"
# 	@updmap --nomkmap --enable Map daz.map >> $(LOG)
# 	@echo "Updating the local maps (TDS: $$TEXMFVAR)"
# 	@updmap >> $(LOG)

# type1/LY1--%.pfb: %.ttf
# 	@echo "Generating the Type1 fonts and Adobe Font Metrics"
# 	@mkdir -p {afm,type1}
# 	@$(FONTFORGE) -c 'Open($$1);Generate($$2)' $< type1/LY1--$*.pfb >> $(LOG) 2>&1
# 	@mv type1/LY1--$*.afm afm/LY1--$*.afm

# tfm/LY1--%.tfm: type1/LY1--%.pfb
# 	@echo "Generating the TeX Font Metrics"
# 	@mkdir -p {tfm,truetype,vpl,vf}
# 	@afm2tfm afm/LY1--$*.afm -T ec $@ > /dev/null 2>&1
# #	@echo "Copying the TrueType font"
# #	cp $*.ttf truetype/$*.ttf

# map/daz.map:
# 	@echo "Generating the map file"
# 	@mkdir -p map
# 	@echo 'LY1--Chalkduster Chalkduster " TeXnANSIEncoding ReEncodeFont " <texnansi <LY1--Chalkduster.pfb' > $@
# 	@echo 'LY1--Papyrus Papyrus " TeXnANSIEncoding ReEncodeFont " <texnansi <LY1--Papyrus.pfb' >> $@
