//The internal clock is 12MHz
`define TICKS_TIME 1000
`define FREQ 12500000

module generate_clock(
    input clock,
    input rst,
    output reg tiks
);

    reg [31:0] cntr;

    always @(posedge clock) begin
        if(!rst) begin
            cntr <= 0;
            tiks <= 0;
        end
        else begin
            cntr <= cntr + 1;
            if(cntr == `FREQ/`TICKS_TIME) begin
                tiks <= ~tiks;
                cntr <= 0;
            end
        end
    end

endmodule

//test bench for generating ticks
module generate_clock_tb();

    reg clock_tb;
    reg rst_tb;
    wire tiks_tb;

    generate_clock dut (
        .clock(clock_tb),
        .rst(rst_tb),
        .tiks(tiks_tb)
    );

    always #1 clock_tb = ~clock_tb; // Clock generation

    initial begin
        $dumpfile("generate_clock_tb.vcd");
        $dumpvars(0, generate_clock_tb);
        clock_tb = 0;
        rst_tb = 0; // Set rst to 0 initially
        #10; // Wait for 8 time steps
        rst_tb = 1; // Set rst to 1
        #20000000; // Wait for simulation to complete
        $finish;
    end

endmodule

