import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge

@cocotb.test()
async def test_output_register(dut):
    dut._log.info("Start")
    
    #initial
    dut._log.info("Testing initial state")
    dut.rst.value = 1
    dut.set.value = 0
    dut.sending.value = 0
    dut.Q.value = 0
    await Timer(20, unit="ns")
    dut.rst.value = 0 
    await Timer(10, unit="ns")
    
    #sauvegarde quand set=1
    dut._log.info("Test 1: Save 0xAA")
    dut.Q.value = int("AA" * 16, 16) # 128 bits = 32 caracteres hexa
    dut.set.value = 1 #front montant donc on capture
    await Timer(10, unit="ns")
    q_out_val = dut.Q_out.value.to_unsigned()
    dut._log.info(f"Q_out = 0x{q_out_val:032X}")
    assert q_out_val == int("AA" * 16, 16), "Q_out should be 0xAA..."
    
    # set=0
    dut._log.info("Test 2: can't save with set=0")
    dut.set.value = 0                     
    await Timer(10, unit="ns")
    dut.Q.value = int("BB" * 16, 16) 
    await Timer(10, unit="ns")
    q_out_val = dut.Q_out.value.to_unsigned()
    dut._log.info(f"Q_out = 0x{q_out_val:032X}")
    assert q_out_val == int("AA" * 16, 16), "Should not change (set=0)"
    
    #nouvelle souvegarde lorsqueset=1
    dut._log.info("Test 3: Save 0xCC")
    dut.Q.value = int("CC" * 16, 16)
    dut.set.value = 1 #on capture
    await Timer(10, unit="ns")
    q_out_val = dut.Q_out.value.to_unsigned()
    dut._log.info(f"Q_out = 0x{q_out_val:032X}")
    assert q_out_val == int("CC" * 16, 16), "Q_out should be 0xCC..."
    