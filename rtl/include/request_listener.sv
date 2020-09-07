`ifndef REQ_LISTENER
`define REQ_LISTENER

module master_request_listener #(   
    parameter QTY_OF_DEVICES = 4
)(  
    address,
    request_from_master,
    request_to_arbiters
);
    input   logic   [$clog2(QTY_OF_DEVICES)-1:0]    address;
    input   logic                                   request_from_master;    //master has single request pin for all slaves
    output  logic   [QTY_OF_DEVICES-1:0]            request_to_arbiters;    //1 master might send 4 requests to 4 DIFFERENT arbiters. Each slave has own arbiter

    always_comb
    begin
        if(request_from_master)
            unique case(address)
                'b00: request_to_arbiters <= 'b0001;
                'b01: request_to_arbiters <= 'b0010;
                'b10: request_to_arbiters <= 'b0100;
                'b11: request_to_arbiters <= 'b1000;
            endcase
        else request_to_arbiters <= 0;    
    end

endmodule

`endif