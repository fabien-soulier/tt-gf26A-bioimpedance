MODULES = frequency_divider
SRC = $(addprefix ../src/, $(addsuffix .v, $(MODULES)))

default: $(addsuffix -tb.vcd, $(MODULES))

%.vvp: $(SRC) %.v
	iverilog -g2012 -I $(SRC) $^ -o $@

%.vcd: %.vvp
	vvp $<

clean:
	rm -f *.vvp *.vcd *.out

.PHONY: clean
