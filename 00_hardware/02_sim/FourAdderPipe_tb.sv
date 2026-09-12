`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 12:52:30 PM
// Design Name: 
// Module Name: FourAdd_tb
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

class adder_transaction #(int WIDTH = 8);
	
	// ~~ attributes ~~
	rand logic [WIDTH-1:0]	a; 
	rand logic [WIDTH-1:0]	b;
	rand logic 				c;
	
endclass

module FourAdderPipe_tb();

	// ~~~~ imports ~~~~
	import tb_utils_pkg::*;
	
	// ~~~~ locals ~~~~
	// const
	localparam 				W = 32;
	localparam				HALFCLK = 5;
	
	// test
	testcase 				tc; 
	logic [31:0]			tnum;
	logic 					clk;
	logic					reset;
	logic [W:0]				ans; 
	adder_transaction #(W) 	tr; 

	
	// wire
	logic [W-1:0]			a, b;
	logic					c;
	logic [W-1:0]			sum;
	logic 					carry;
	
	// ~~~~ instances ~~~~
	FourAdderPipe UUT(
		.A			(a), 
		.B			(b), 
		.Ci			(c),
		.CLK		(clk),
		.RST		(reset),
		// ~~	
		.S			(sum), 
		.Co			(carry)
	);
	
	// ~~~~ heartbeat ~~~~~
	always begin
		#HALFCLK;
		clk <= !clk;
	end
	
	// ~~~~ testing ~~~~
	initial begin
	
		// ~~ class instances ~~
		tc			= new();
		
		tr			= new();
		tr.srandom(32'h1234_ABCD); // seed #
	
		// ~~ defaults ~~
		clk 		= 1'b1;
		ans			= 33'd0;
		a 			= 32'd0; 
		b 			= 32'd0; 
		c 			= 1'b0;
		
		// ~~ UUT init ~~
		reset		= 1'b1;
		#100; 
		reset		= 1'b0;
		#100; 
		
		// ~~ TC1 ~~
		tc.new_test("Adding : randomization");
		tnum = tc.get_testnum();
			for(int i = 0; i < 10000; i++) begin
			
				if(!tr.randomize()) begin
					$fatal(1, "Randomization Failed");
				end
			
				// write data and wait 3 cycles for it to come out
				a 	= tr.a; 
				b 	= tr.b; 
				c 	= tr.c;
				ans	= a + b + c;
				#HALFCLK; #HALFCLK;
				a 	= 32'd0; 
				b 	= 32'd0; 
				c 	= 1'b0;
				#HALFCLK; #HALFCLK;					// takes 3 cycles to get the info out
				#HALFCLK; #HALFCLK;
				#HALFCLK;
				assert(carry 	=== ans[W])	else tc.err("Carry Out Error");
				assert(sum 		=== ans[W-1:0])	else tc.err("Sum Error");
				#HALFCLK;
			end
		tc.test_done();
		
		// ~~ sanitize ~~
		reset		= 1'b1;
		#HALFCLK;#HALFCLK; 
		reset		= 1'b0;
		#HALFCLK;#HALFCLK; 
		
		tc.new_test("Adding : Floor");
		tnum = tc.get_testnum();
			a 	= 0; 
			b 	= 0; 
			c 	= 0;
			#HALFCLK;
			#HALFCLK;#HALFCLK;
			#HALFCLK;#HALFCLK;
			assert(carry 	=== 0)	else tc.err("Carry Out Error");
			assert(sum 		=== 0)	else tc.err("Sum Error");
			#HALFCLK;
		tc.test_done();
		
		tc.new_test("Adding : Ceililng");
		tnum = tc.get_testnum();
			a 	= 32'hFFFF_FFFF; 
			b 	= 32'hFFFF_FFFF; 
			c 	= 1'b1;
			#HALFCLK;
			assert(carry 	=== 1'b1)			else tc.err("Carry Out Error");
			assert(sum 		=== 32'hFFFF_FFFF)	else tc.err("Sum Error");
			#HALFCLK;
		tc.test_done();
		
		tc.new_test("Adding : Rollover w/ carry");
		tnum = tc.get_testnum();
			a 	= 32'hFFFF_FFFF; 
			b 	= 32'd0; 
			c 	= 1'b1;
			#HALFCLK;
			assert(carry 	=== 1'b1)	else tc.err("Carry Out Error");
			assert(sum 		=== 32'd0)	else tc.err("Sum Error");
			#HALFCLK;
			
			a 	= 32'd0; 
			b 	= 32'hFFFF_FFFF; 
			c 	= 1'b1;
			#HALFCLK;
			assert(carry 	=== 1'b1)	else tc.err("Carry Out Error");
			assert(sum 		=== 32'd0)	else tc.err("Sum Error");
			#HALFCLK;
		tc.test_done();
		
		tc.new_test("Adding : Rollover w/o carry");
		tnum = tc.get_testnum();
			a 	= 32'hFFFF_FFFF; 
			b 	= 32'h0000_0001; 
			c 	= 1'b0;
			#HALFCLK;
			assert(carry 	=== 1'b1)	else tc.err("Carry Out Error");
			assert(sum 		=== 32'd0)	else tc.err("Sum Error");
			#HALFCLK;
			
			a 	= 32'h0000_0001; 
			b 	= 32'hFFFF_FFFF; 
			c 	= 1'b0;
			#HALFCLK;
			assert(carry 	=== 1'b1)	else tc.err("Carry Out Error");
			assert(sum 		=== 32'd00)	else tc.err("Sum Error");
			#HALFCLK;
		tc.test_done();
		
		$stop; // stop for timing
		
	end
	


endmodule
