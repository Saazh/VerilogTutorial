package blinky

import spinal.core._
import spinal.lib._

import scala.util.Random

//Hardware definition
class Blinky extends Component {
  val io = new Bundle {
    val btn = in Bool
    val blink = out Bool
    val push = out Bool
  }
  val blinkState = Reg(Bool) init(False)
  val timer = Timeout(500 ms)
  when(timer){
    blinkState := !blinkState
    timer.clear()
  }
  io.blink := blinkState
  io.push := io.btn
}

//Generate the MyTopLevel's Verilog
object BlinkyVerilog {
  def main(args: Array[String]) {
    SpinalConfig(
        defaultClockDomainFrequency=FixedFrequency(12 MHz),
        targetDirectory = "rtl"
      ).generateVerilog(new Blinky)
      .printPruned() 
  }
}
