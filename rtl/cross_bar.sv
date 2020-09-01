`include "include/interface.sv"
`include "include/request_listener.sv"
`include "include/round_robin_arbiter.sv"
`include "include/response_parser.sv"

module cross_bar(   
    input logic clk, rst_n,     
    cross_bar_if.master master_0_if, master_1_if, master_2_if, master_3_if, //4 masters
    cross_bar_if.slave slave_0_if, slave_1_if, slave_2_if, slave_3_if       //4 slaves
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
             arbiters
        [A3, A2, A1, A0] <- Master 0 requests
        [A3, A2, A1, A0] <- Master 1 requests
        [A3, A2, A1, A0] <- Master 2 requests
        [A3, A2, A1, A0] <- Master 3 requests

        for instance, requests_to_all_arbiters_from_all_masters[0] = 4'b0010 -----> means that master 0 asked request to slave 1
    */                                        
    wire [QTY_OF_DEVICES-1:0] requests_to_all_arbiters_from_all_masters [QTY_OF_DEVICES]; //4 arbiters from 4 masters. matrix

    /*
             masters
        [M3, M2, M1, M0] <- Slave 0 grant
        [M3, M2, M1, M0] <- Slave 1 grant
        [M3, M2, M1, M0] <- Slave 2 grant
        [M3, M2, M1, M0] <- Slave 3 grant
        
        for instance, grant_from_arbiter_to_slave[1] = 4'b0001 ----> means that slave 1 (addr = x01) grants access from master 0
    */
    wire [QTY_OF_DEVICES-1:0] grant_from_arbiter_to_slave [QTY_OF_DEVICES]; //4 signals grant (from each master) to single slave x 4 slaves
    
    wire session_with_slave_finished [QTY_OF_DEVICES];

    generate
        genvar i;

        //master's request listeners
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

        //arbiters for each slave
        for(i=0; i<QTY_OF_DEVICES; ++i)
        begin: arbiter
            round_robin_arbiter round_robin_arbiter_inst (
                .rst_an(rst_n),
                .clk(clk),
                .req({
                    requests_to_all_arbiters_from_all_masters[QTY_OF_DEVICES-1][i],
                    requests_to_all_arbiters_from_all_masters[QTY_OF_DEVICES-2][i],
                    requests_to_all_arbiters_from_all_masters[QTY_OF_DEVICES-3][i],
                    requests_to_all_arbiters_from_all_masters[QTY_OF_DEVICES-4][i]
                }),
                .grant(grant_from_arbiter_to_slave[i]),
                .session_is_finished(session_with_slave_finished[i])
            );
        end

        //grant signal parsers
    endgenerate   


    logic [3:0] slave0, slave1, slave2, slave3;
    always @(posedge clk)
    begin
        slave0 <= grant_from_arbiter_to_slave[0];
        slave1 <= grant_from_arbiter_to_slave[1];
        slave2 <= grant_from_arbiter_to_slave[2];
        slave3 <= grant_from_arbiter_to_slave[3];
    end


endmodule