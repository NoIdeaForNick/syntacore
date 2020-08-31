`include "include/interface.sv"
`include "include/request_listener.sv"
`include "include/round_robin_arbiter.sv"

module cross_bar(   
    input logic clk, rst_n,     
    cross_bar_if.master master_0_if, master_1_if, master_2_if, master_3_if, //4 masters
    cross_bar_if.slave slave_0_if, slave_1_if, slave_2_if, slave_3_if,      //4 slaves
    output logic [3:0] debug[4]
);

    import interface_connection::ADDR_WIDTH;

    localparam QTY_OF_DEVICES = 4;
    localparam DEVICE_ADDR_SIZE = $clog2(QTY_OF_DEVICES);

    /*
        [ADDR 31:30] <- Master 0
        [ADDR 31:30] <- Master 1
        [ADDR 31:30] <- Master 2
        [ADDR 31:30] <- Master 3
    */
    wire [DEVICE_ADDR_SIZE-1:0] master_chooses_slave [QTY_OF_DEVICES] = '{
        {master_0_if._addr[ADDR_WIDTH-1], master_0_if._addr[ADDR_WIDTH-2]},
        {master_1_if._addr[ADDR_WIDTH-1], master_1_if._addr[ADDR_WIDTH-2]},
        {master_2_if._addr[ADDR_WIDTH-1], master_2_if._addr[ADDR_WIDTH-2]},
        {master_3_if._addr[ADDR_WIDTH-1], master_3_if._addr[ADDR_WIDTH-2]}
    }; //2 bits addr (4 slaves) x 4 masters
    
    /*
        [req] <- Master 0
        [req] <- Master 1
        [req] <- Master 2
        [req] <- Master 3
    */
    wire master_request [QTY_OF_DEVICES] =  '{
        master_0_if._req,
        master_1_if._req,
        master_2_if._req,
        master_3_if._req  
    }; //1 bit request from 4 masters
    
    /*
        [A3, A2, A1, A0] <- Master 0 requests
        [A3, A2, A1, A0] <- Master 1 requests
        [A3, A2, A1, A0] <- Master 2 requests
        [A3, A2, A1, A0] <- Master 3 requests
    */                                        
    wire [QTY_OF_DEVICES-1:0] requests_to_all_arbiters_from_all_masters [QTY_OF_DEVICES]; //4 arbiters from 4 masters. matrix
    wire [QTY_OF_DEVICES-1:0] grant_from_arbiter_to_slave [QTY_OF_DEVICES]; //4 signals grant (from each master) to single slave x 4 slaves
    
    /*
        [ack] <- Slave 0
        [ack] <- Slave 1
        [ack] <- Slave 2
        [ack] <- Slave 3
    */
    wire slave_ack [QTY_OF_DEVICES] = '{
        slave_0_if._ack,
        slave_1_if._ack,
        slave_2_if._ack,
        slave_3_if._ack
    };

    generate
        genvar i;

        for(i=0; i<QTY_OF_DEVICES; ++i)
        begin: master
            master_request_listener  #(
                .QTY_OF_DEVICES(QTY_OF_DEVICES)
            ) master_request_listener_inst (
                .clk(clk),
                .rst_n(rst_n),
                .address(master_chooses_slave[i]), 
                .request_from_master(master_request[i]), 
                .request_to_arbiters(requests_to_all_arbiters_from_all_masters[i])
            );
        end

        for(i=0; i<QTY_OF_DEVICES; ++i)
        begin: arbiter
            round_robin_arbiter round_robin_arbiter_inst (
                .rst_an(rst_n),
                .clk(clk),
                .req({
                    requests_to_all_arbiters_from_all_masters[3][i],
                    requests_to_all_arbiters_from_all_masters[2][i],
                    requests_to_all_arbiters_from_all_masters[1][i],
                    requests_to_all_arbiters_from_all_masters[0][i],
                }),
                .grant(grant_from_arbiter_to_slave[i]),
                .ack(slave_ack[i])
            );
        end
    endgenerate   
   
    always @(posedge clk)
    begin
        debug[0] <= grant_from_arbiter_to_slave[0];
        debug[1] <= grant_from_arbiter_to_slave[1];
        debug[2] <= grant_from_arbiter_to_slave[2];
        debug[3] <= grant_from_arbiter_to_slave[3];
    end
/*
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
*/
endmodule