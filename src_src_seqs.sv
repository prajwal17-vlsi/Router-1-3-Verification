class src_seqs_base extends uvm_sequence #(src_xtn);

     `uvm_object_utils(src_seqs_base)
	
function new(string name="src_seqs_base");
	super.new(name);
endfunction
endclass

////////// small_pcket/////////

class small_seqs extends src_seqs_base;
	`uvm_object_utils(small_seqs)

bit[1:0] addr;

function new(string name="small_seqs");
	super.new(name);
endfunction

task body();
if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_type_name(),"getting adress is failed")
req=src_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {header[7:2] inside {[1:20]};header[1:0]==addr;})
finish_item(req);
endtask

endclass


////////////////medium_packet///////////
class medium_seqs extends src_seqs_base;
	`uvm_object_utils(medium_seqs)

bit[1:0] addr;

function new(string name="medium_seqs");
	super.new(name);
endfunction

task body();
if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_type_name(),"getting adress is failed")
req=src_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {header[7:2] inside {[21:40]};header[1:0]==addr;})
finish_item(req);
endtask

endclass

/////////////////////large packet//////////////

class large_seqs extends src_seqs_base;
	`uvm_object_utils(large_seqs)

bit[1:0] addr;

function new(string name="large_seqs");
	super.new(name);
endfunction

task body();
if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_type_name(),"getting adress is failed")
 req=src_xtn::type_id::create("req");
 start_item(req);
 assert(req.randomize() with {header[7:2] inside {[41:63]};header[1:0]==addr;})
 finish_item(req);
endtask

endclass



/////////////////////bad packet//////////////

class bad_seqs extends src_seqs_base;
	`uvm_object_utils(bad_seqs)

bit[1:0] addr;

function new(string name="bad_seqs");
	super.new(name);
endfunction

task body();
if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_type_name(),"getting adress is failed")
 req=src_xtn::type_id::create("req");
 start_item(req);
 assert(req.randomize() with {header[7:2] inside {[40:63]};header[1:0]==addr;})
 req.parity=8'd10;
 finish_item(req);
endtask

endclass

