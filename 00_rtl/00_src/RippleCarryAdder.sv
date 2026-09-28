`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 11:24:21 AM
// Design Name: 
// Module Name: RippleCarryAdder
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


module RippleCarryAdder
#(parameter BITWIDTH = 8)
(
	input logic 	[BITWIDTH-1:0] 	A, B,
	input logic						Ci,
	output logic	[BITWIDTH-1:0]	S,
	output logic					Co
);
	
	// ~~~~ locals ~~~~
	logic			[BITWIDTH:0]	carry; // carries an extra bit ;)
	genvar 							i;
	
	// ~~~~ comb ~~~~
	assign carry[0]	= Ci;
	assign Co		= carry[BITWIDTH];
	
	// ~~~~ instances ~~~~
	generate
		for(i = 0; i < BITWIDTH; i=i+1) begin

			FullAdder fa(
				.A			(A[i]), 
				.B			(B[i]), 
				.Ci			(carry[i]), 
				// ~~
				.S			(S[i]), 
				.Co			(carry[i+1])
		    );

		end
	endgenerate 
	

endmodule
