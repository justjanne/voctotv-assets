RESOLUTIONS := 192 384 1920 3840
EVENTS      := $(patsubst %/card.svg,%,$(wildcard */card.svg))
TMPDIR := $(shell mktemp -d)

.PHONY: all
all: $(EVENTS)

.PHONY: list
list:
	echo $(EVENTS)


.PHONY: $(EVENTS)
$(EVENTS): %: $(foreach res,$(RESOLUTIONS),dist/%/card-$(res).png)

dist/%.png: $(TMPDIR)/%.png
	mkdir -p $(@D)
	zopflipng -y $< $@

.DELETE_ON_ERROR:
.SECONDEXPANSION:
$(TMPDIR)/%.png: $$(firstword $$(wildcard $$*.svg $$(*D)/card.svg))
	mkdir -p $(@D)
	inkscape \
		--export-area-page \
		--export-png-color-mode=RGB_8 \
		--export-png-use-dithering=true \
		--export-png-antialias=3 \
		--export-png-compression=9 \
		--export-overwrite \
		--export-width=$(subst card-,,$(*F)) \
		--export-filename=$@ \
		$<
