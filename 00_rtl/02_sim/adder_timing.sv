`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 06:21:56 PM
// Design Name: 
// Module Name: adder_timing
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

module adder_timing();

	// ~~~~ imports ~~~~
	import tb_utils_pkg::*;

	// ~~~~ locals ~~~~
	logic					clk;
	 
	// wire
	logic [31:0]			a, b;
	logic					c;
	logic [31:0]			sum;
	logic 					carry;
	logic					reset;
	
	
	// test
	testcase 				tc; 
	logic [31:0]			tnum;
	adder_transaction #(32) tr; 
	
	// ~~~~ instances ~~~~
	/*
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
	*/
	
	FourAdd UUT(
		.A			(a), 
		.B			(b), 
		.Ci			(c),
		// ~~	
		.S			(sum), 
		.Co			(carry)
	);


	// ~~~~ heartbeat ~~~~~
	always begin
		#5;
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
		a 			= 32'd0; 
		b 			= 32'd0; 
		c 			= 1'b0;
		
		// ~~ UUT init ~~
		reset		= 1'b1;
		#100; 
		reset		= 1'b0;
		#100; 
		
		// ~~ TC1 ~~
		tc.new_test("Just nums");
		tnum = tc.get_testnum();
			for(int i = 0; i < 10000; i++) begin
			
				if(!tr.randomize()) begin
					$fatal(1, "Randomization Failed");
				end

				a 	= tr.a; 
				b 	= tr.b; 
				c 	= tr.c;
				#10;
				
			end
		tc.test_done();
		
		$stop;
	end

endmodule
