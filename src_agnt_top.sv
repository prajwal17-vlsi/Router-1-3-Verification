class src_agt_top extends uvm_env;
`uvm_component_utils(src_agt_top)
src_agent agnth[];
router_env_config m_cfg;
src_agent_config s_cfg;
function new(string name="src_agt_top",uvm_component parent);
super.new(name,parent);
endfunction
virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
`uvm_fatal(get_type_name(),"gatting failed")
super.build_phase(phase);
agnth=new[m_cfg.no_of_src_agents];
foreach(agnth[i]) begin
agnth[i]=src_agent::type_id::create($sformatf("agnth[%0d]",i),this);
uvm_config_db #(src_agent_config)::set(this,$sformatf("agnth[%0d]*",i),"src_agent_config",m_cfg.s_cfg[i]);
end
endfunction
task run_phase(uvm_phase phase);
uvm_top.print_topology;
endtask
endclass

