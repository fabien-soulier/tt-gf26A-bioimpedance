import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def test_dac_ram(dut):
    
    # horloge à 1 MHz
    clock = Clock(dut.clk,1, unit = "us")
    cocotb.start_soon(clock.start())
    
    #reset
    dut._log.info("Testing reset")
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    
    # Lecture de 20 bit
    dut._log.info("lecture du bitstream:")
    for i in range(20):
        await RisingEdge(dut.clk)
        dut._log.info(f"cycle {i}: dac_out_ram = {int(dut.dac_out_ram.value)}")
    
    #ecriture du bitstream
    dut._log.info("ecriture de nouveaux bit")
    for i in range(20):
        dut.dac_data_in.value = 0    # alterne 0 et 1
        await RisingEdge(dut.clk)
        dut.value.we = 1
        dut._log.info(f"Écriture cycle {i} : dac_data_in = {0} dac_out_ram = {int(dut.dac_out_ram.value)}")
    
   