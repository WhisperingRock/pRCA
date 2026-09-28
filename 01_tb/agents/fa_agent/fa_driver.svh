// fa_driver.svh
// Driver for FullAdder.sv
//
// The driver converts transaction-level comms into actual signals for the DUT


class fa_driver extends uvm_driver #(fa_item);

	// ~~ register with factory ~~
	`uvm_component_utils(fa_driver)

	// ~~ create v.interface handle ~~
	virtual fa_if vif; 

	// ~~ constructor linked to parent ~~
	function new (
		string name = "fa_driver",
	   	uvm_component parent = null
	);
		super.new(name, parent);
	endfunction

	 // ~~ build phase (setup) ~~
	function void build_phase(uvm_phase phase);

		// ~~ notify parent of update ~~
		super.build_phase(phase);

		// ~~ link virtual interface handle to config db~~
		//                   ~ type ~          caller | path | name  | value 
		if(!uvm_config_db#(virtual fa_if)::get(this,     "" , "vif", vif)) begin
			 `uvm_error("", "uvm_config_db::get failed creating virtual interface")
		end
	endfunction

	 // ~~ run phase : drive/wiggle the pins in real time ~~
	task run_phase(uvm_phase phase);

		// ~ instantiate item ~
		fa_item item;

		// ~ transfer item from the sequencer to v.interface (and DUT) ~
		forever begin
			
			// grab from sequencer ...
			seq_item_port.get_next_item(item);

			// ... then update v.interface
			vif.A	= item.A;
			vif.B	= item.B;
			vif.Ci	= item.Ci;

			// delay for non-imm change
			#1;

			// ack sequencer for more data
			seq_item_port.item_done();
		end
	endtask
endclass : fa_driver
