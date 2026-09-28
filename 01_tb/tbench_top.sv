module tbench_top; 

	// ~~~~ imports ~~~~
	import uvm_pkg::*;
	import tb_pkg::*;
	
	// ~~~~ locals ~~~~
	logic clk = 1'b1;

	// ~~~~ interfaces ~~~~
	fa_if fa_if1();
	
	// ~~~~ DUT instances ~~~~
	FullAdder fa1(
		.A		(fa_if1.A),
		.B		(fa_if1.B),
		.Ci		(fa_if1.Ci),
		// ~~
		.S		(fa_if1.S),
		.Co		(fa_if1.Co)
	);

	// ~~~~ heartbeat ~~~~
	always #10 clk = ~clk; 	
	
	// ~~~~ testing ~~~~
	initial begin

		// ~~ connect virtual to hard interface in config DB ~~ 
		uvm_config_db#(virtual fa_if)::set(
			null, 
			"*",
			"vif",
			fa_if1
		);

		// ~~ run phase ~~
		run_test();

	end
	
endmodule
	
