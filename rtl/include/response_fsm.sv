`ifndef RESPONSE_FSM
`define RESPONSE_FSM

`define DEBUG

module slave_response_parser #(   
    parameter QTY_OF_DEVICES = 4
)(  
    clk,
    rst_n,
    granted_master,
    master_0_if, master_1_if, master_2_if, master_3_if,
    slave_0_if,
    session_is_finished
);

    input logic clk;
    input logic rst_n;
    input logic [QTY_OF_DEVICES-1:0] granted_master;
    cross_bar_if.master master_0_if, master_1_if, master_2_if, master_3_if;
    cross_bar_if.slave slave_if;
    output logic session_is_finished;

    typedef enum int {enWAITING_FOR_REQUEST_OR_RESPONSE, enWAITING_FOR_ACK, enREADING_DATA_FROM_SLAVE} fsm_state_t;
    fsm_state_t fsm_state;

    logic [1:0] master_requests_counter;

    always @(posedge clk, negedge rst_n)
    if(~rst_n)
    begin
        
    end
    else
    begin
        unique case(fsm_state)

            enWAITING_FOR_REQUEST_OR_RESPONSE:
            begin
                if(|granted_master) //slave is responding
                begin 
                    if(slave_if._resp)
                    begin
                        priority case(1'b1)

                            granted_master[0]: master_0_if._rdata <= slave_if._rdata;
                            granted_master[1]: master_1_if._rdata <= slave_if._rdata;
                            granted_master[2]: master_2_if._rdata <= slave_if._rdata;
                            granted_master[3]: master_3_if._rdata <= slave_if._rdata;

                        endcase
                    end    
                    else
                    begin //master sends requests to slave
                        priority case(1'b1)

                            granted_master[0]:
                            begin
                                slave_if._req   <=  master_0_if._req;
                                slave_if._addr  <=  master_0_if._addr;
                                slave_if._cmd   <=  master_0_if._cmd;
                                slave_if._wdata <=  master_0_if._wdata;
                            end

                            granted_master[1]:
                            begin
                                slave_if._req   <=  master_1_if._req;
                                slave_if._addr  <=  master_1_if._addr;
                                slave_if._cmd   <=  master_1_if._cmd;
                                slave_if._wdata <=  master_1_if._wdata;    
                            end

                            granted_master[2]:
                            begin
                                slave_if._req   <=  master_2_if._req;
                                slave_if._addr  <=  master_2_if._addr;
                                slave_if._cmd   <=  master_2_if._cmd;
                                slave_if._wdata <=  master_2_if._wdata;    
                            end

                            granted_master[3]:
                            begin
                                slave_if._req   <=  master_3_if._req;
                                slave_if._addr  <=  master_3_if._addr;
                                slave_if._cmd   <=  master_3_if._cmd;
                                slave_if._wdata <=  master_3_if._wdata;    
                            end

                        endcase

                        fsm_state <= enWAITING_FOR_ACK;
                    end    
                end
            end    

            enWAITING_FOR_ACK:
            begin
                if(|granted_master)
                    priority case(1'b1)

                        granted_master[0]: master_0_if._ack <= slave_if._ack;
                        granted_master[1]: master_1_if._ack <= slave_if._ack;
                        granted_master[2]: master_2_if._ack <= slave_if._ack;
                        granted_master[3]: master_3_if._ack <= slave_if._ack;

                    endcase
                if(slave_if._ack)
                begin
                    master_requests_counter <= master_requests_counter + 'b1; //slave accept master's request 
                    fsm_state <= enWAITING_FOR_REQUEST_OR_RESPONSE;
                end    
            end

            enREADING_DATA_FROM_SLAVE:
            begin
                
            end

        endcase
    end

    initial begin
        fsm_state = enWAITING_FOR_REQUEST;
        session_is_finished = 0;
        master_requests_counter = 0;
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
endmodule

`endif