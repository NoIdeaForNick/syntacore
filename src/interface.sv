`ifndef _INTERFACE
`define _INTERFACE

interface cross_bar_if;
    localparam ADDR_WIDTH = 32;
    localparam DATA_WIDTH = 32;

    logic _req;
    logic [ADDR_WIDTH-1:0] _addr;
    logic _cmd;
    logic [DATA_WIDTH-1:0] _wdata;
    logic _ack;
    logic [DATA_WIDTH-1:0] _rdata;

    modport master( output _req, _addr, _cmd, _wdata, 
                    input _ack, _rdata);

    modport slave(  input _req, _addr, _cmd, _wdata,
                    output _ack, _rdata);
endinterface

`endif