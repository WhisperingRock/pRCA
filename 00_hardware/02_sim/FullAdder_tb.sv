`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 10:42:12 AM
// Design Name: 
// Module Name: FullAdder_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FullAdder_tb();

	// ~~~~ imports ~~~~
	import tb_utils_pkg::*;
	
	// ~~~~ locals ~~~~
	// test
	testcase 		tc; 
	logic [31:0]	tnum;
	logic 			clk;
	
	// Input {C, A, B} Output{Sum, Carry}
	logic [1:0] adderLUT [0:7]; 
	
	// wire
	logic			a, b, c;
	logic			sum, carry;
	
	// ~~~~ instances ~~~~
	FullAdder UUT(
		.A			(a), 
		.B			(b), 
		.Ci			(c),
		// ~~	
		.S			(sum), 
		.Co			(carry)
	);
	
	// ~~~~ heartbeat ~~~~~
	always begin
		clk <= !clk;
		#5;
	end
	
	// ~~~~ testing ~~~~
	initial begin
	
		// ~~ class instances ~~
		tc			= new();
	
		// ~~ defaults ~~
		clk 		= 1'b1; 
		adderLUT 	= 
		'{
			// no carry in
			3'b000:		2'b0_0,
			3'b001:		2'b1_0,
			3'b010:		2'b1_0,
			3'b011:		2'b0_1,
			
			// carry in
			3'b100:		2'b1_0,
			3'b101:		2'b0_1,
			3'b110:		2'b0_1,
			3'b111:		2'b1_1,
			
			default:	2'b0_0	
		}; 
	
		// ~~ TC1 ~~
		tc.new_test("");
		tnum = tc.get_testnum();
			for(bit [3:0] i = 4'b0000; i < 4'b1000; i++) begin
				$display("Ci = %b  A = %b  B = %b", i[2], i[1], i[0]);
				c = i[2];
				a = i[1];
				b = i[0];
				#5; 
				assert(carry 	=== adderLUT[i][0])	else tc.err("Carry Out Error");
				assert(sum 		=== adderLUT[i][1])	else tc.err("Sum Error");
				#5;
			end
		tc.test_done();
		
		
	end
	
endmodule
