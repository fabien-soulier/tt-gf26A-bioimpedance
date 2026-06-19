import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge

@cocotb.test()
async def test_dac(dut):

    # horloge à 1 MHz
    clock = Clock(dut.clk,1, unit = "us")
    cocotb.start_soon(clock.start())

    # reset
    dut._log.info("Testing reset")
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    
    # Lecture des 512 bit
    dut._log.info("lecture du bitstream:")
    for i in range(20):
        await RisingEdge(dut.clk)
        dut._log.info(f"cycle {i}:dac_out = {int(dut.dac_out.value)}")

    #faire un test pour voir si ça reboucle bien
    dut._log.info("lecture pour voir si ça reboucle bien")







