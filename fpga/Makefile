TARGET = frequency_divider
SRC = $(addprefix ./src/, $(addsuffix .v, $(TARGET)))

#default: $(NAME).rpt $(NAME).bin

#sim: $(NAME)-tb.gtkw

$(NAME)-tb.out: $(PROJ).v $(PROJ)_tb.v $(SRCS)
	iverilog -I . $^ -o $@

%_tb.vcd: %_tb.out
	./$<
	mv *.vcd $(PROJDIR)/

%.gtkw: %.vcd
	gtkwave $< -O $@

%.json: %.v $(SRCS)
	yosys -q -p 'synth_ice40 -top $(PP) -json $@' $^

%.asc: $(PIN_DEF) %.json
	nextpnr-ice40 --pcf-allow-unconstrained --lp8k --package $(PKG) --freq 20 --json $(PROJ).json --pcf $(PIN_DEF) --asc $(PROJ).asc

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

%_syn.v: %.blif
	yosys -p 'read_blif -wideports $^; write_verilog $@'

prog: $(PROJ).bin
	tinyprog -p $<

clean:
	rm -f $(PROJ).blif $(PROJ).json $(PROJ).asc $(PROJ).rpt $(PROJ).bin $(PROJ)_tb.out $(PROJ)_tb.vcd $(PROJ)_tb.gtkw 

.SECONDARY:
.PHONY: all prog clean
