`include "include/interface.sv"
`include "include/request_listener.sv"

module cross_bar(   clk, rst_n,
                    master_0_if, master_1_if, master_2_if, master_3_if, //4 masters
                    slave_0_if, slave_1_if, slave_2_if, slave_3_if      //4 slaves
);

    import interface_connection::cross_bar_if;
    import interface_connection::ADDR_WIDTH;
    
    input logic clk, rst_n;
    cross_bar_if.master master_0_if, master_1_if, master_2_if, master_3_if;
    cross_bar_if.slave  slave_0_if, slave_1_if, slave_2_if, slave_3_if;

    localparam QTY_OF_DEVICES = 4;
    localparam DEVICE_ADDR_SIZE = $clog2(QTY_OF_DEVICES);

    /*
        [ADDR 31:30] <- Master 3
        [ADDR 31:30] <- Master 2
        [ADDR 31:30] <- Master 1
        [ADDR 31:30] <- Master 0
    */
    wire [DEVICE_ADDR_SIZE-1:0] master_choose_slave [QTY_OF_DEVICES] = {
                                                                            {master_3_if._addr[ADDR_WIDTH-1], master_3_if._addr[ADDR_WIDTH-2]},
                                                                            {master_2_if._addr[ADDR_WIDTH-1], master_2_if._addr[ADDR_WIDTH-2]},
                                                                            {master_1_if._addr[ADDR_WIDTH-1], master_1_if._addr[ADDR_WIDTH-2]},
                                                                            {master_0_if._addr[ADDR_WIDTH-1], master_0_if._addr[ADDR_WIDTH-2]},
                                                                        }; //2 bits addr (4 slaves) x 4 masters
    
    /*
        [req] <- Master 3
        [req] <- Master 2
        [req] <- Master 1
        [req] <- Master 0
    */
    wire master_request [QTY_OF_DEVICES] =  {
                                              master_3_if._req,
                                              master_2_if._req,
                                              master_1_if._req,
                                              master_0_if._req,  
                                            }; //1 bit request from 4 masters
    
    /*
        [A3, A2, A1, A0] <- Master 3 requests
        [A3, A2, A1, A0] <- Master 2 requests
        [A3, A2, A1, A0] <- Master 1 requests
        [A3, A2, A1, A0] <- Master 0 requests
    */                                        
    wire [QTY_OF_DEVICES-1:0] requests_to_all_arbiters_from_all_masters [QTY_OF_DEVICES]; //4 arbiters from 4 masters. matrix


   
    typedef enum int {enWAITING_FOR_REQUEST, enWAITING_FOR_ACK, enREADING_DATA_FROM_SLAVE} slave_state_t;
    slave_state_t slave_1_state, slave_2_state;

    //slave 1 FSM
    always @(posedge clk, negedge rst_n)
    if(~rst_n)
    begin
        
    end
    else
    begin
        unique case(slave_1_state)

            enWAITING_FOR_REQUEST:
            begin
                if(|requests_to_slave_1)
                begin
                    priority case(1'b1)

                        requests_to_slave_1[0]:
                        begin
                             <= master_1_if._addr;
                        end

                        requests_to_slave_1[1]:
                        begin
                            
                        end

                    endcase
                end
            end

            enWAITING_FOR_ACK:
            begin
                
            end

            enREADING_DATA_FROM_SLAVE:
            begin
                
            end

        endcase
    end    

endmodule