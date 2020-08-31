`ifndef _INTERFACE
`define _INTERFACE

package interface_connection; 
    localparam ADDR_WIDTH = 32;
    localparam DATA_WIDTH = 32;
endpackage

interface cross_bar_if();
    import interface_connection::ADDR_WIDTH;
    import interface_connection::DATA_WIDTH;

    logic                   _req;
    logic [ADDR_WIDTH-1:0]  _addr;
    logic                   _cmd;
    logic [DATA_WIDTH-1:0]  _wdata;
    logic                   _ack;
    logic [DATA_WIDTH-1:0]  _rdata;
    logic                   _resp;

    modport master( input   _req, _addr, _cmd, _wdata, 
                    output  _ack, _rdata, _resp);

    modport slave(  output  _req, _addr, _cmd, _wdata,
                    input   _ack, _rdata, _resp);
endinterface

`endif