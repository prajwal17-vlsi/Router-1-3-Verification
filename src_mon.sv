class src_monitor extends uvm_monitor;

  `uvm_component_utils(src_monitor)

virtual router_if.SMON_MP vif;
src_agent_config m_cfg;
src_xtn data_h;

uvm_analysis_port #(src_xtn) monitor_port;

function new(string name="src_monitor",uvm_component parent);
super.new(name,parent);
monitor_port=new("monitor_port",this);
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(src_agent_config)::get(this,"","src_agent_config",m_cfg))
   `uvm_fatal(get_type_name(),"getting is failed")
super.build_phase(phase);
endfunction

virtual function void connect_phase(uvm_phase phase);
vif=m_cfg.vif;
super.connect_phase(phase);
endfunction

virtual task run_phase(uvm_phase phase);
forever
	collect_data();
endtask

task collect_data();
data_h=src_xtn::type_id::create("data_h");

//@(vif.smon_cb);
//@(vif.smon_cb);

while(vif.smon_cb.pkt_valid!==1)
@(vif.smon_cb);


while(vif.smon_cb.busy!==0)
@(vif.smon_cb);
//data_h.print;


data_h.header=vif.smon_cb.din;
data_h.payload=new[data_h.header[7:2]];
@(vif.smon_cb);
//data_h.print;


//for(int i=1;i<=data_h.header[7:2];i++)
foreach(data_h.payload[i])
begin
	while(vif.smon_cb.busy!==0)
	@(vif.smon_cb);
	data_h.payload[i]=vif.smon_cb.din;
//	data_h.print;
	@(vif.smon_cb);
//	data_h.print;
	
end
//data_h.print;

while(vif.smon_cb.pkt_valid!==0)
@(vif.smon_cb);

//data_h.pkt_valid=vif.smon_cb.pkt_valid;
data_h.parity=vif.smon_cb.din;

repeat(2)
@(vif.smon_cb);
data_h.error=vif.smon_cb.error;


monitor_port.write(data_h);
data_h.print;


endtask

endclass

