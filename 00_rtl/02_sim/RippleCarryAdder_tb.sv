`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 11:43:28 AM
// Design Name: 
// Module Name: RippleCarryAdder_tb
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
	
	

module RippleCarryAdder_tb();

	// ~~~~ imports ~~~~
	import tb_utils_pkg::*;
	
	// ~~~~ locals ~~~~
	// const
	localparam W = 8;
	
	// test
	testcase 		tc; 
	logic [31:0]	tnum;
	logic 			clk;
	logic [W:0]		ans; 
	adder_transaction #(W) tr; 

	
	// wire
	logic [W-1:0]	a, b;
	logic			c;
	logic [W-1:0]	sum;
	logic 			carry;
	
	// ~~~~ instances ~~~~
	RippleCarryAdder #(W) UUT(
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
		
		tr			= new();
		tr.srandom(32'h1234_ABCD); // seed #
	
		// ~~ defaults ~~
		clk 		= 1'b1; 
	
		// ~~ TC1 ~~
		tc.new_test("Randomization");
		tnum = tc.get_testnum();
			for(int i = 0; i < 10000; i++) begin
			
				if(!tr.randomize()) begin
					$fatal(1, "Randomization Failed");
				end
			
				a 	= tr.a; 
				b 	= tr.b; 
				c 	= tr.c;
				ans	= a + b + c;
				#5;
				assert(carry 	=== ans[W])	else tc.err("Carry Out Error");
				assert(sum 		=== ans[W-1:0])	else tc.err("Sum Error");
				#5;
			end
		tc.test_done();
		
		tc.new_test("Floor");
		tnum = tc.get_testnum();
			a 	= 0; 
			b 	= 0; 
			c 	= 0;
			#5;
			assert(carry 	=== 0)	else tc.err("Carry Out Error");
			assert(sum 		=== 0)	else tc.err("Sum Error");
			#5;
		tc.test_done();
		
		tc.new_test("Ceililng");
		tnum = tc.get_testnum();
			a 	= 8'hFF; 
			b 	= 8'hFF; 
			c 	= 1'b1;
			#5;
			assert(carry 	=== 1'b1)	else tc.err("Carry Out Error");
			assert(sum 		=== 8'hFF)	else tc.err("Sum Error");
			#5;
		tc.test_done();
		
		tc.new_test("Rollover w/ carry");
		tnum = tc.get_testnum();
			a 	= 8'hFF; 
			b 	= 8'h00; 
			c 	= 1'b1;
			#5;
			assert(carry 	=== 1'b1)	else tc.err("Carry Out Error");
			assert(sum 		=== 8'h00)	else tc.err("Sum Error");
			#5;
			
			a 	= 8'h00; 
			b 	= 8'hFF; 
			c 	= 1'b1;
			#5;
			assert(carry 	=== 1'b1)	else tc.err("Carry Out Error");
			assert(sum 		=== 8'h00)	else tc.err("Sum Error");
			#5;
		tc.test_done();
		
		tc.new_test("Rollover w/o carry");
		tnum = tc.get_testnum();
			a 	= 8'hFF; 
			b 	= 8'h01; 
			c 	= 1'b0;
			#5;
			assert(carry 	=== 1'b1)	else tc.err("Carry Out Error");
			assert(sum 		=== 8'h00)	else tc.err("Sum Error");
			#5;
			
			a 	= 8'h01; 
			b 	= 8'hFF; 
			c 	= 1'b0;
			#5;
			assert(carry 	=== 1'b1)	else tc.err("Carry Out Error");
			assert(sum 		=== 8'h00)	else tc.err("Sum Error");
			#5;
		tc.test_done();
		
		$stop; // stop for timing
		
	end
	

	
endmodule