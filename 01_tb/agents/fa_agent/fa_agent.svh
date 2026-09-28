// fa_agent.svh
// agent to the FullAdder
//
// An agent groups the interface-related components together

class fa_agent extends uvm_agent;

	// ~~~~ register with factory ~~~~
	`uvm_component_utils(fa_agent)

	// ~~~~ internal instantiations ~~~~
	fa_sequencer	sequencer; 
	fa_driver		driver;
	fa_monitor		monitor; 

	// ~~~~ constructor (update parent)  ~~~~
	function new(
		string name 			= "fa_agent",
		uvm_component parent	= null
	);
		super.new(name, parent);
	endfunction

	// ~~~~ build phase (setup hierarchy) ~~~~
	function void build_phase(uvm_phase phase);

		// ~~ update parent ~~
		super.build_phase(phase);

		// ~~ component assignment/creation ~~
		// note : a passive or active agent always monitors
		monitor = fa_monitor::type_id::create("monitor", this);

		// ~~ an active agent needs parts to drives the DUT ~~
		if(is_active == UVM_ACTIVE) begin
			sequencer	= fa_sequencer::type_id::create("sequencer", this);
			driver 		= fa_driver::type_id::create("driver", this);
		end
	endfunction

	// ~~~~ connect phase (connect hierarchy) ~~~~
	function void connect_phase(uvm_phase phase);

		// ~~ update parent ~~
		super.connect_phase(phase);

		// ~~ connect active agent's internal parts ~~
		if(is_active == UVM_ACTIVE) begin
			driver.seq_item_port.connect(sequencer.seq_item_export);
		end

	endfunction


endclass : fa_agent
