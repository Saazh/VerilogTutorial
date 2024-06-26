`default_nettype none

`timescale 1ns / 1ps

//The internal clock is 12MHz
`define TICKS_TIME 1000
`define FREQ 12000000

module LED_array (
    input clk,
    input rst,
//    input rst_shifter,
    output reg [7:0] out
);

    wire tikz;
    generate_clock blk1 (.clock(clk), .rst(rst), .tiks(tikz));
    reg [2:0] cntr;
    reg flag_cntr; //controls the direction of the shifting
    wire [7:0] mux_out;
    always @(posedge clk) begin
//        if (!rst_shifter) begin
        if (!rst) begin
            cntr <= 0;
            out <= 8'b10000000;
            flag_cntr <= 0; 
        end else begin
            if(tikz) begin // will generate tiks as enable signal of synchronous logic
                if ((cntr != 7) & (flag_cntr == 0)) begin
                    cntr <= cntr + 1;
                end
                if (cntr == 7) begin
                    flag_cntr <= 1;
                end
                if ((cntr != 0) & (flag_cntr == 1)) begin
                    cntr <= cntr - 1;
                end
                if (cntr == 0) begin
                    flag_cntr <= 0;
                end
            end
        end
        out<=mux_out;
    end
    mux8to1 mux_blk (.sel(cntr), .out(mux_out));


endmodule

//mux module
module mux8to1(out,sel);
//input [7:0] in;
output reg [7:0] out;
input [2:0] sel;

always @(out,sel) begin
    case(sel)
        3'b000  : out = 8'b10000000;
        3'b001  : out = 8'b01000000;
        3'b010  : out = 8'b00100000;
        3'b011  : out = 8'b00010000;
        3'b100  : out = 8'b00001000;
        3'b101  : out = 8'b00000100;
        3'b110  : out = 8'b00000010;
        3'b111  : out = 8'b00000001;
        default : out = 8'b00000000;
    endcase
    
end

endmodule



//tikz generator
module generate_clock(
    input clock,
    input rst,
    output reg tiks
);

    reg [31:0] cntr;
    localparam  SECOND_CNT = `FREQ/`TICKS_TIME;
    always @(posedge clock) begin
        if(!rst) begin
            cntr <= 0;
            tiks <= 0;
        end
        else begin
            cntr <= cntr + 1;
            tiks <= 0;
            if(cntr == SECOND_CNT) begin
                // tiks <= ~tiks;
                tiks <= 1;
                cntr <= 0;
            end
        end
    end

endmodule

//Test Bench
module LED_array_tb();

    wire clock_tb;
//    reg rst_shifter_tb;
    reg rst_tb;
    wire [7:0] out_tb;

    LED_array dut (
        .clk(clock_tb),
        .rst(rst_tb),
//        .rst_shifter(rst_shifter_tb),
        .out(out_tb)
    );

    Simulation_Clock  
    #(
        .CLOCK_PERIOD(83) // ns
        // 12 MHz ~~= 83.33 ns
    )
    dut_clk
    (
        .clock(clock_tb)
    );
    // always #1 clock_tb = ~clock_tb; // Clock generation

    `define WAIT_CYCLES(n) repeat (n) begin @(posedge clock_tb); end

    time cycle = 0;
    
    always @(posedge clock_tb) begin
        cycle = cycle + 1;
    end
    
    `define UNTIL_CYCLE(n) wait (cycle == n);

    initial begin
        $dumpfile("led_shift.vcd");
        $dumpvars(0, LED_array_tb);
        // clock_tb = 0;
        $display("Initialize Testbench");
        rst_tb = 0; // Set rst to 0 initially
        //#10; // Wait for 8 time steps
        `WAIT_CYCLES(16);
        $display("Testing Resets...");
        rst_tb = 1;
//        rst_shifter_tb = 0;
        //#12;
//        `WAIT_CYCLES(24);
//        rst_shifter_tb = 1;
        // #5         // Set rst to 1
//        `WAIT_CYCLES(10);
//        rst_shifter_tb = 0;
        // #5
//        `WAIT_CYCLES(10);
//        rst_shifter_tb = 1;
        $display("Testing resets done, testing functionality...");
        // #20000000; // Wait for simulation to complete
        `WAIT_CYCLES(500000);
        $finish;
    end

endmodule
