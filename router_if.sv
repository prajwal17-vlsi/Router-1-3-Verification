interface router_if(input bit clock);
logic pkt_valid,error,busy,restn,valid_out,rd_en;
logic [7:0]din,dout;

clocking sdr_cb@(posedge clock);
default input #1 output #1;
output din;
output pkt_valid;
output restn;
input busy;
endclocking

clocking smon_cb@(posedge clock);
default input #1 output #1;
input din,pkt_valid,restn,busy,error;
endclocking

clocking ddr_cb@(posedge clock);
default input #1 output #1;
output rd_en;
input valid_out;
endclocking

clocking dmon_cb@(posedge clock);
default input #1 output #1;
input rd_en;
input valid_out,dout;
endclocking
modport SDR_MP (clocking sdr_cb);
modport SMON_MP (clocking smon_cb);
modport DDR_MP (clocking ddr_cb);
modport DMON_MP (clocking dmon_cb);
endinterface

