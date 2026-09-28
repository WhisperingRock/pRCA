// fa_item.svh
// Item component for FullAdder
//
// An item provides a format/recipy that fits with our interface 
// 		and what we generate with our sequence/sequencers

class fa_item extends uvm_sequence_item; 

	// ~~~~ inputs ~~~~
	rand bit 	A; 
	rand bit 	B;
	rand bit 	Ci; 

	// ~~~~ outputs (not generated or rand) ~~~~
	bit 		S; 
	bit 		Co;

	// ~~~~ register with factory ~~~~
	// allow creations using `type_id` instead of new()
	`uvm_object_utils_begin(fa_item)
		`uvm_field_int(A, UVM_ALL_ON)	
		`uvm_field_int(B, UVM_ALL_ON)	
		`uvm_field_int(Ci, UVM_ALL_ON)	
		`uvm_field_int(S, UVM_ALL_ON)	
		`uvm_field_int(Co, UVM_ALL_ON)	
	`uvm_object_utils_end

	// ~~~~ constructor ~~~~
	function new(string name = "fa_item");
		super.new(name);
	endfunction

endclass : fa_item
