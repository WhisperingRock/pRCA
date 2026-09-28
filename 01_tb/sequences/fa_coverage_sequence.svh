// fa_coverage_sequence.svh
// Sequence for FullAdder
//
// A Sequence creates transactions (items) and send them to the sequencer

class fa_coverage_sequence extends uvm_sequence #(fa_item); 

	// ~~~~ register with factory ~~~~
	`uvm_object_utils(fa_coverage_sequence);

	// ~~~~ constructor ~~~~~
	function new(string name = "fa_coverage_sequence");
		// ~~ update parent ~~
		super.new(name);
	endfunction

	// ~~~~ time-consuming test creation ~~~~
	task body();
		
		// ~~ create item handle ~~
		fa_item item;

		// ~~ generate items(stimulus) ~~
		// note : try all 8 values
		for(int val = 0; val < 8; val++) begin

			// ~ alloc item handle
			item = fa_item::type_id::create("item");

			// ~ populate item ~
			start_item(item);

			item.A		= val[2];
			item.B		= val[1];
			item.Ci		= val[0];

			finish_item(item);
		end

	endtask
endclass : fa_coverage_sequence	
	

