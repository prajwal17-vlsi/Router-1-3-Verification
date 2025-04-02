module rtop(clk,rstn,re0,re1,re2,din,pkt_valid,dout0,dout1,dout2,vld0,vld1,vld2,error,busy);
input clk,rstn,re0,re1,re2,pkt_valid;
input [7:0]din;
output vld0,vld1,vld2,error,busy;
output [7:0]dout0,dout1,dout2;


wire [2:0]we_enb;
wire [7:0]dout;
wire empty0,empty1,empty2,full0,full1,full2;
wire sft0,sft1,sft2;
wire detect_add,ld_state,laf_state,full_state,we_reg,rst_int_reg,lfd_state;
wire low_pkt_valid,parity_done,fifo_full;

fsm_r FSM(clk,rstn,pkt_valid,low_pkt_valid,sft0,sft1,sft2,fifo_full,empty0,empty1,empty2,parity_done,din[1:0],busy,detect_add,ld_state,laf_state,full_state,we_reg,rst_int_reg,lfd_state);


synch SYNC(clk,rstn,we_reg,detect_add,re0,re1,re2,empty0,empty1,empty2,full0,full1,full2,din[1:0],we_enb,fifo_full,vld0,vld1,vld2,sft0,sft1,sft2);


routerfifo FIFO_0(clk,rstn,re0,we_enb[0],dout,lfd_state,sft0,empty0,dout0,full0);
routerfifo FIFO_1(clk,rstn,re1,we_enb[1],dout,lfd_state,sft1,empty1,dout1,full1);
routerfifo FIFO_2(clk,rstn,re2,we_enb[2],dout,lfd_state,sft2,empty2,dout2,full2);

registerR REGISTER(clk,rstn,pkt_valid,din,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,error,dout);


endmodule


