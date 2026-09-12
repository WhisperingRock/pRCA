`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 10:33:51 AM
// Design Name: 
// Module Name: FullAdder
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


module FullAdder(
	input logic		A, B, Ci,
	output logic	S, Co
    );
    
    assign S 		= A ^ B ^ Ci; 
    assign Co		= (A & B) | (A & Ci) | (B & Ci);
    
    // Zero fun version
    //assign {Co, S} = A + B + Ci;
    
endmodule
