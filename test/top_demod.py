import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

@cocotb.test()
async def test_top_demod(dut):
    dut._log.info("Start")
    
    # horloge a 1 MHz
    clock = Clock(dut.clk, 1000, unit="ns")
    cocotb.start_soon(clock.start())
    
    # test du reset
    dut._log.info("Testing reset")
    dut.rst.value = 1
    getattr(dut, "in").value = 0
    await ClockCycles(dut.clk, 20)
    assert dut.i_msb.value == 0, "i_msb should be 0 after reset"
    assert dut.q_msb.value == 0, "q_msb should be 0 after reset"
    dut._log.info("Reset OK")
    
    # test du diviseur d'horloge
    dut._log.info("Testing clock divider")
    dut.rst.value = 0
    clk_div2_before = dut.clk_div2.value
    await ClockCycles(dut.clk, 2)
    clk_div2_after = dut.clk_div2.value
    assert clk_div2_before != clk_div2_after, "clk_div2 should toggle"
    dut._log.info("Clock divider OK")
    
    #test avec in=1
    dut._log.info("Testing counter with in=1")
    getattr(dut, "in").value = 1
    await ClockCycles(dut.clk, 500)
    i_msb_val = dut.i_msb.value.to_unsigned()
    q_msb_val = dut.q_msb.value.to_unsigned()
    dut._log.info(f"i_msb = {i_msb_val}")
    dut._log.info(f"q_msb = {q_msb_val}")
    assert i_msb_val > 0, "i_msb should increment"
    assert q_msb_val > 0, "q_msb should increment"
    dut._log.info("Counter OK")
    
    # test avec in=0
    dut._log.info("Testing counter with in=0")
    i_msb_before = dut.i_msb.value.to_unsigned()
    q_msb_before = dut.q_msb.value.to_unsigned()
    getattr(dut, "in").value = 0
    await ClockCycles(dut.clk, 20)
    i_msb_after = dut.i_msb.value.to_unsigned()
    q_msb_after = dut.q_msb.value.to_unsigned()
    dut._log.info(f"Before: i_msb={i_msb_before}, q_msb={q_msb_before}")
    dut._log.info(f"After:  i_msb={i_msb_after}, q_msb={q_msb_after}")
    assert abs(i_msb_after - i_msb_before) <= 1, "i_msb devrait rester stable"
    assert abs(q_msb_after - q_msb_before) <= 1, "q_msb devr&ait rester stable"
    dut._log.info("Counter freeze OK")
    #test du reset pendant le comptage
    dut._log.info("Testing reset pendant comptage")
    getattr(dut, "in").value = 1
    await ClockCycles(dut.clk, 100)
    dut.rst.value = 1
    await ClockCycles(dut.clk, 20)
    assert dut.i_msb.value == 0, "i_msb should be 0 after reset"
    assert dut.q_msb.value == 0, "q_msb should be 0 after reset"
    dut._log.info("Reset pendant comptage OK")
    