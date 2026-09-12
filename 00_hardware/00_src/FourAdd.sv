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


module FourAdd(
	input logic  [31:0] A, B,
	input logic 		Ci, 
	output logic [31:0]	S, 
	output logic		Co
);

	// ~~~~ locals ~~~~
	genvar 				i;
	// consts
	localparam 			ADDWIDTH = 8;
	// wires
	logic	[4:0]		carry; 
	
	
	// ~~~~ instances ~~~~
	generate
		for(i = 0; i < 4; i++) begin
			RippleCarryAdder #(ADDWIDTH) gen_add
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
