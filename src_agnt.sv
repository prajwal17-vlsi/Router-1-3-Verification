class src_agent extends uvm_agent;
`uvm_component_utils(src_agent);
src_driver drvh;
src_monitor monh;
src_sequencer seqrh;
src_agent_config m_cfg;

function new(string name="src_agt_top",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",m_cfg))
`uvm_fatal(get_type_name(),"getting is failed")
super.build_phase(phase);
monh=src_monitor::type_id::create("monh",this);
if(m_cfg.is_active==UVM_ACTIVE)
begin
drvh=src_driver::type_id::create("drvh",this);
seqrh=src_sequencer::type_id::create("seqrh",this);
end
endfunction 


virtual function void connect_phase(uvm_phase phase);
if(m_cfg.is_active==UVM_ACTIVE)
drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction

endclass

