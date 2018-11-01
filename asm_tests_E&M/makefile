# Code borrowed from Alex Hoppe

include ../settings.mk

MARS_PATH := ~/Documents/CompArch/mips/Mars4_5.jar
MARS_OPTS := a  mc CompactTextAtZero
MARS      := java -jar $(MARS_PATH) $(MARS_OPTS)

%.text.hex: %.asm
	$(MARS) dump .text HexText $@  $<

%.data.hex: %.asm
	$(MARS) dump .data HexText $@  $<

assemble: $(MEMDUMP)

clean:
	-rm -f $(MEMDUMP)

.PHONY: assemble clean
