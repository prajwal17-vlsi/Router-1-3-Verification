class dst_seqs_base extends uvm_sequence #(dst_xtn);
`uvm_object_utils(dst_seqs_base)

function new(string name="dst_seqs_base");
super.new(name);
endfunction

endclass

//////////////////normal_seq///////////////////

class normal_seqs extends dst_seqs_base;

`uvm_object_utils(normal_seqs)

function new(string name="normal_seqs");
	super.new(name);
endfunction

task body();
	req=dst_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {delay<30;});
	finish_item(req);
endtask

endclass


///////////////sft_rst_seq/////////////////////

class sftrst_seqs extends dst_seqs_base;

`uvm_object_utils(sftrst_seqs)

function new(string name="sftrst_seqs");
	super.new(name);
endfunction

task body();
	req=dst_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {delay>30;});
	finish_item(req);
endtask

endclass


