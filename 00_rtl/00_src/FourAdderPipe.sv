`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 02:11:52 PM
// Design Name: 
// Module Name: FourAdderPipe
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
typedef struct packed
{
	// pipe reg 0
	logic [23:0]	p0_a;
	logic [23:0]	p0_b;
	logic [7:0] 	p0_sum0;
	logic			p0_carry0; 
	
	// pipe reg 1
	logic [15:0]	p1_a;
	logic [15:0]	p1_b;
	logic [7:0] 	p1_sum0;
	logic [7:0] 	p1_sum1;
	logic			p1_carry1; 
	
	// pipe reg 2
	logic [7:0]		p2_a;
	logic [7:0]		p2_b;
	logic [7:0] 	p2_sum0;
	logic [7:0] 	p2_sum1;
	logic [7:0] 	p2_sum2;
	logic			p2_carry2;
	
	// pipe reg 3
	logic [7:0] 	p3_sum0;
	logic [7:0] 	p3_sum1;
	logic [7:0] 	p3_sum2;
	logic [7:0] 	p3_sum3;
	logic			p3_carry3;

} pipereg_t;

module FourAdderPipe
#(parameter BITWIDTH = 32)
(
	input logic	 [BITWIDTH-1:0]	A, B,
	input logic 				Ci,
	input logic					CLK,
	input logic					RST,

	output logic [BITWIDTH-1:0]	S, 
	output logic				Co
);

	// ~~~~ locals ~~~~
	// ~~ consts ~~
	localparam 					ADDWIDTH = 8;
	
	// ~~ wires ~~
	logic [31:0]				sum;
	logic [3:0]					carry; 
	
	// ~~ regs ~~
	pipereg_t pr; 
	
	
	// ~~~~ instances ~~~~

	RippleCarryAdder #(ADDWIDTH) add0
	(
		.A				(A[7:0]), 
		.B				(B[7:0]), 
		.Ci				(Ci), 
		// ~~
		.S				(sum[7:0]), 
		.Co				(carry[0])
	);
	
	RippleCarryAdder #(ADDWIDTH) add1
	(
		.A				(pr.p0_a[7:0]), 
		.B				(pr.p0_b[7:0]), 
		.Ci				(pr.p0_carry0), 
		// ~~
		.S				(sum[15:8]), 
		.Co				(carry[1])
	);

	RippleCarryAdder #(ADDWIDTH) add2
	(
		.A				(pr.p1_a[7:0]), 
		.B				(pr.p1_b[7:0]), 
		.Ci				(pr.p1_carry1), 
		// ~~
		.S				(sum[23:16]), 
		.Co				(carry[2])
	);
		
	RippleCarryAdder #(ADDWIDTH) add3
	(
		.A				(pr.p2_a), 
		.B				(pr.p2_b), 
		.Ci				(pr.p2_carry2), 
		// ~~
		.S				(sum[31:24]), 
		.Co				(carry[3])
	);
		
	// ~~~~ sync logic ~~~~
	always_ff @(posedge CLK) begin
	
		// ~~ priority 0 : reset ~~
		if(RST == 1'b1) begin
			pr <= '0;
		end
		
		// ~~ priority 1 : move data ~~
		else begin
			// ~~ pipe reg 0 (between adds 0:1) ~~
			pr.p0_a 		<= A[31:8];
			pr.p0_b 		<= B[31:8];
			pr.p0_sum0		<= sum[7:0];
			pr.p0_carry0	<= carry[0];
			
			// ~~ pipe reg 1 (between adds 1:2) ~~
			pr.p1_a			<= pr.p0_a[23:8];
			pr.p1_b			<= pr.p0_b[23:8];
			pr.p1_sum0		<= pr.p0_sum0;
			pr.p1_sum1		<= sum[15:8];
			pr.p1_carry1	<= carry[1];
			
			// ~~ pipe reg 2 (between adds 2:3) ~~
			pr.p2_a			<= pr.p1_a[15:8];
			pr.p2_b			<= pr.p1_b[15:8];
			pr.p2_sum0		<= pr.p1_sum0;
			pr.p2_sum1		<= pr.p1_sum1;
			pr.p2_sum2		<= sum[23:16];
			pr.p2_carry2	<= carry[2];
			
			// ~~ pipe reg 3 (after add 3) ~~
			pr.p3_sum0		<= pr.p2_sum0;
			pr.p3_sum1		<= pr.p2_sum1;
			pr.p3_sum2		<= pr.p2_sum2;
			pr.p3_sum3		<= sum[31:24];
			pr.p3_carry3	<= carry[3];
		end
	end

	// ~~~~ async logic ~~~~
	assign S 	= {pr.p3_sum3, pr.p3_sum2, pr.p3_sum1, pr.p3_sum0};
	assign Co	= pr.p3_carry3;	

	
endmodule
