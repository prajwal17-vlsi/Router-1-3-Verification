class rtest extends uvm_test;
`uvm_component_utils(rtest)
router_env_config m_cfg;
src_agent_config src_cfg[];
dst_agent_config dst_cfg[];
router_env env_h;
int no_of_src_agents=1;
int no_of_dst_agents=3;
bit has_sagent=1;
bit has_dagent=1;



function new(string name="rtest",uvm_component parent);
super.new(name,parent);
endfunction


virtual function void build_phase(uvm_phase phase);

m_cfg=router_env_config::type_id::create("m_cfg");
m_cfg.s_cfg=new[no_of_src_agents];
m_cfg.d_cfg=new[no_of_dst_agents];


if(has_sagent)
begin
src_cfg=new[no_of_src_agents];
foreach(src_cfg[i])
begin
src_cfg[i]=src_agent_config::type_id::create($sformatf("src_cfg[%0d]",i));
if(!uvm_config_db#(virtual router_if)::get(this,"","vif",src_cfg[i].vif))
`uvm_fatal(get_type_name(),"getting vif is failed")
src_cfg[i].is_active=UVM_ACTIVE;
m_cfg.s_cfg[i]=src_cfg[i];
end
end


if(has_dagent) begin
dst_cfg=new[no_of_dst_agents];
foreach(dst_cfg[i])
begin
dst_cfg[i]=dst_agent_config::type_id::create($sformatf("dst_cfg[%0d]",i));
if(!uvm_config_db#(virtual router_if)::get(this,"",$sformatf("vif%0d",i),dst_cfg[i].vif))
`uvm_fatal(get_type_name(),"getting vif is failed")
dst_cfg[i].is_active=UVM_ACTIVE;
end
//dst_cfg[2].is_active=UVM_ACTIVE;
m_cfg.d_cfg=dst_cfg;
end

m_cfg.has_sagent=has_sagent;
m_cfg.has_dagent=has_dagent;
m_cfg.no_of_src_agents=no_of_src_agents;
m_cfg.no_of_dst_agents=no_of_dst_agents;

uvm_config_db#(router_env_config)::set(this,"*","router_env_config",m_cfg);
super.build_phase(phase);

env_h=router_env::type_id::create("env_h",this);
endfunction


endclass

//////////////////////////small_packet//////////////////

class small_test extends rtest;

 `uvm_component_utils(small_test)

bit[1:0] addr=1;
nsmall_vseqs seq_h;
//sftsmall_vseqs seq_h;


function new(string name="small_test",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
endfunction

virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);
 
repeat(8)
begin
seq_h=nsmall_vseqs::type_id::create("seq_h");
//seq_h=sftsmall_vseqs::type_id::create("seq_h");
addr={$random}%3;
uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);



	seq_h.start(env_h.v_sequencer);
end
#100;
phase.drop_objection(this);

endtask

endclass



/////////////////////////////////medium_packet/////////////////////////////////////


class medium_test extends rtest;

 `uvm_component_utils(medium_test)

bit[1:0] addr;
//medium_seqs seq_h;
//normal_seqs n_seq;
//sftrst_seqs sft_seqh;

nmedium_vseqs seq_h;
//sftmedium_vseqs seq_h;


function new(string name="medium_test",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);

repeat(5)
begin
seq_h=nmedium_vseqs::type_id::create("seq_h");
//seq_h=sftmedium_vseqs::type_id::create("seq_h");
addr={$random}%3;
uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
	seq_h.start(env_h.v_sequencer);
end
#100;
phase.drop_objection(this);
endtask

endclass


//////////////////////////////////////////////////////large_packet//////////////////////////////////////////////////////////////

class large_test extends rtest;

 `uvm_component_utils(large_test)

nlarge_vseqs seq_h;
//sftlarge_vseqs seq_h;

bit[1:0] addr;


function new(string name="large_test",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);
repeat(5)
begin
addr={$random}%3;
seq_h=nlarge_vseqs::type_id::create("seq_h");

uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
//seq_h=sftlarge_vseqs::type_id::create("seq_h");

	seq_h.start(env_h.v_sequencer);

end
#100;

phase.drop_objection(this);

endtask

endclass


//////////////////////////////////////////////////////bad_packet//////////////////////////////////////////////////////////////

class bad_test extends rtest;

 `uvm_component_utils(bad_test)

nbad_vseqs seq_h;
//sftlarge_vseqs seq_h;

bit[1:0] addr;


function new(string name="bad_test",uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);
repeat(5)
begin
seq_h=nbad_vseqs::type_id::create("seq_h");
//seq_h=sftlarge_vseqs::type_id::create("seq_h");
addr={$random}%2;
uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
	seq_h.start(env_h.v_sequencer);

end
#100;

phase.drop_objection(this);

endtask

endclass



