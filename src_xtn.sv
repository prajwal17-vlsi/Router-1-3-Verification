class src_xtn extends uvm_sequence_item;

rand bit[7:0] header;
rand bit[7:0] payload[];
bit[7:0] parity;
bit pkt_valid;
bit busy,error;

`uvm_object_utils(src_xtn)

function new(string name="scr_xtn");
super.new(name);
endfunction

constraint a1{header[1:0]!=2'b11;header[7:2]!=0;}
constraint a2{payload.size==header[7:2];}

function void do_print(uvm_printer printer);
	printer.print_field("header",this.header,8,UVM_DEC);
	foreach(payload[i])
	   printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
  	printer.print_field("parity",this.parity,8,UVM_DEC);
	printer.print_field("busy",this.busy,1,UVM_DEC);
	printer.print_field("error",this.error,1,UVM_DEC);
endfunction

function void post_randomize();
	parity=parity^header;
	 foreach(payload[i])
		parity=parity^payload[i];
endfunction


endclass

