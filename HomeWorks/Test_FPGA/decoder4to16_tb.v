module decoder4to16_tb();
	reg [3:0] a_tb;
	wire [15:0] y_tb;
	decoder4to16 DUT (a_tb, y_tb);
	
	initial begin
	    $dumpfile("decoder4to16_tb.vcd");
	    $dumpvars(0, decoder4to16_tb);
	end
	
	initial repeat (25) #25 a_tb = $random;
	
	
endmodule
