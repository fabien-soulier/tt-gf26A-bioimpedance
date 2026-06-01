import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge

CLKS_PER_BIT = 104

async def lire_octet_uart(dut):
    await FallingEdge(dut.TX)
    await ClockCycles(dut.CLK, CLKS_PER_BIT // 2)
    assert dut.TX.value == 0, "Bit de start doit etre 0"
    octet = 0
    for i in range(8):
        await ClockCycles(dut.CLK, CLKS_PER_BIT)
        bit = int(dut.TX.value)
        octet |= (bit << i)
    await ClockCycles(dut.CLK, CLKS_PER_BIT)
    assert dut.TX.value == 1, "Bit de stop doit etre 1"
    return octet


async def lire_q_out_uart(dut):
    octets = []
    for i in range(16):
        octet = await lire_octet_uart(dut)
        octets.append(octet)
        dut._log.info(f"  UART octet {i} = 0x{octet:02X}")
    q_out = 0
    for i, o in enumerate(octets):
        q_out |= (o << (8 * i))
    return q_out


async def lire_q_out_mux(dut):
    octets = []
    for i in range(16):
        octet = dut.MUX_OUT.value.to_unsigned()
        octets.append(octet)
        dut._log.info(f"  MUX octet {i} = 0x{octet:02X}")
        dut.MUX_ADDR.value = 1
        await ClockCycles(dut.CLK, 2)
        dut.MUX_ADDR.value = 0
        await ClockCycles(dut.CLK, 2)
    q_out = 0
    for i, o in enumerate(octets):
        q_out |= (o << (8 * i))
    return q_out


@cocotb.test()
async def test_top_level(dut):
    dut._log.info("Start")
    clock = Clock(dut.CLK, 1000, unit="ns")
    cocotb.start_soon(clock.start())

    # reset
    dut._log.info("testing reset")
    dut.RST.value = 1
    dut.ADC_IN.value = 0
    dut.MUX_ADDR.value = 0
    await ClockCycles(dut.CLK, 10)

    # test ADC_IN = 1
    dut._log.info("start count with ADC_IN=1")
    dut.RST.value = 0
    dut.ADC_IN.value = 1
    await RisingEdge(dut.ready)
    q_mux = await lire_q_out_mux(dut)
    dut._log.info(f"Q_out MUX = 0x{q_mux:032X}")
    q_uart = await lire_q_out_uart(dut)
    dut._log.info(f"Q_out UART = 0x{q_uart:032X}")

    # signal alterne
    dut._log.info("Signal ADC_IN alterne")
    for i in range(10):
        dut.ADC_IN.value = i % 2
        await ClockCycles(dut.CLK, 1000)
    await RisingEdge(dut.ready)
    q_mux = await lire_q_out_mux(dut)
    dut._log.info(f"Q_out MUX alterne = 0x{q_mux:032X}")
    q_uart = await lire_q_out_uart(dut)
    dut._log.info(f"Q_out UART alterne = 0x{q_uart:032X}")

    dut._log.info("Test finished")