`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 12:27:13 PM
// Design Name: 
// Module Name: FourAdd
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


module FourAdd
#(parameter BITWIDTH = 32)
(
	input logic  [BITWIDTH-1:0] A, B,
	input logic 				Ci, 
	output logic [BITWIDTH-1:0]	S, 
	output logic				Co
);

	// ~~~~ locals ~~~~
	genvar 						i;
	// consts
	localparam 	int				ADDWIDTH = 8;
	localparam	int				W = BITWIDTH / ADDWIDTH;
	// wires
	logic	[W:0]				carry;	// requires an extra bit  
	
	
	// ~~~~ instances ~~~~
	generate
		for(i = 0; i < W; i=i+1) begin

			RippleCarryAdder 
			#(
				.BITWIDTH(ADDWIDTH)
			) 
			gen_add
			(
				.A				(A[i*ADDWIDTH +:ADDWIDTH]), 
				.B				(B[i*ADDWIDTH +:ADDWIDTH]), 
				.Ci				(carry[i]), 
				// ~~
				.S				(S[i*ADDWIDTH +:ADDWIDTH]), 
				.Co				(carry[i+1])
			);

		end
	endgenerate
	
	// ~~~~ comb logic ~~~~
	assign	carry[0] 	= Ci;
	assign	Co			= carry[4];
	
endmodule
