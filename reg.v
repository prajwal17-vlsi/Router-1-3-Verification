module registerR(clk,rstn,pkt_valid,din,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,error,dout);
input clk,rstn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
input [7:0]din;
output reg parity_done,low_pkt_valid,error;
output reg [7:0]dout;
reg [7:0]pkt_parity,internal_parity,header_byte,fifo_full_state;
always@(posedge clk)
begin
	if(!rstn)
	begin
		dout<=0;
	/*	header_byte<=0;
		fifo_full_state<=0;
	end
/	else if(detect_add &&  pkt_valid && (din[0:0]=!2'b11))
	begin
		header_byte<=din;
	end
	else if( pkt_valid && lfd_state)
		dout<=
	else if(!lfd_state && !fifo_full)
		dout<=din;
	else if(ld_state && fifo_full)
	        fifo_full_state<=din;
	   else if(laf_state)
		 dout<=fifo_full_state;*/
	end
	else if(lfd_state)
		dout<=header_byte;
	else if(pkt_valid&&ld_state&&!fifo_full)
		dout<=din;
	else if(ld_state&&fifo_full)
	begin
		fifo_full_state<=din;
		if(laf_state)
			dout<=fifo_full_state;
			end
	else if(~pkt_valid)
		dout<=din;
	else
		dout<=dout;
end

always@(posedge clk)
begin
	if(!rstn)
		header_byte<=0;
	else if(detect_add && pkt_valid && din[1:0]!=2'b11)
		header_byte<=din;
	else
		header_byte<=header_byte;
end

always@(posedge clk)
begin
	if(!rstn)
		low_pkt_valid<=0;
	else if(rst_int_reg)
		low_pkt_valid<=0;
	else if(ld_state && !pkt_valid)
		low_pkt_valid<=1;
	else
		low_pkt_valid<=low_pkt_valid;
end

always@(posedge clk)
begin
	if(!rstn)
		pkt_parity<=0;
	else if(detect_add)
		pkt_parity<=0;
	else if((ld_state&&!pkt_valid&&!fifo_full)||(laf_state&&!parity_done&&low_pkt_valid))
		pkt_parity<=din;
	else
		pkt_parity<=pkt_parity;
end


always@(posedge clk)
begin
	if(!rstn)
		internal_parity<=0;
	else if(detect_add)
		internal_parity<=0;
	else if(lfd_state&&pkt_valid)
		internal_parity<=internal_parity^header_byte;
	else if(ld_state&&pkt_valid&&!full_state)
		internal_parity<=internal_parity^din;
	else
		internal_parity<=internal_parity;
end

always@(posedge clk)
begin
	if(!rstn)
		parity_done<=0;
	else if(detect_add)
		parity_done<=0;
	else if((ld_state&&!pkt_valid&&!fifo_full)||(laf_state&&!parity_done&&low_pkt_valid))
		parity_done<=1;
        else
		parity_done<=parity_done;
end

always@(posedge clk)
begin
	if(!rstn)
		error<=0;
	else if(parity_done)
	begin
		if(internal_parity==pkt_parity)
			error<=0;
		else
			error<=1;
	end
	else
		error<=0;
end



endmodule









	  



