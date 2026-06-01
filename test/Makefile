# Defaults
SIM ?= icarus
FST ?= -fst # Use more efficient FST format
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src

# Modules à tester (décommenter celui voulu)
#PROJECT_SOURCES = frequency_divider.v
#PROJECT_SOURCES = compt8.v
#PROJECT_SOURCES = Output_Register.v
#PROJECT_SOURCES = diviseur2.v compt8.v top_demod.v
PROJECT_SOURCES = diviseur2.v compt8.v top_demod.v uart_tx_8n1.v Output_Register.v compt256.v mux.v Top_level.v

# RTL simulation:
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

# Allow sharing configuration between design and testbench via `include`:
COMPILE_ARGS += -I$(SRC_DIR)

# Include the testbench sources:
#VERILOG_SOURCES += $(PWD)/frequency_divider-tb.v
#VERILOG_SOURCES += $(PWD)/compt8-tb.v
#VERILOG_SOURCES += $(PWD)/Output_Register-tb.v
#VERILOG_SOURCES += $(PWD)/top_demod-tb.v
VERILOG_SOURCES += $(PWD)/Top_level-tb.v

TOPLEVEL = tb


# List test modules to run, separated by commas and without the .py suffix:
#COCOTB_TEST_MODULES = frequency_divider
#COCOTB_TEST_MODULES = compt8
#COCOTB_TEST_MODULES = Output_Register
#COCOTB_TEST_MODULES = top_demod
COCOTB_TEST_MODULES = Top_level

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim