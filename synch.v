module synch(clk,rstn,we_reg,det_addr,re0,re1,re2,empty0,empty1,empty2,full0,full1,full2,din,wr_enb,fifo_full,vld0,vld1,vld2,sft0,sft1,sft2);
input clk,rstn,we_reg,det_addr,re0,re1,re2,empty0,empty1,empty2,full0,full1,full2;
input [1:0]din;
output vld0,vld1,vld2;
output reg sft0,sft1,sft2,fifo_full;
output reg[2:0]wr_enb;
reg [1:0]fifo_addr;
reg [4:0]count_sft0;
reg [4:0]count_sft1;
reg [4:0]count_sft2;
always@(posedge clk)
begin
	if(!rstn)
		fifo_addr<=0;
	else if(det_addr)
		fifo_addr<=din;
end
always @(*)
begin
	if(!we_reg)
		wr_enb=0;
	else 
	begin
		case(fifo_addr)
			2'b00:wr_enb=3'b001;
			2'b01:wr_enb=3'b010;
			2'b10:wr_enb=3'b100;
			default:wr_enb=3'b000;
		endcase
	end
end
always@(*)
begin
	case(fifo_addr)
		2'b00:fifo_full=full0;
		2'b01:fifo_full=full1;
		2'b10:fifo_full=full2;
		default:fifo_full=1'b0;
	endcase
end

assign vld0=!empty0;
assign vld1=!empty1;
assign vld2=!empty2;



always@(posedge clk)
begin
	if(!rstn)
	begin
		count_sft0<=5'b1;
		sft0<=0;
	end
	else if(!vld0)
	begin
		count_sft0<=5'b1;
		sft0<=0;
	end
	else if(re0)
	begin
		count_sft0<=5'b1;
		sft0<=0;
	end
	else if(count_sft0==30)
	begin
		count_sft0<=5'b1;
		sft0<=1;
	end
	else
	begin
		count_sft0<=count_sft0+1'b1;
		sft0<=0;
	end
end


always@(posedge clk)
begin
	if(!rstn)
	begin
		count_sft1<=5'b1;
		sft1<=0;
	end
	else if(!vld1)
	begin
		count_sft1<=5'b1;
		sft1<=0;
	end
	else if(re1)
	begin
		count_sft1<=5'b1;
		sft1<=0;
	end
	else if(count_sft1==30)
	begin
		count_sft1<=5'b1;
		sft1<=1;
	end
	else
	begin
		count_sft1<=count_sft1+1'b1;
		sft1<=0;
	end
end


always@(posedge clk)
begin
	if(!rstn)
	begin
		count_sft2<=5'b1;
		sft2<=0;
	end
	else if(!vld2)
	begin
		count_sft2<=5'b1;
		sft2<=0;
	end
	else if(re2)
	begin
		count_sft2<=5'b1;
		sft2<=0;
	end
	else if(count_sft2==30)
	begin
		count_sft2<=5'b1;
		sft2<=1;
	end
	else
	begin
		count_sft2<=count_sft2+1'b1;
		sft2<=0;
	end
end


endmodule




		



