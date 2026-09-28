// fa_coverage.svh
// Coverage subscriber of FullAdder monitor
//
// Coverage ...

class fa_coverage extends uvm_subscriber #(fa_item);

	// ~~~~ register component with factory ~~~~
	`uvm_component_utils(fa_coverage)

	// ~~~~ TODO : items under scrutiny ??? ~~~~
	covergroup fa_cg with function sample(
		bit A,
		bit B,
		bit Ci,
		// ~~
		bit S, 
		bit Co
	);

		// ~~ TODO ~~
		option.per_instance = 1;

		// ~~ cover points ??? ~~
		a_cp: coverpoint A {
			bins zero 	= {0};
			bins one 	= {1};
		}
		b_cp: coverpoint B {
			bins zero 	= {0};
			bins one 	= {1};
		}
		ci_cp: coverpoint Ci {
			bins zero 	= {0};
			bins one 	= {1};
		}
		s_cp: coverpoint S {
			bins zero 	= {0};
			bins one 	= {1};
		}
		co_cp: coverpoint Co {
			bins zero 	= {0};
			bins one 	= {1};
		}

		// ~~ ???? TODO ~~
		input_cross: cross a_cp, b_cp, ci_cp;

	endgroup

	// ~~~~ constructor ~~~~
	function new(
		string name 			= "fa_coverage",
		uvm_component parent	= null
	);
		super.new(name, parent);
		fa_cg = new();
	endfunction

	// ~~~~ subscribe to the monitor ~~~~
	virtual function void write(fa_item t);
		fa_cg.sample(t.A, t.B, t.Ci, t.S, t.Co);
	endfunction
endclass : fa_coverage










