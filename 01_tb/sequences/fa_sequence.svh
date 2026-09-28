// fa_sequence.svh
// Sequence for FullAdder
//
// A Sequence creates transactions (items) and send them to the sequencer

class fa_sequence extends uvm_sequence #(fa_item); 

	// ~~~~ register with factory ~~~~
	`uvm_object_utils(fa_sequence);

	// ~~~~ constructor ~~~~~
	function new(string name = "fa_sequence");
		// ~~ update parent ~~
		super.new(name);
	endfunction

	// ~~~~ time-consuming test creation ~~~~
	task body();
		
		// ~~ create item handle ~~
		fa_item item;

		// ~~ generate items(stimulus) ~~
		repeat(2) begin

			// ~ alloc item handle
			item = fa_item::type_id::create("item");

			// ~ populate item ~
			start_item(item);

			if(!item.randomize()) begin
				`uvm_fatal(
					"RANDFAIL",
					"Couldn't randomize fa_item"
				)
			end

			finish_item(item);
		end

	endtask
endclass : fa_sequence	
	

