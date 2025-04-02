module fsm_r(clk,rstn,pkt_valid,low_pkt_valid,sftrst_0,sftrst_1,sftrst_2,fifo_full,fifo_empty0,fifo_empty1,fifo_empty2,parity_done,din,busy,detect_add,ld_state,laf_state,full_state,we_reg,rst_int_reg,lfd_state);
input clk,rstn,pkt_valid,low_pkt_valid,sftrst_0,sftrst_1,sftrst_2,fifo_full,fifo_empty0,fifo_empty1,fifo_empty2,parity_done;
input [1:0]din;
output busy,detect_add,ld_state,laf_state,full_state,we_reg,rst_int_reg,lfd_state;
parameter DECODE_ADDR=3'b000,
	  LOAD_FIRST_DATA=3'b001,
	  WAIT_TILL_EMPTY=3'b010,
	  LOAD_DATA=3'b011,
     LOAD_PARITY=3'b100,
	  FIFO_FULL_STATE=3'b101,
	  LOAD_AFTER_FULL=3'b110,
	  CHECK_PARITY_ERROR=3'b111;
reg [1:0]addr;
reg [2:0]state,nxt;
always @(posedge clk)
begin
	if(!rstn)
		addr<=0;
	else
		addr<=din;
end
always@(posedge clk)
begin
	if(!rstn)
		state<=DECODE_ADDR;
		else if(sftrst_0||sftrst_1||sftrst_2)
		state<=DECODE_ADDR;
	else
		state<=nxt;
end

always@(*)
begin
//nxt=DECODE_ADDR;
	case(state)
		DECODE_ADDR:
		begin
			if((pkt_valid & (din[1:0]==0) & fifo_empty0)|(pkt_valid & (din[1:0]==1) & fifo_empty1)|(pkt_valid & (din[1:0]==2) & fifo_empty2))
				nxt=LOAD_FIRST_DATA;
			else if((pkt_valid & (din[1:0]==0) & !fifo_empty0)|(pkt_valid & (din[1:0]==1) & !fifo_empty1)|(pkt_valid & (din[1:0]==2) & !fifo_empty2))
				nxt=WAIT_TILL_EMPTY;
			else
				nxt=DECODE_ADDR;
		end
		LOAD_FIRST_DATA:nxt=LOAD_DATA;
		WAIT_TILL_EMPTY:
		begin
			if(fifo_empty0 &&(addr==0)||fifo_empty1 &&(addr==1)||fifo_empty2 &&(addr==2))
				nxt=LOAD_FIRST_DATA;
			else
				nxt=WAIT_TILL_EMPTY;
		end
		LOAD_DATA:
		begin
			if(!fifo_full&&!pkt_valid)
				nxt=LOAD_PARITY;
			else if(fifo_full)
				nxt=FIFO_FULL_STATE;
			else
				nxt=LOAD_DATA;
		end
		LOAD_PARITY:nxt=CHECK_PARITY_ERROR;
		FIFO_FULL_STATE:
		begin
			if(!fifo_full)
				nxt=LOAD_AFTER_FULL;
			else 
				nxt=FIFO_FULL_STATE;

		end
		LOAD_AFTER_FULL:
		     begin
				if(!parity_done && low_pkt_valid)
				    nxt=LOAD_PARITY;
			        else if(!parity_done && !low_pkt_valid)
				     nxt=LOAD_DATA;
			        else if(parity_done)
				     nxt=DECODE_ADDR;
		     end
		CHECK_PARITY_ERROR:
		begin
			if(!fifo_full)
				nxt=DECODE_ADDR;
			else if(fifo_full)
				nxt=FIFO_FULL_STATE;
		end
	endcase
end
assign lfd_state=(state==LOAD_FIRST_DATA)?1'b1:1'b0;
assign detect_add=(state==DECODE_ADDR)?1'b1:1'b0;
assign ld_state=(state==LOAD_DATA)?1'b1:1'b0;
assign full_state=(state==FIFO_FULL_STATE)?1'b1:1'b0;
assign laf_state=(state==LOAD_AFTER_FULL)?1'b1:1'b0;
assign we_reg=((state==LOAD_DATA)||(state==LOAD_PARITY)||(state==LOAD_AFTER_FULL))?1'b1:1'b0;
assign rst_int_reg=(state==CHECK_PARITY_ERROR)?1'b1:1'b0;
assign busy=((state==DECODE_ADDR)||(state==LOAD_DATA))? 1'b0:1'b1;
endmodule






			




