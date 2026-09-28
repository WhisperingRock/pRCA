// fa_sequencer.svh
// Sequencer for the FullAdder (agent)
//
// A Sequencer receives a single transaction (item) from the 
// 		Sequence and supplies it to the driver. Its a funnel lol

class fa_sequencer extends uvm_sequencer #(fa_item); 

	// ~~~~ register with factory ~~~~
	`uvm_component_utils(fa_sequencer);

	// ~~~~ constructor ~~~~~
	function new(
		string name = "fa_sequencer",
	   	uvm_component parent = null
	);
		super.new(name, parent);
	endfunction

endclass : fa_sequencer
