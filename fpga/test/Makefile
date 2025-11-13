MODULES = frequency_divider
SRC = $(addprefix ../src/, $(addsuffix .v, $(MODULES)))

default: $(addsuffix -tb.vcd, $(MODULES))

%.out: $(SRC) %.v
	iverilog -I $(SRC) $^ -o $@

%.vcd: %.out
	./$<

clean:
	rm -f *.out *.vcd

.PHONY: all prog clean
