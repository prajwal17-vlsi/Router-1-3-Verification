class router_env extends uvm_env;
`uvm_component_utils(router_env)
src_agt_top src_agth;
dst_agt_top dst_agth;
router_env_config m_cfg;
//src_agent_config src_cfg[];
//dst_agent_config dst_cfg[];
router_scoreboard sb;
router_virtual_sequencer v_sequencer;

function new(string name="router_env",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
`uvm_fatal(get_type_name(),"getting is failed")
//src_cfg=new[m_cfg.no_of_src_agents];
//dst_cfg=new[m.cfg.no_of_dst_agents];
if(m_cfg.has_sagent)
begin
src_agth=src_agt_top::type_id::create("src_agt",this);
//for(i=0;i<m_cfg.no_of_src_agent)
//uvm_config_db#(src_agent_config)::set(this,"src_agth*","src_agent_config",m_cfg.s_cfg[i]);
end


if(m_cfg.has_dagent)
begin
dst_agth=dst_agt_top::type_id::create("dst_agt",this);
//for(i=0;i<m_cfg.no_of_dst_agent)
//uvm_config_db#(dst_agent_config)::set(this,"dst_agth*","dst_agent_config",m_cfg.d_cfg[i]);
end


if(m_cfg.has_scoreboard)
sb=router_scoreboard::type_id::create("sb",this);

if(m_cfg.has_virtual_sequencer)
v_sequencer=router_virtual_sequencer::type_id::create("v_sequencer",this);
super.build_phase(phase);
endfunction



virtual function void connect_phase(uvm_phase phase);
if(m_cfg.has_virtual_sequencer)
begin
	for(int i=0;i<m_cfg.no_of_src_agents;i++)
	   v_sequencer.sseqrh[i]=src_agth.agnth[i].seqrh;

	for(int i=0;i<m_cfg.no_of_dst_agents;i++)
	   v_sequencer.dseqrh[i]=dst_agth.agnth[i].seqrh;
end

if(m_cfg.has_scoreboard)

	for(int i=0;i<m_cfg.no_of_src_agents;i++)
		src_agth.agnth[i].monh.monitor_port.connect(sb.src_fifo[i].analysis_export);
	for(int i=0;i<m_cfg.no_of_dst_agents;i++)
		dst_agth.agnth[i].monh.monitor_port.connect(sb.dst_fifo[i].analysis_export);

endfunction


endclass



