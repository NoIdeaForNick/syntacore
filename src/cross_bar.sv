package connection_to_cross_bar_module; 
    `include "interface.sv"
endpackage

module cross_bar(   clk, rst_n,
                    master_0_if, master_1_if, master_2_if, master_3_if,
                    slave_0_if, slave_1_if, slave_2_if, slave_3_if
);

    import connection_to_cross_bar_module::cross_bar_if;
    import connection_to_cross_bar_module::ADDR_WIDTH;
    
    input logic clk, rst_n;
    cross_bar_if.master master_0_if, master_1_if, master_2_if, master_3_if;
    cross_bar_if.slave slave_0_if, slave_1_if, slave_2_if, slave_3_if;

    wire [1:0] requests_to_slave_1 = { ~master_2_if._addr[ADDR_WIDTH-1] && master_2_if._req,
                                       ~master_1_if._addr[ADDR_WIDTH-1] && master_1_if._req};

    wire [1:0] requests_to_slave_2 = {  master_2_if._addr[ADDR_WIDTH-1] && master_2_if._req,
                                        master_1_if._addr[ADDR_WIDTH-1] && master_1_if._req};

   
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