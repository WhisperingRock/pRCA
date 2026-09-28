/*
* fa_env.svh
* Environment for FullAdder
*
* An environment connects agents with checking components 
*
*/


class fa_env extends uvm_env;
	
	// ~~~~ register component with factory ~~~~
	`uvm_component_utils(fa_env);

	// ~~~~ (empty) handles ~~~~
	fa_agent		agent;
	fa_scoreboard	scoreboard;
	fa_coverage		coverage;

	// ~~~~ constructor links to parent uvm ~~~~
	function new (
		string name = "fa_env",
	   	uvm_component parent = null
	);
		super.new(name, parent);
	endfunction : new

	// ~~~~ build phase (setup internal hierarchy) ~~~~
	function void build_phase(uvm_phase phase);
		
		// ~~ update parent ~~
		super.build_phase(phase);

		// ~~ internal component creation ~~
		agent		= fa_agent::type_id::create("agent", this);
		scoreboard	= fa_scoreboard::type_id::create("scoreboard", this);
		coverage	= fa_coverage::type_id::create("coverage", this);
	endfunction 

	// ~~~~ connect phase (connect internal heirarchy) ~~~~
	function void connect_phase(uvm_phase phase);

		// ~~ update parent ~~
		super.connect_phase(phase);

		// ~~ components ~~
		
		// ~ scoreboard subscribes to agent's monitor (output) ~
		agent.monitor.analysis_port.connect(scoreboard.analysis_export);

		// ~ coverage subscribes to agent's monitor (output) ~
		agent.monitor.analysis_port.connect(coverage.analysis_export);

	endfunction

endclass : fa_env

