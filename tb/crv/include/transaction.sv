`ifndef TRANSACTION
`define TRANSACTION

class transaction;
    rand bit req;
    rand int unsigned addr;
    rand int unsigned wdata;
    rand bit cmd;

    rand shortint unsigned request_delay;

    constraint c_request_delay {request_delay inside {[0:1000]};}
endclass


class single_slave_transaction extends transaction;
    static bit [1:0] slave_addr;
    static int instance_qty;
    constraint c_addr {addr[31:30] == slave_addr;}

    function void post_randomize();
        ++instance_qty;
        if(instance_qty == 4)
        begin
            instance_qty = 0;
            ++slave_addr;
        end
    endfunction
endclass


class fixed_request_delay_transaction extends transaction;
    constraint c_request_delay {request_delay == 10;}
endclass


class reply;
    int unsigned rdata;
    bit session_complete;
endclass

`endif