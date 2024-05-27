`default_nettype none

`timescale 1ns / 1ps

module Simulation_Clock
#(
    parameter CLOCK_PERIOD = 10
)
(
    output reg clock
);

    localparam HALF_PERIOD = CLOCK_PERIOD / 2;

    always begin
        #HALF_PERIOD clock = (clock === 1'b0);
    end

endmodule