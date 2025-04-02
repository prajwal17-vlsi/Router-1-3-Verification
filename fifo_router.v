module routerfifo(clk,rstn,re,we,din,lfd_state,softrst,empty,dout,full);
input clk,rstn,re,we,softrst,lfd_state;
input [7:0]din;
output empty,full;
output reg [7:0]dout;
reg [8:0] mem [0:15];
reg [4:0]wr_ptr,rd_ptr;
reg lfd_state_s;
reg [6:0]count;
integer i;

always@(posedge clk)
begin
	if(!rstn)
		lfd_state_s<=1'b0;
	else
		lfd_state_s<=lfd_state;
end
always@(posedge clk)
begin
	if(!rstn)
		count<=7'b0;
	else if(softrst)
		count<=7'b0;
	else if(re && ~empty)
	begin 
	if(mem[rd_ptr[3:0]][8]==1'b1)
		count<=mem[rd_ptr[3:0]][7:2]+1'b1;
	else if(count!=0)
		count<=count-1'b1;
		end
end


always@(posedge clk)
begin
	if(!rstn)
		dout<=0;
	else if(softrst)
		dout<=8'hzz;
	//else if(count==0 && re)
	       // dout<=8'hzz;
	else if(re&&!empty)
		dout<=mem[rd_ptr[3:0]][7:0];
		else
		dout<=8'hz;
end
always@(posedge clk)
begin
	if(!rstn)
	begin
	for(i=0;i<16;i=i+1)
		mem[i]<=9'h0;
	end
	else if(softrst)
		mem[wr_ptr[3:0]][8:0]<=9'h0;
	else if(we &&!full )
	if(lfd_state_s)
	begin
		mem[wr_ptr[3:0]][8]<=1'b1;
		mem[wr_ptr[3:0]][7:0]<=din;
		end
		else
		begin
		mem[wr_ptr[3:0]][8]<=1'b0;
		mem[wr_ptr[3:0]][7:0]<=din;
		end
		end
		
		
always@(posedge clk)
begin
	if(!rstn)
		wr_ptr<=0;
	else if(softrst)
		wr_ptr<=0;
	else if(we && !full)
		wr_ptr<=wr_ptr+1'b1;
	
end

always@(posedge clk)
begin
	if(!rstn)
		rd_ptr<=0;
	else if(softrst)
		rd_ptr<=0;
	else if(re && !empty)
		rd_ptr<=rd_ptr+1'b1;
end

assign full=(wr_ptr=={~rd_ptr[4],rd_ptr[3:0]}&&rd_ptr==0)?1'b1:1'b0;
assign empty=(wr_ptr==rd_ptr)?1'b1:1'b0;
endmodule





