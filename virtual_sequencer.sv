class router_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
`uvm_component_utils(router_virtual_sequencer)

src_sequencer sseqrh[];
dst_sequencer dseqrh[];
router_env_config m_cfg;

function new(string name="router_virtual_sequencer",uvm_component parent);
super.new(name,parent);
endfunction 

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
`uvm_fatal(get_type_name(),"getting is failed");

sseqrh=new[m_cfg.no_of_src_agents];
dseqrh=new[m_cfg.no_of_dst_agents];

endfunction

endclass

