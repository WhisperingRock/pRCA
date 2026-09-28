// fa_scoreboard.svh
// scoreboard to the FullAdder
//
// A scoreboard determines if the DUT behaves correctly

class fa_scoreboard extends uvm_scoreboard;

	// ~~~~ register with factory ~~~~
	`uvm_component_utils(fa_scoreboard);

	// ~~~~ allocates analysis implementation port (only handle) ~~~~
	// "forward the subscribed monitor item to the scoreboard"
	uvm_analysis_imp #(fa_item, fa_scoreboard) analysis_export;

	// ~~~~ constructor ~~~~
	function new(
		string name  			= "fa_scoreboard",
		uvm_component parent	= null
	);
		// ~~ update parent ~~
		super.new(name, parent); 

		// ~~ create scoreboard's analysis receiver to accept transactions from the monitor ~~
		// *** connects handle above
		analysis_export = new("analysis_export", this);

	endfunction

	// ~~~~ judgement day + fun printout ~~~~
	function void write(fa_item item);

		// ~~ local vars ~~
		bit expected_S; 
		bit expected_Co; 

		// ~~ answer ~~
		{expected_Co, expected_S} = item.A + item.B + item.Ci; 

		// ~~ judgement ~~
		if( (item.S 	!== expected_S ) ||
			(item.Co 	!== expected_Co)
		) begin
			
			// ~ raise error on failure ~
			`uvm_error(
				"FA_MISMATCH", 
				$sformatf(
					"A=%0b B=%0b Ci=%0b: expected S=%0b Co=%0b, got S=%0b Co=%0b",
					item.A, 
				   	item.B, 
					item.Ci,
					expected_S, 
					expected_Co,
					item.S, 
					item.Co
				)
			)
		end
		else begin
			// ~ success with low verbosity ~
			`uvm_info(
				"FA_MATCH", 
				"FullAdder result is correct",
				UVM_LOW
			)
		end
	endfunction
endclass : fa_scoreboard





