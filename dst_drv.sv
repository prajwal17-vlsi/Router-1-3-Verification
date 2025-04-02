class dst_driver extends uvm_driver #(dst_xtn);
  
`uvm_component_utils(dst_driver)

virtual router_if.DDR_MP vif;
dst_agent_config m_cfg;



function new(string name="dst_driver",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase); 
super.build_phase(phase);
	if(!uvm_config_db#(dst_agent_config)::get(this,"","dst_agent_config",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")
endfunction

virtual function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=m_cfg.vif;
endfunction


virtual task run_phase(uvm_phase phase);
forever
begin
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	seq_item_port.item_done;
end
endtask

task send_to_dut(dst_xtn xtn);
	while(vif.ddr_cb.valid_out!==1)
	@(vif.ddr_cb);
	
	repeat(xtn.delay)
	@(vif.ddr_cb);
	req.print;

	vif.ddr_cb.rd_en<=1'b1;
	
	@(vif.ddr_cb);

	while(vif.ddr_cb.valid_out!==0)	
	@(vif.ddr_cb);
	
	@(vif.ddr_cb);
	
	vif.ddr_cb.rd_en<=1'b0;
endtask


endclass

