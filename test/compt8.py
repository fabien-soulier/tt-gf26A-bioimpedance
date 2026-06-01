import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    #clock
    clock_i = Clock(dut.clki, 1, unit="us")
    cocotb.start_soon(clock_i.start())
    
    clock_q = Clock(dut.clkq, 1, unit="us")
    cocotb.start_soon(clock_q.start())

    # Reset
    dut._log.info("Testing reset")
    dut.rst.value = 1
    dut.inp.value = 0

    await ClockCycles(dut.clki, 2)
    assert dut.count_I.value == 0
    assert dut.count_Q.value == 0

    await ClockCycles(dut.clki, 1)
    assert dut.count_I.value == 0
    assert dut.count_Q.value == 0

    # Running
    dut.rst.value = 0
    dut.inp.value = 1

    await ClockCycles(dut.clki, 200)
    count_i = dut.count_I.value.to_unsigned()
    count_q = dut.count_Q.value.to_unsigned()
    
    dut._log.info(f"count_I = {count_i}")
    dut._log.info(f"count_Q = {count_q}")
    
    assert count_i > 0, "count_I should increment"
    assert count_q > 0, "count_Q should increment"

    dut.inp.value = 0
    await ClockCycles(dut.clki, 1)
    
    count_before = dut.count_I.value.to_unsigned()
    
    await ClockCycles(dut.clki, 5)
    
    assert dut.count_I.value.to_unsigned() == count_before, "count_I should freeze"
    