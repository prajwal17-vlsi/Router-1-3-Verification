class router_scoreboard extends uvm_scoreboard;
`uvm_component_utils(router_scoreboard)
src_xtn src_h;
dst_xtn dst_h;
uvm_tlm_analysis_fifo #(src_xtn) src_fifo[];
uvm_tlm_analysis_fifo#(dst_xtn) dst_fifo[];
router_env_config m_cfg;
bit [1:0]addr;

covergroup router_src;
ADDR:coverpoint src_h.header[1:0]{
	bins first={2'b00};
	bins second={2'b01};
	bins third={2'b10};
		}
PAY_LENG:coverpoint src_h.header[7:2]{
	bins smal={[1:20]};
	bins med={[21:40]};
	bins larg={[41:63]};
  		}
ERROR:coverpoint src_h.error{
	bins error0={0};
	bins error1={1};
	  	}

SRC:cross ADDR,PAY_LENG,ERROR;

endgroup


covergroup router_dest;
ADDR:coverpoint dst_h.header[1:0]{
	bins first={2'b00};
	bins second={2'b01};
	bins third={2'b10};
		}
PAY_LENG:coverpoint dst_h.header[7:2]{
	bins smal={[1:20]};
	bins med={[21:40]};
	bins larg={[41:63]};
  		}

DST:cross ADDR,PAY_LENG;

endgroup


function new(string name="router_scoreboard",uvm_component parent);
super.new(name,parent); 
router_src=new();
router_dest=new();
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
`uvm_fatal(get_type_name(),"getting is failed")
src_fifo=new[m_cfg.no_of_src_agents];

foreach(src_fifo[i])
src_fifo[i]=new($sformatf("src_fifo[%0d]",i),this);



dst_fifo=new[m_cfg.no_of_dst_agents];

foreach(dst_fifo[i])
dst_fifo[i]=new($sformatf("dst_fifo[%0d]",i),this);

endfunction


virtual task run_phase(uvm_phase phase);
forever
begin
	fork
		begin
			src_fifo[0].get(src_h);
			src_h.print();
			router_src.sample();
		end

		begin
			if(!uvm_config_db#(bit[1:0])::get(this,"","bit[1:0]",addr))
    			    `uvm_fatal( get_type_name(),"getting is failed")

			dst_fifo[addr].get(dst_h);
			dst_h.print();
			router_dest.sample();
		end
	join

compare(src_h,dst_h);

end
endtask


task compare(src_xtn sxtn,dst_xtn dxtn);

if(sxtn.header==dxtn.header)
	$display("header matched");
else 
	$display("header_not_matched");


if(sxtn.payload==dxtn.payload)
	$display("payload matched");
else 
	$display("payload_not_matched");

if(sxtn.parity==dxtn.parity)
	$display("parity matched");
else 
	$display("parity_not_matched");


endtask


endclass

