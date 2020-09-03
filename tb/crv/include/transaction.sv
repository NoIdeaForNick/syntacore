`ifndef TRANSACTION
`define TRANSACTION

class transaction;
    rand bit req;
    rand int unsigned addr;
    rand int unsigned wdata;
    rand int unsigned rdata;
    rand bit cmd;

    rand shortint unsigned request_delay;
    rand byte unsigned ack_delay;
    rand byte unsigned resp_delay;

    constraint c_request_delay {request_delay inside [0:1000];}
    constraint c_ack_delay {ack_delay inside [0:10];}
    constraint c_resp_delay {resp_delay inside [0:10];}
endclass


class single_slave_transaction extends transaction;
    constraint c_addr {addr[31:30] == 2'b11;}
endclass


class fixed_request_delay_transaction extends transaction;
    constraint c_request_delay {request_delay == 10;}
endclass

`endif