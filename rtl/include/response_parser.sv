`ifndef RESPONSE_PARSER
`define RESPONSE_PARSER

`define DEBUG


package mux_demux_connection;
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


module master_demux #(   
    parameter QTY_OF_DEVICES = 4
)(  
    granted_master,
    master_if,
    slave_to_master_0, slave_to_master_1, slave_to_master_2, slave_to_master_3
);


endmodule: master_demux


module slave_mux #(   
    parameter QTY_OF_DEVICES = 4
)(  
    clk,
    rst_n,
    granted_master,
    master_0_to_slave, master_1_to_slave, master_2_to_slave, master_3_to_slave,
    slave_to_master,
    slave_if,
    session_is_finished
);
    import mux_demux_connection::master_to_slave_data_t;
    import mux_demux_connection::slave_to_master_data_t;

    input logic clk;
    input logic rst_n;
    input logic [QTY_OF_DEVICES-1:0] granted_master;
    input master_to_slave_data_t master_0_to_slave, master_1_to_slave, master_2_to_slave, master_3_to_slave; //masters -> slave: req, addr, cmd, wdata 
    output slave_to_master_data_t slave_to_master;  //slave -> master's demux: ack, resp, rdata
    cross_bar_if.slave slave_if;
    output logic session_is_finished;

    //slave if mux
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
                if(slave_if._ack) fsm_state <= enREADING_DATA_FROM_SLAVE;                   
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