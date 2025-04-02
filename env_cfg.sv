class router_env_config extends uvm_object;
`uvm_object_utils(router_env_config)
int no_of_src_agents=1;
int no_of_dst_agents=3;
bit has_sagent=1;
bit has_dagent=1;
bit has_virtual_sequencer=1;
bit has_scoreboard=1;
src_agent_config s_cfg[];
dst_agent_config d_cfg[];
function new(string name="router_env_config");
super.new(name);
endfunction
endclass

