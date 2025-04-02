module top;

import uvm_pkg::*;
import test_pkg::*;

bit clock;

always
	#5 clock=~clock;

router_if in(clock),in0(clock),in1(clock),in2(clock);


rtop DUV(.clk(clock),.rstn(in.restn),.din(in.din),
		.pkt_valid(in.pkt_valid),.error(in.error),
		.busy(in.busy),.re0(in0.rd_en),.re1(in1.rd_en),.re2(in2.rd_en),
		.vld0(in0.valid_out),.vld1(in1.valid_out),.vld2(in2.valid_out),
		.dout0(in0.dout),.dout1(in1.dout),.dout2(in2.dout));

initial 
begin	

	uvm_config_db#(virtual router_if)::set(null,"*","vif",in);
	uvm_config_db#(virtual router_if)::set(null,"*","vif0",in0);	
	uvm_config_db#(virtual router_if)::set(null,"*","vif1",in1);	
	uvm_config_db#(virtual router_if)::set(null,"*","vif2",in2);	
	run_test("medium_test");
end


property stable_data;
@(posedge clock) in.busy |=>$stable(in.din);
endproperty

property busy_check;
@(posedge clock) $rose(in.pkt_valid) |=>in.busy;
endproperty

property valid_signal;
@(posedge clock) $rose(in.pkt_valid)|->##3(in0.valid_out|in1.valid_out|in2.valid_out);
endproperty

property rd_en1;
@(posedge clock) in0.valid_out|->##[1:29]in0.rd_en;
endproperty

property rd_en2;
@(posedge clock) in1.valid_out|->##[1:29]in1.rd_en;
endproperty

property rd_en3;
@(posedge clock) in2.valid_out|->##[1:29]in2.rd_en;
endproperty

c1:assert property(stable_data)
$display("assertions is done for stable data");
else
$display("assertions is not done for stable data");

c2:assert property(busy_check)
$display("assertions is done for busy check");
else
$display("assertions is not done for busy check");

c3:assert property(valid_signal)
$display("assertions is done for valid out");
else
$display("assertions is not done for valid out");

c4:assert property(rd_en1)
$display("assertions is done for read en1");
else
$display("assertions is not done for read en1");

c5:assert property(rd_en2)
$display("assertions is done for read en 2");
else
$display("assertions is not done for read en 2");

c6:assert property(rd_en3)
$display("assertions is done for read en 3");
else
$display("assertions is not done for read en 3");

STABLE_DATA : assert property (stable_data);
BUSY_CHECK : assert property (busy_check);
VALID_SIGNAL : assert property (valid_signal);
READ_ENABLE1 : assert property (rd_en1);
READ_ENABLE2 : assert property (rd_en2);
READ_ENABLE3 : assert property (rd_en3);


endmodule	
				

