class dst_monitor extends uvm_monitor;
	
   `uvm_component_utils(dst_monitor)

virtual router_if.DMON_MP vif;
dst_agent_config m_cfg;
dst_xtn data_h;

uvm_analysis_port #(dst_xtn) monitor_port;


function new(string name="dst_monitor",uvm_component parent);
super.new(name,parent);
monitor_port=new("monitor_port",this);

endfunction


virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db#(dst_agent_config)::get(this,"","dst_agent_config",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")

endfunction

virtual function void connect_phase(uvm_phase phase);
	vif=m_cfg.vif;
	super.connect_phase(phase);

endfunction

virtual task run_phase(uvm_phase phase);
	forever
	 collect();
endtask

task collect();
data_h=dst_xtn::type_id::create("data_h");


	while(vif.dmon_cb.rd_en!==1)
	@(vif.dmon_cb);
	@(vif.dmon_cb);
	data_h.header=vif.dmon_cb.dout;
	data_h.payload=new[data_h.header[7:2]];	
	@(vif.dmon_cb);
	
	foreach(data_h.payload[i])
	begin
		data_h.payload[i]=vif.dmon_cb.dout;
		@(vif.dmon_cb);
	end

	data_h.parity=vif.dmon_cb.dout;
repeat(2)
	@(vif.dmon_cb);

	
	monitor_port.write(data_h);
data_h.print;

endtask



endclass

