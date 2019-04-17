# -----------------------------------------------------------------------------
# Copyright (c) Neochip LTD, Inc. All rights reserved
# Confidential Proprietary
# -----------------------------------------------------------------------------
# FILE NAME      : 
# AUTHOR         : $Author$
# AUTHOR’S EMAIL : mauricio.carvalho@neochip.co.uk
# -----------------------------------------------------------------------------
# RELEASE HISTORY 
# VERSION DATE        AUTHOR  DESCRIPTION
# $Rev$     $Date$  name $Author$       
# -----------------------------------------------------------------------------
# KEYWORDS    : General file searching keywords, leave blank if none.
# -----------------------------------------------------------------------------
# PURPOSE     : Makefile for FIR_N
# -----------------------------------------------------------------------------

MODULE="fir_top"
TARGET=testbench
TESTS=./tests
.PHONY: $(TARGET)
RTL=./RTL
all: $(TARGET)

LDFLAGS=
CFLAGS=-g -O3 -DMODULE=\'\"$(MODULE)\"\'


clean::
	rm -rf *.o $(TARGET)

distclean:: clean
	rm -rf *~ *.txt *.vcd *.mif *.orig

$(TARGET):
	verilator -Wno-fatal +incdir+lib -I. -I$(RTL) -I$(TESTS) -DINC_TEST_FILE="\`include \"$(MODULE).sv\"" -DMODULE=\"$(MODULE)\" --cc $(@).sv --trace --exe $(@).cpp -Mdir $(@) -CFLAGS "$(CFLAGS)"
	make -C $(@) -f V$(@).mk 

wave:
	gtkwave -o ./$(TARGET)/V$(TARGET).vcd

schem::
	echo "read_verilog $(RTL)/$(MODULE).v"             > .script
	echo "hierarchy -check"                           >> .script
	echo "proc; opt"                                  >> .script
	echo "write_json -aig $(SCHEM)/$(MODULE).json"    >> .script	
	echo "exit"
	yosys -s .script
	netlistsvg $(SCHEM)/$(MODULE).json -o $(SCHEM)/$(MODULE).svg
	google-chrome $(SCHEM)/$(MODULE).svg

