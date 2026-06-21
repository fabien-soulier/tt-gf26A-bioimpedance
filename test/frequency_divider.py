import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    #Clock
    clock = Clock(dut.clk, 1, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Testing reset")
    dut.rst.value = 1

    await ClockCycles(dut.clk, 2)
    assert dut.clki.value == 0
    assert dut.clkq.value == 0

    await ClockCycles(dut.clk, 1)
    assert dut.clki.value == 0
    assert dut.clkq.value == 0

    # Running
    dut._log.info("Testing module behavior")
 
    dut.rst.value = 0

    await dut.clk.falling_edge
    assert dut.clki.value == 0
    assert dut.clkq.value == 0

    await dut.clk.falling_edge
    assert dut.clki.value == 1
    assert dut.clkq.value == 0

    await dut.clk.rising_edge
    assert dut.clki.value == 1
    assert dut.clkq.value == 1

    await dut.clk.falling_edge
    assert dut.clki.value == 0
    assert dut.clkq.value == 1

    await dut.clk.rising_edge
    assert dut.clki.value == 0
    assert dut.clkq.value == 0

    await ClockCycles(dut.clk, 5)
