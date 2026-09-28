// Interfaces for the project

interface fa_if();
	logic A, B, Ci; 
	// ~~
	logic S, Co;	
endinterface : fulladd_if

interface rca_if
#(parameter BITWIDTH = 8);
	logic [BITWIDTH-1:0]	A, B;
	logic					Ci; 
	// ~~
	logic [BITWIDTH-1:0]	S; 
	logic					Co;
endinterface : ripplecarry_if

interface foura_if
#(parameter BITWIDTH = 32);
	logic [BITWIDTH-1:0]	A, B;
	logic					Ci; 
	// ~~
	logic [BITWIDTH-1:0]	S; 
	logic					Co;
endinterface :foura_if 

