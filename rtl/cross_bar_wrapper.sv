//wrapper for cross_bar module. Might be used for verilog parent modules.
//Should be compiled after cross_bar.sv

module cross_bar_wrapper(
    clk, rst_n,
    //req
    master_0_req,
    master_1_req,
    master_2_req,
    master_3_req,
    slave_0_req,
    slave_1_req,
    slave_2_req,
    slave_3_req,
    //addr
    master_0_addr,
    master_1_addr,
    master_2_addr,
    master_3_addr,
    slave_0_addr,
    slave_1_addr,
    slave_2_addr,
    slave_3_addr,
    //cmd
    master_0_cmd,
    master_1_cmd,
    master_2_cmd,
    master_3_cmd,
    slave_0_cmd,
    slave_1_cmd,
    slave_2_cmd,
    slave_3_cmd,
    //wdata
    master_0_wdata,
    master_1_wdata,
    master_2_wdata,
    master_3_wdata,
    slave_0_wdata,
    slave_1_wdata,
    slave_2_wdata,
    slave_3_wdata,
    //ack
    master_0_ack,
    master_1_ack,
    master_2_ack,
    master_3_ack,
    slave_0_ack,
    slave_1_ack,
    slave_2_ack,
    slave_3_ack,
    //rdata
    master_0_rdata,
    master_1_rdata,
    master_2_rdata,
    master_3_rdata,
    slave_0_rdata,
    slave_1_rdata,
    slave_2_rdata,
    slave_3_rdata,
    //resp
    master_0_resp,
    master_1_resp,
    master_2_resp,
    master_3_resp,
    slave_0_resp,
    slave_1_resp,
    slave_2_resp,
    slave_3_resp
);

    import interface_connection::ADDR_WIDTH;
    import interface_connection::DATA_WIDTH;

    input   logic   clk, rst_n;
    //req
    input   logic   master_0_req;
    input   logic   master_1_req;
    input   logic   master_2_req;
    input   logic   master_3_req;
    output  logic   slave_0_req;
    output  logic   slave_1_req;
    output  logic   slave_2_req;
    output  logic   slave_3_req;
    //addr
    input   logic [ADDR_WIDTH-1:0]  master_0_addr;
    input   logic [ADDR_WIDTH-1:0]  master_1_addr;
    input   logic [ADDR_WIDTH-1:0]  master_2_addr;
    input   logic [ADDR_WIDTH-1:0]  master_3_addr;
    output  logic [ADDR_WIDTH-1:0]  slave_0_addr;
    output  logic [ADDR_WIDTH-1:0]  slave_1_addr;
    output  logic [ADDR_WIDTH-1:0]  slave_2_addr;
    output  logic [ADDR_WIDTH-1:0]  slave_3_addr;
    //cmd
    input   logic   master_0_cmd;
    input   logic   master_1_cmd;
    input   logic   master_2_cmd;
    input   logic   master_3_cmd;
    output  logic   slave_0_cmd;
    output  logic   slave_1_cmd;
    output  logic   slave_2_cmd;
    output  logic   slave_3_cmd;
    //wdata
    input   logic [DATA_WIDTH-1:0]  master_0_wdata;
    input   logic [DATA_WIDTH-1:0]  master_1_wdata;
    input   logic [DATA_WIDTH-1:0]  master_2_wdata;
    input   logic [DATA_WIDTH-1:0]  master_3_wdata;
    output  logic [DATA_WIDTH-1:0]  slave_0_wdata;
    output  logic [DATA_WIDTH-1:0]  slave_1_wdata;
    output  logic [DATA_WIDTH-1:0]  slave_2_wdata;
    output  logic [DATA_WIDTH-1:0]  slave_3_wdata;
    //ack
    output  logic   master_0_ack;
    output  logic   master_1_ack;
    output  logic   master_2_ack;
    output  logic   master_3_ack;
    input   logic   slave_0_ack;
    input   logic   slave_1_ack;
    input   logic   slave_2_ack;
    input   logic   slave_3_ack;
    //rdata
    output  logic [DATA_WIDTH-1:0]  master_0_rdata;
    output  logic [DATA_WIDTH-1:0]  master_1_rdata;
    output  logic [DATA_WIDTH-1:0]  master_2_rdata;
    output  logic [DATA_WIDTH-1:0]  master_3_rdata;
    input   logic [DATA_WIDTH-1:0]  slave_0_rdata;
    input   logic [DATA_WIDTH-1:0]  slave_1_rdata;
    input   logic [DATA_WIDTH-1:0]  slave_2_rdata;
    input   logic [DATA_WIDTH-1:0]  slave_3_rdata;
    //resp
    output  logic   master_0_resp;
    output  logic   master_1_resp;
    output  logic   master_2_resp;
    output  logic   master_3_resp;
    input   logic   slave_0_resp;   
    input   logic   slave_1_resp;
    input   logic   slave_2_resp;
    input   logic   slave_3_resp;    


    cross_bar_if master_0_if(), master_1_if(), master_2_if(), master_3_if();
    cross_bar_if slave_0_if(), slave_1_if(), slave_2_if(), slave_3_if();

    assign  master_0_if._req = master_0_req,
            master_1_if._req = master_1_req,
            master_2_if._req = master_2_req,
            master_3_if._req = master_3_req,
            slave_0_req = slave_0_if._req,
            slave_1_req = slave_1_if._req,
            slave_2_req = slave_2_if._req,
            slave_3_req = slave_3_if._req;

    assign  master_0_if._addr = master_0_addr,
            master_1_if._addr = master_1_addr,
            master_2_if._addr = master_2_addr,
            master_3_if._addr = master_3_addr,
            slave_0_addr = slave_0_if._addr,
            slave_1_addr = slave_1_if._addr,
            slave_2_addr = slave_2_if._addr,
            slave_3_addr = slave_3_if._addr;

    assign  master_0_if._cmd = master_0_cmd,
            master_1_if._cmd = master_1_cmd,
            master_2_if._cmd = master_2_cmd,
            master_3_if._cmd = master_3_cmd,
            slave_0_cmd = slave_0_if._cmd,
            slave_1_cmd = slave_1_if._cmd,
            slave_2_cmd = slave_2_if._cmd,
            slave_3_cmd = slave_3_if._cmd;

    assign  master_0_if._wdata = master_0_wdata,
            master_1_if._wdata = master_1_wdata,
            master_2_if._wdata = master_2_wdata,
            master_3_if._wdata = master_3_wdata,
            slave_0_wdata = slave_0_if._wdata,
            slave_1_wdata = slave_1_if._wdata,
            slave_2_wdata = slave_2_if._wdata,
            slave_3_wdata = slave_3_if._wdata;       

    assign  master_0_ack = master_0_if._ack,
            master_1_ack = master_1_if._ack,
            master_2_ack = master_2_if._ack,
            master_3_ack = master_3_if._ack,
            slave_0_if._ack = slave_0_ack,
            slave_1_if._ack = slave_1_ack,
            slave_2_if._ack = slave_2_ack,
            slave_3_if._ack = slave_3_ack;

    assign  master_0_rdata = master_0_if._rdata,
            master_1_rdata = master_1_if._rdata,
            master_2_rdata = master_2_if._rdata,
            master_3_rdata = master_3_if._rdata,
            slave_0_if._rdata = slave_0_rdata,
            slave_1_if._rdata = slave_1_rdata,
            slave_2_if._rdata = slave_2_rdata,
            slave_3_if._rdata = slave_3_rdata;

    assign  master_0_resp = master_0_if._resp,
            master_1_resp = master_1_if._resp,
            master_2_resp = master_2_if._resp,
            master_3_resp = master_3_if._resp,                                            
            slave_0_if._resp = slave_0_resp,
            slave_1_if._resp = slave_1_resp,
            slave_2_if._resp = slave_2_resp,
            slave_3_if._resp = slave_3_resp;

    cross_bar cross_bar_inst(
        clk, rst_n, 
        master_0_if.master, master_1_if.master, master_2_if.master, master_3_if.master,
        slave_0_if.slave, slave_1_if.slave, slave_2_if.slave, slave_3_if.slave
    );
endmodule