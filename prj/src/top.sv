//this top module is used for quartus project build
//there are multiple virtual pins for triggering real signals
//no tricky logic just calculating Fmax

`include "../../rtl/include/interface.sv" 

module top(
    clk, rst_n,
    //req
    master_0_req_virtual,
    master_1_req_virtual,
    master_2_req_virtual,
    master_3_req_virtual,
    slave_0_req_virtual,
    slave_1_req_virtual,
    slave_2_req_virtual,
    slave_3_req_virtual,
    //addr
    master_0_addr_virtual,
    master_1_addr_virtual,
    master_2_addr_virtual,
    master_3_addr_virtual,
    slave_0_addr_virtual,
    slave_1_addr_virtual,
    slave_2_addr_virtual,
    slave_3_addr_virtual,
    //cmd
    master_0_cmd_virtual,
    master_1_cmd_virtual,
    master_2_cmd_virtual,
    master_3_cmd_virtual,
    slave_0_cmd_virtual,
    slave_1_cmd_virtual,
    slave_2_cmd_virtual,
    slave_3_cmd_virtual,
    //wdata
    master_0_wdata_virtual,
    master_1_wdata_virtual,
    master_2_wdata_virtual,
    master_3_wdata_virtual,
    slave_0_wdata_virtual,
    slave_1_wdata_virtual,
    slave_2_wdata_virtual,
    slave_3_wdata_virtual,
    //ack
    master_0_ack_virtual,
    master_1_ack_virtual,
    master_2_ack_virtual,
    master_3_ack_virtual,
    slave_0_ack_virtual,
    slave_1_ack_virtual,
    slave_2_ack_virtual,
    slave_3_ack_virtual,
    //rdata
    master_0_rdata_virtual,
    master_1_rdata_virtual,
    master_2_rdata_virtual,
    master_3_rdata_virtual,
    slave_0_rdata_virtual,
    slave_1_rdata_virtual,
    slave_2_rdata_virtual,
    slave_3_rdata_virtual
);

    import interface_connection::ADDR_WIDTH;
    import interface_connection::DATA_WIDTH;

    input   logic   clk, rst_n;

    //*****************VIRTUAL PINS*****************
    //req
    input   logic   master_0_req_virtual;
    input   logic   master_1_req_virtual;
    input   logic   master_2_req_virtual;
    input   logic   master_3_req_virtual;
    output  logic   slave_0_req_virtual;
    output  logic   slave_1_req_virtual;
    output  logic   slave_2_req_virtual;
    output  logic   slave_3_req_virtual;
    //addr
    input   logic [ADDR_WIDTH-1:0]  master_0_addr_virtual;
    input   logic [ADDR_WIDTH-1:0]  master_1_addr_virtual;
    input   logic [ADDR_WIDTH-1:0]  master_2_addr_virtual;
    input   logic [ADDR_WIDTH-1:0]  master_3_addr_virtual;
    output  logic [ADDR_WIDTH-1:0]  slave_0_addr_virtual;
    output  logic [ADDR_WIDTH-1:0]  slave_1_addr_virtual;
    output  logic [ADDR_WIDTH-1:0]  slave_2_addr_virtual;
    output  logic [ADDR_WIDTH-1:0]  slave_3_addr_virtual;
    //cmd
    input   logic   master_0_cmd_virtual;
    input   logic   master_1_cmd_virtual;
    input   logic   master_2_cmd_virtual;
    input   logic   master_3_cmd_virtual;
    output  logic   slave_0_cmd_virtual;
    output  logic   slave_1_cmd_virtual;
    output  logic   slave_2_cmd_virtual;
    output  logic   slave_3_cmd_virtual;
    //wdata
    input   logic [DATA_WIDTH-1:0]  master_0_wdata_virtual;
    input   logic [DATA_WIDTH-1:0]  master_1_wdata_virtual;
    input   logic [DATA_WIDTH-1:0]  master_2_wdata_virtual;
    input   logic [DATA_WIDTH-1:0]  master_3_wdata_virtual;
    output  logic [DATA_WIDTH-1:0]  slave_0_wdata_virtual;
    output  logic [DATA_WIDTH-1:0]  slave_1_wdata_virtual;
    output  logic [DATA_WIDTH-1:0]  slave_2_wdata_virtual;
    output  logic [DATA_WIDTH-1:0]  slave_3_wdata_virtual;
    //ack
    output  logic   master_0_ack_virtual;
    output  logic   master_1_ack_virtual;
    output  logic   master_2_ack_virtual;
    output  logic   master_3_ack_virtual;
    input   logic   slave_0_ack_virtual;
    input   logic   slave_1_ack_virtual;
    input   logic   slave_2_ack_virtual;
    input   logic   slave_3_ack_virtual;
    //rdata
    output  logic [DATA_WIDTH-1:0]  master_0_rdata_virtual;
    output  logic [DATA_WIDTH-1:0]  master_1_rdata_virtual;
    output  logic [DATA_WIDTH-1:0]  master_2_rdata_virtual;
    output  logic [DATA_WIDTH-1:0]  master_3_rdata_virtual;
    input   logic [DATA_WIDTH-1:0]  slave_0_rdata_virtual;
    input   logic [DATA_WIDTH-1:0]  slave_1_rdata_virtual;
    input   logic [DATA_WIDTH-1:0]  slave_2_rdata_virtual;
    input   logic [DATA_WIDTH-1:0]  slave_3_rdata_virtual;

    //****************WIRES TO MODULE**************
    logic   master_0_req;
    logic   master_1_req;
    logic   master_2_req;
    logic   master_3_req;
    logic   slave_0_req;
    logic   slave_1_req;
    logic   slave_2_req;
    logic   slave_3_req;
    
    logic [ADDR_WIDTH-1:0]  master_0_addr;
    logic [ADDR_WIDTH-1:0]  master_1_addr;
    logic [ADDR_WIDTH-1:0]  master_2_addr;
    logic [ADDR_WIDTH-1:0]  master_3_addr;
    logic [ADDR_WIDTH-1:0]  slave_0_addr;
    logic [ADDR_WIDTH-1:0]  slave_1_addr;
    logic [ADDR_WIDTH-1:0]  slave_2_addr;
    logic [ADDR_WIDTH-1:0]  slave_3_addr;
    
    logic   master_0_cmd;
    logic   master_1_cmd;
    logic   master_2_cmd;
    logic   master_3_cmd;
    logic   slave_0_cmd;
    logic   slave_1_cmd;
    logic   slave_2_cmd;
    logic   slave_3_cmd;
    
    logic [DATA_WIDTH-1:0]  master_0_wdata;
    logic [DATA_WIDTH-1:0]  master_1_wdata;
    logic [DATA_WIDTH-1:0]  master_2_wdata;
    logic [DATA_WIDTH-1:0]  master_3_wdata;
    logic [DATA_WIDTH-1:0]  slave_0_wdata;
    logic [DATA_WIDTH-1:0]  slave_1_wdata;
    logic [DATA_WIDTH-1:0]  slave_2_wdata;
    logic [DATA_WIDTH-1:0]  slave_3_wdata;
    
    logic   master_0_ack;
    logic   master_1_ack;
    logic   master_2_ack;
    logic   master_3_ack;
    logic   slave_0_ack;
    logic   slave_1_ack;
    logic   slave_2_ack;
    logic   slave_3_ack;
    
    logic [DATA_WIDTH-1:0]  master_0_rdata;
    logic [DATA_WIDTH-1:0]  master_1_rdata;
    logic [DATA_WIDTH-1:0]  master_2_rdata;
    logic [DATA_WIDTH-1:0]  master_3_rdata;
    logic [DATA_WIDTH-1:0]  slave_0_rdata;
    logic [DATA_WIDTH-1:0]  slave_1_rdata;
    logic [DATA_WIDTH-1:0]  slave_2_rdata;
    logic [DATA_WIDTH-1:0]  slave_3_rdata;


    cross_bar_wrapper cross_bar_wrapper_inst(.*);

    //catching all signals to/form virtual pins
    always @(posedge clk)
    begin
        master_0_req <= master_0_req_virtual;
        master_1_req <= master_1_req_virtual;
        master_2_req <= master_2_req_virtual;
        master_3_req <= master_3_req_virtual;
        slave_0_req_virtual <= slave_0_req;
        slave_1_req_virtual <= slave_1_req;
        slave_2_req_virtual <= slave_2_req;
        slave_3_req_virtual <= slave_3_req;  

        master_0_addr <= master_0_addr_virtual;
        master_1_addr <= master_1_addr_virtual;
        master_2_addr <= master_2_addr_virtual;
        master_3_addr <= master_3_addr_virtual;
        slave_0_addr_virtual <= slave_0_addr;
        slave_1_addr_virtual <= slave_1_addr;
        slave_2_addr_virtual <= slave_2_addr;
        slave_3_addr_virtual <= slave_3_addr;

        master_0_cmd <= master_0_cmd_virtual;
        master_1_cmd <= master_1_cmd_virtual;
        master_2_cmd <= master_2_cmd_virtual;
        master_3_cmd <= master_3_cmd_virtual;
        slave_0_cmd_virtual <= slave_0_cmd;
        slave_1_cmd_virtual <= slave_1_cmd;
        slave_2_cmd_virtual <= slave_2_cmd;
        slave_3_cmd_virtual <= slave_3_cmd;

        master_0_wdata <= master_0_wdata_virtual;
        master_1_wdata <= master_1_wdata_virtual;
        master_2_wdata <= master_2_wdata_virtual;
        master_3_wdata <= master_3_wdata_virtual;
        slave_0_wdata_virtual <= slave_0_wdata;
        slave_1_wdata_virtual <= slave_1_wdata;
        slave_2_wdata_virtual <= slave_2_wdata;
        slave_3_wdata_virtual <= slave_3_wdata;

        master_0_ack_virtual <= master_0_ack;
        master_1_ack_virtual <= master_1_ack;
        master_2_ack_virtual <= master_2_ack;
        master_3_ack_virtual <= master_3_ack;
        slave_0_ack <= slave_0_ack_virtual;
        slave_1_ack <= slave_1_ack_virtual;
        slave_2_ack <= slave_2_ack_virtual;
        slave_3_ack <= slave_3_ack_virtual;  

        master_0_rdata_virtual <= master_0_rdata;
        master_1_rdata_virtual <= master_1_rdata;
        master_2_rdata_virtual <= master_2_rdata;
        master_3_rdata_virtual <= master_3_rdata;  
        slave_0_rdata <= slave_0_rdata_virtual;
        slave_1_rdata <= slave_1_rdata_virtual;
        slave_2_rdata <= slave_2_rdata_virtual;
        slave_3_rdata <= slave_3_rdata_virtual;                                                                                     
    end
endmodule