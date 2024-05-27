module decoder4to16(input [3:0] a, output [15:0] y);
	decoder3to8 de1 (a[2:0], a[3], y[15:8]);
	decoder3to8 de2 (a[2:0], ~a[3],y[7:0]);
endmodule
module decoder3to8(input [2:0] in, input en, output reg [7:0] out);
	
	always @(in, en) begin
		if(en)
			case (in)
				0: out = 8'b00000001;
				1: out = 8'b00000010;
				2: out = 8'b00000100;
				3: out = 8'b00001000;
				4: out = 8'b00010000;
				5: out = 8'b00100000;
				6: out = 8'b01000000;
				7: out = 8'b10000000;
				//default: 8'bxxxxxxxx;
			endcase
		else 
			out =8'b00000000;
	end
	
endmodule