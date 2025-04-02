class src_driver extends uvm_driver #(src_xtn);
`uvm_component_utils(src_driver)

virtual router_if.SDR_MP vif;
src_agent_config m_cfg;

function new(string name="src_driver",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase); 
super.build_phase(phase);
	if(!uvm_config_db#(src_agent_config)::get(this,"","src_agent_config",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")
endfunction

virtual function void connect_phase(uvm_phase phase);
   vif=m_cfg.vif;
   super.connect_phase(phase);
endfunction


virtual task run_phase(uvm_phase phase);



@(vif.sdr_cb)
		vif.sdr_cb.restn<=0;
	@(vif.sdr_cb)
		vif.sdr_cb.restn<=1;
   


forever	
	begin
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	seq_item_port.item_done;
	end
endtask


task send_to_dut(src_xtn xtn);
	while(vif.sdr_cb.busy!==0)
	@(vif.sdr_cb);

	vif.sdr_cb.pkt_valid<=1'b1;
	vif.sdr_cb.din<=xtn.header;
	@(vif.sdr_cb);

	foreach(xtn.payload[i])
	begin
	while(vif.sdr_cb.busy!==0)
	@(vif.sdr_cb);
	vif.sdr_cb.din<=xtn.payload[i];
	@(vif.sdr_cb);
	end
	vif.sdr_cb.pkt_valid<=1'b0;
	vif.sdr_cb.din<=xtn.parity;


//	repeat(2)
//	@(vif.sdr_cb);
//	xtn.error=vif.error;

	xtn.print;
endtask

endclass



