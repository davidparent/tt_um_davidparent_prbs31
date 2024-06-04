# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import numpy as np
prbs_size=31 #Size of the LSFR
#Fill two numpy ararys with 1's
PRBSN=np.ones(prbs_size)
PRBSO=np.zeros(prbs_size)
ttt=prbs_size-1
PRBSO[prbs_size-1]=int(1)

#Number of clock cycles:
n_clock=1000
#set input and output arrays
out=np.ones(n_clock)
input=out
for i in range(n_clock):
  #input the feedback
  PRBSN[0]=np.logical_xor(PRBSO[27],PRBSO[30])
  #shift the vlaues
  for j in range(len(PRBSN)-1):
    count=len(PRBSN)-j-1
    PRBSN[count]=PRBSO[count-1]
  #update the arrary
  for j in range(len(PRBSN)):
    PRBSO[j]=PRBSN[j]
  #tqke the output from the rightmost FF.
  out[i]=int(PRBSN[prbs_size-1])

@cocotb.test() 
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
   
    dut.ena.value = 1
    dut.ui_in.vale = 0
    dut.uio_in.value = 0

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 0
 
    dut._log.info("Test project behavior")
    #n_clock=120
    for i in range(0,n_clock):
    # Wait for one clock cycle to see the output values
    	await ClockCycles(dut.clk, 1)
    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
 
    	assert dut.uo_out[0].value == out[i]

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
