`ifndef REQ_LISTENER
`define REQ_LISTENER

module master_request_listener #(   parameter QTY_OF_DEVICES = 4;
                                )(  address,
                                    request_from_master,
                                    request_to_arbiters
                                );
 
    input   [$clog2(QTY_OF_MASTERS)-1:0]    address;
    input                                   request_from_master;    //master has single request pin for all slaves
    output  [QTY_OF_DEVICES-1:0]            request_to_arbiters;    //1 master might send 4 requests to 4 DIFFERENT arbiters. Each slave has own arbiter

    always_comb
    begin
        request_to_arbiters = 0;
        if(request_from_master)
            unique case
                'b00: request_to_arbiters[0] = 1;
                'b01: request_to_arbiters[1] = 1;
                'b10: request_to_arbiters[2] = 1;
                'b11: request_to_arbiters[3] = 1;
            endcase
    end

endmodule

`endif