/*
* UVM_TEST 
*
* Purpose : Top-level UVM component that defines a verification
*			scenario (using environments) to potentially run at 
*			the top-level testbench module. 
*
*	at the top level, we'll call `run_test("this_test")`
*	to run this test
* 
*/

class fa_smoke_test extends uvm_test; 

	// ~~ register component with factory ~~
	`uvm_component_utils(fa_smoke_test);

	// ~~ handle to environment ~~
	fa_env	env;

	// ~~ constructor ~~
	function new (
		string name = "fa_smoke_test",
	   	uvm_component parent = null
	);
		// ~ update parent ~
		super.new(name, parent);
	endfunction : new

	// ~~ build phase update ~~
	virtual function void build_phase (uvm_phase phase);

		// ~ update parent ~
		super.build_phase(phase);

		// ~~ update environment using factory ~~
		env = fa_env::type_id::create("env", this);
	endfunction : build_phase

	// ~~ print testb component heirarchy after build phase for sanity ~
	virtual function void end_of_elaboration_phase(uvm_phase phase);
		uvm_root::get().print_topology();
	endfunction

	// ~~ run phase update ~~
	task run_phase(uvm_phase phase);

		// ~ empty handles ~
		fa_sequence	seq;

		// ~ ack : start test ~
		phase.raise_objection(this);

		// ~ test ~
		seq = fa_sequence::type_id::create("seq");
		seq.start(env.agent.sequencer);

		// ~ ack : end test ~
		phase.drop_objection(this);
	endtask
	
endclass : fa_smoke_test


