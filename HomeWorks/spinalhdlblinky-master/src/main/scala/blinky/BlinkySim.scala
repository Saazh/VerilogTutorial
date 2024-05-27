package blinky

import spinal.core._
import spinal.sim._
import spinal.core.sim._

import scala.util.Random

object BlinkySim {
  def main(args: Array[String]) {
    SimConfig.withConfig(
        SpinalConfig(
          defaultClockDomainFrequency=FixedFrequency(12 MHz)
        )
      ).withWave.doSim(new Blinky){dut =>
      //Fork a process to generate the reset and the clock on the dut
      dut.clockDomain.forkStimulus(period = 82)
      dut.io.btn #= false
      dut.clockDomain.waitRisingEdge()
      waitUntil(dut.io.blink.toBoolean)
      dut.clockDomain.waitRisingEdge()
      dut.clockDomain.waitRisingEdge()
      dut.io.btn #= true

      waitUntil(!dut.io.blink.toBoolean)
      
      dut.clockDomain.waitRisingEdge()
      dut.clockDomain.waitRisingEdge()
      
      waitUntil(dut.io.blink.toBoolean)
      
      dut.io.btn #= false
      dut.clockDomain.waitRisingEdge()
      dut.clockDomain.waitRisingEdge()
      
      waitUntil(!dut.io.blink.toBoolean)
      dut.clockDomain.waitRisingEdge()

    }
  }
}
