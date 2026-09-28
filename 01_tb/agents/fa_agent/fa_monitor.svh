// fa_monitor.svh
// monitor for the FullAdder module
//
// A monitor passively watches the interface and converts signal 
// activity back into a transaction(item) for which it published/broadcasts
// for others to subscribe/listen to.

class fa_monitor extends uvm_monitor; 

	// ~~~~ register with the factory ~~~~
	`uvm_component_utils(fa_monitor)

	// ~~~~ instantiate the virtual interface we're reading from ~~~~
	virtual fa_if vif; 

	// ~~~~ create a publishing port we can broadcast to ~~~~
	uvm_analysis_port #(fa_item) analysis_port;

	// ~~~~ constructor  ~~~~
	function new(
		string name = "fa_monitor",
	   	uvm_component parent = null
	);
		super.new(name, parent); 
		analysis_port = new("analysis_report", this);
	endfunction

	// ~~~~ build phase (setup) ~~~~
	function void build_phase(uvm_phase phase);

		// ~~ update parent phase ~~
		super.build_phase(phase);

		// ~~ retrieve v.interface connection from database ~~
		if(!uvm_config_db#(virtual fa_if)::get(this,     "" , "vif", vif)) begin
			`uvm_error("", "uvm_config_db::get failed creating virtual interface")
		end

	endfunction

	// ~~~~ run phase : read pins in real time ~~~~
	task run_phase(uvm_phase phase);

		// ~~ instantiate item ~~
		fa_item item;

		// ~~ reads pins and publish ~~
		forever begin

			// ~ wait to cycle through DUT ~
			#1; 

			// ~ collect data ~
			item = fa_item::type_id::create("item");

			item.A		= vif.A;
			item.B		= vif.B;
			item.Ci		= vif.Ci;
			item.S		= vif.S;
			item.Co		= vif.Co;

			// ~ and publish ~
			analysis_port.write(item);
		end
	endtask
endclass : fa_monitor
	
