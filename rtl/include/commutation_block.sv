`ifndef COMMUTATION_BLOCK
`define COMMUTATION_BLOCK

`define DEBUG


package mux_connection;
    import interface_connection::ADDR_WIDTH;
    import interface_connection::DATA_WIDTH;

    typedef struct packed {
        logic req;
        logic [ADDR_WIDTH-1:0] addr;
        logic cmd;
        logic [DATA_WIDTH-1:0] wdata;
    } master_to_slave_data_t;

    typedef struct packed {
        logic ack;
        logic resp;
        logic [DATA_WIDTH-1:0] rdata;
    } slave_to_master_data_t;
endpackage


import mux_connection::master_to_slave_data_t;
import mux_connection::slave_to_master_data_t;


//all cross bar commutation is here
module commutation_block #(   
    parameter QTY_OF_DEVICES = 4
)(  
    input logic                         clk,
    input logic                         rst_n,
    input logic [QTY_OF_DEVICES-1:0]    granted_matrix [QTY_OF_DEVICES],
    cross_bar_if.master master_0_if, master_1_if, master_2_if, master_3_if,
    cross_bar_if.slave slave_0_if, slave_1_if, slave_2_if, slave_3_if,
    output logic                        session_is_finished [QTY_OF_DEVICES]
);

    master_to_slave_data_t master_0_to_slaves, master_1_to_slaves, master_2_to_slaves, master_3_to_slaves;
    slave_to_master_data_t slave_0_to_masters, slave_1_to_masters, slave_2_to_masters, slave_3_to_masters; 

    //no generate cause avoiding array of interfaces declared as ports
    //master 0
    master_mux #(
        .QTY_OF_DEVICES(QTY_OF_DEVICES)
    ) master_0_mux_inst (
        .granted_master(granted_matrix[0]),
        .master_if(master_0_if),
        .master_to_slaves(master_0_to_slaves),
        .slave_0_to_master(slave_0_to_masters),
        .slave_1_to_master(slave_1_to_masters),
        .slave_2_to_master(slave_2_to_masters),
        .slave_3_to_master(slave_3_to_masters)
    );
    //master 1
    master_mux #(
        .QTY_OF_DEVICES(QTY_OF_DEVICES)
    ) master_1_mux_inst (
        .granted_master(granted_matrix[1]),
        .master_if(master_1_if),
        .master_to_slaves(master_1_to_slaves),
        .slave_0_to_master(slave_0_to_masters),
        .slave_1_to_master(slave_1_to_masters),
        .slave_2_to_master(slave_2_to_masters),
        .slave_3_to_master(slave_3_to_masters)
    );
    //master 2
    master_mux #(
        .QTY_OF_DEVICES(QTY_OF_DEVICES)
    ) master_2_mux_inst (
        .granted_master(granted_matrix[2]),
        .master_if(master_2_if),
        .master_to_slaves(master_2_to_slaves),
        .slave_0_to_master(slave_0_to_masters),
        .slave_1_to_master(slave_1_to_masters),
        .slave_2_to_master(slave_2_to_masters),
        .slave_3_to_master(slave_3_to_masters)
    );
    //master 3
    master_mux #(
        .QTY_OF_DEVICES(QTY_OF_DEVICES)
    ) master_3_mux_inst (
        .granted_master(granted_matrix[3]),
        .master_if(master_3_if),
        .master_to_slaves(master_3_to_slaves),
        .slave_0_to_master(slave_0_to_masters),
        .slave_1_to_master(slave_1_to_masters),
        .slave_2_to_master(slave_2_to_masters),
        .slave_3_to_master(slave_3_to_masters)
    );

    //slave 0
    slave_mux #(
        .QTY_OF_DEVICES(QTY_OF_DEVICES)
    ) slave_0_mux_inst (
        .clk(clk),
        .rst_n(rst_n),
        .granted_master(granted_matrix[0]),
        .master_0_to_slave(master_0_to_slaves),
        .master_1_to_slave(master_1_to_slaves), 
        .master_2_to_slave(master_2_to_slaves), 
        .master_3_to_slave(master_3_to_slaves),
        .slave_to_masters(slave_0_to_masters),
        .slave_if(slave_0_if),
        .session_is_finished(session_is_finished[0])        
    );
    //slave 1
    slave_mux #(
        .QTY_OF_DEVICES(QTY_OF_DEVICES)
    ) slave_1_mux_inst (
        .clk(clk),
        .rst_n(rst_n),
        .granted_master(granted_matrix[1]),
        .master_0_to_slave(master_0_to_slaves),
        .master_1_to_slave(master_1_to_slaves), 
        .master_2_to_slave(master_2_to_slaves), 
        .master_3_to_slave(master_3_to_slaves),
        .slave_to_masters(slave_1_to_masters),
        .slave_if(slave_1_if),
        .session_is_finished(session_is_finished[1])        
    );
    //slave 2
    slave_mux #(
        .QTY_OF_DEVICES(QTY_OF_DEVICES)
    ) slave_2_mux_inst (
        .clk(clk),
        .rst_n(rst_n),
        .granted_master(granted_matrix[2]),
        .master_0_to_slave(master_0_to_slaves),
        .master_1_to_slave(master_1_to_slaves), 
        .master_2_to_slave(master_2_to_slaves), 
        .master_3_to_slave(master_3_to_slaves),
        .slave_to_masters(slave_2_to_masters),
        .slave_if(slave_2_if),
        .session_is_finished(session_is_finished[2])        
    );
    //slave 3
    slave_mux #(
        .QTY_OF_DEVICES(QTY_OF_DEVICES)
    ) slave_3_mux_inst (
        .clk(clk),
        .rst_n(rst_n),
        .granted_master(granted_matrix[3]),
        .master_0_to_slave(master_0_to_slaves),
        .master_1_to_slave(master_1_to_slaves), 
        .master_2_to_slave(master_2_to_slaves), 
        .master_3_to_slave(master_3_to_slaves),
        .slave_to_masters(slave_3_to_masters),
        .slave_if(slave_3_if),
        .session_is_finished(session_is_finished[3])        
    );


endmodule: commutation_block


module master_mux #(   
    parameter QTY_OF_DEVICES = 4
)(  
    input logic [QTY_OF_DEVICES-1:0] granted_master,
    cross_bar_if.master master_if,
    output master_to_slave_data_t master_to_slaves,
    input slave_to_master_data_t slave_0_to_master, slave_1_to_master, slave_2_to_master, slave_3_to_master
);

    assign  master_to_slaves.req = master_if._req,
            master_to_slaves.addr = master_if._addr,
            master_to_slaves.cmd = master_if._cmd,
            master_to_slaves.wdata = master_if._wdata;

    //master mux
    always_comb
    begin
        if(|granted_master)
        begin
            unique case(1'b1)
                granted_master[0]:
                begin
                   master_if._ack  = slave_0_to_master.ack;
                   master_if._resp  = slave_0_to_master.resp;
                   master_if._rdata  = slave_0_to_master.rdata;
                end

                granted_master[1]:
                begin
                    master_if._ack  = slave_1_to_master.ack;
                    master_if._resp  = slave_1_to_master.resp;
                    master_if._rdata  = slave_1_to_master.rdata;
                end

                granted_master[2]:
                begin
                    master_if._ack  = slave_2_to_master.ack;
                    master_if._resp  = slave_2_to_master.resp;
                    master_if._rdata  = slave_2_to_master.rdata;
                end

                granted_master[3]:
                begin
                    master_if._ack  = slave_3_to_master.ack;
                    master_if._resp  = slave_3_to_master.resp;
                    master_if._rdata  = slave_3_to_master.rdata;
                end
            endcase                       
        end
        else
        begin
            master_if._ack  = 0;
            master_if._resp  = 0;
            master_if._rdata  = 0;
        end   
    end   
endmodule: master_mux


module slave_mux #(   
    parameter QTY_OF_DEVICES = 4
)(  
    input logic clk,
    input logic rst_n,
    input logic [QTY_OF_DEVICES-1:0] granted_master,
    input master_to_slave_data_t master_0_to_slave, master_1_to_slave, master_2_to_slave, master_3_to_slave, //masters -> slave: req, addr, cmd, wdata 
    output slave_to_master_data_t slave_to_masters,  //slave -> master's demux: ack, resp, rdata
    cross_bar_if.slave slave_if,
    output logic session_is_finished
);

    assign  slave_to_masters.ack = slave_if._ack,
            slave_to_masters.resp = slave_if._resp,
            slave_to_masters.rdata = slave_if._rdata;

    //slave mux
    always_comb
    begin
        if(|granted_master)
        begin
            unique case(1'b1)
                granted_master[0]:
                begin
                    slave_if._req   =  master_0_to_slave.req;
                    slave_if._addr  =  master_0_to_slave.addr;
                    slave_if._cmd   =  master_0_to_slave.cmd;
                    slave_if._wdata =  master_0_to_slave.wdata;
                end

                granted_master[1]:
                begin
                    slave_if._req   =  master_1_to_slave.req;
                    slave_if._addr  =  master_1_to_slave.addr;
                    slave_if._cmd   =  master_1_to_slave.cmd;
                    slave_if._wdata =  master_1_to_slave.wdata;    
                end

                granted_master[2]:
                begin
                    slave_if._req   =  master_2_to_slave.req;
                    slave_if._addr  =  master_2_to_slave.addr;
                    slave_if._cmd   =  master_2_to_slave.cmd;
                    slave_if._wdata =  master_2_to_slave.wdata;    
                end

                granted_master[3]:
                begin
                    slave_if._req   =  master_3_to_slave.req;
                    slave_if._addr  =  master_3_to_slave.addr;
                    slave_if._cmd   =  master_3_to_slave.cmd;
                    slave_if._wdata =  master_3_to_slave.wdata;    
                end
            endcase                       
        end
        else
        begin
            slave_if._req   = 0;
            slave_if._addr  = 0;
            slave_if._cmd   = 0;
            slave_if._wdata = 0;    
        end   
    end        
        


    typedef enum logic [1:0] {enWAITING_FOR_REQUEST, enWAITING_FOR_ACK, enREADING_DATA_FROM_SLAVE} fsm_state_t;
    fsm_state_t fsm_state;

    always @(posedge clk, negedge rst_n)
    if(~rst_n)
    begin
        fsm_state <= enWAITING_FOR_REQUEST;
        session_is_finished <= 0;
    end
    else
    begin
        unique case(fsm_state)
            enWAITING_FOR_REQUEST:
            begin
                session_is_finished <= 0;
                if(|granted_master) fsm_state <= enWAITING_FOR_ACK;  //would be set till session_is_finished = 1. no further check is needed
            end    

            enWAITING_FOR_ACK:
            begin
                if(slave_if._ack) 
                    if(slave_if._cmd) // 1-write, 0-read
                    begin
                        session_is_finished <= 1;
                        fsm_state <= enWAITING_FOR_REQUEST; 
                    end
                    else fsm_state <= enREADING_DATA_FROM_SLAVE;                   
            end

            enREADING_DATA_FROM_SLAVE:
            begin
                if(slave_if._resp)
                begin
                    session_is_finished <= 1;
                    fsm_state <= enWAITING_FOR_REQUEST;              
                end    
            end
        endcase
    end

    initial begin
        fsm_state = enWAITING_FOR_REQUEST;
        session_is_finished = 0;
    end 

//***************************DEBUG STUFF*************************

`ifdef DEBUG                     
    
 /*synthesis translate_off*/
    fsm_state_t fsm_prev_state;

    always @(posedge clk) 
        fsm_prev_state <= fsm_state;

    always @*
        if(fsm_prev_state != fsm_state) ShowStateInfo();
    

    function void ShowStateInfo();
        $display("%m %t state:  %s -> %s", $time, fsm_prev_state, fsm_state);
    endfunction
/*synthesis translate_on*/

`endif

//**************************************************************
endmodule: slave_mux

`endif