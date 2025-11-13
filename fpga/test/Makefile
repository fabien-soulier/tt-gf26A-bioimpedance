MODULES = frequency_divider
SRC = $(addprefix ../src/, $(addsuffix .v, $(MODULES)))

default: $(addsuffix -tb.gtkw, $(MODULES))

%-tb.out: $(SRC) %-tb.v
	iverilog -I . $^ -o $@

%_tb.vcd: %_tb.out
	./$<

%.gtkw: %.vcd
	gtkwave $< -O $@

clean:
	rm -f *.out *.vcd *.gtkw 

.PHONY: all prog clean
