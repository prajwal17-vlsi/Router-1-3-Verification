class dst_agent extends uvm_agent;
`uvm_component_utils(dst_agent);

dst_driver drvh;
dst_monitor monh;
dst_sequencer seqrh;
dst_agent_config m_cfg;

function new(string name="dst_agt_top",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db #(dst_agent_config)::get(this,"","dst_agent_config",m_cfg))
`uvm_fatal(get_type_name(),"getting_failed")
super.build_phase(phase);
monh=dst_monitor::type_id::create("monh",this);

if(m_cfg.is_active==UVM_ACTIVE)
begin
drvh=dst_driver::type_id::create("drvh",this);
seqrh=dst_sequencer::type_id::create("seqrh",this);
end
endfunction

virtual function void connect_phase(uvm_phase phase);
if(m_cfg.is_active==UVM_ACTIVE)
drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction
endclass

