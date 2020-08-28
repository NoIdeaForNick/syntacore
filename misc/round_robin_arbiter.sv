//Rotate -> Priority -> Rotate
module round_robin_arbiter (
	rst_an,
	clk,
	req,
	grant,
	ack
);


    input	logic			rst_an;
    input	logic			clk;
    input 	logic	[3:0]	req;
    output	logic	[3:0]	grant;
    input 	logic	[3:0]	ack;

    logic	[1:0]	rotate_ptr;
    logic	[3:0]	shift_req;
    logic	[3:0]	shift_grant;

    initial 
    begin
        rotate_ptr = 0;
    end        
        

    // shift req to round robin the current priority
    always_comb
    begin
        unique case (rotate_ptr[1:0])
            2'b00: shift_req[3:0] = req[3:0];
            2'b01: shift_req[3:0] = {req[0],req[3:1]};
            2'b10: shift_req[3:0] = {req[1:0],req[3:2]};
            2'b11: shift_req[3:0] = {req[2:0],req[3]};
        endcase
    end

    // simple priority arbiter
    always_comb
    begin
        shift_grant[3:0] = 4'b0;
        if(shift_req)
            priority case(1'b1)
                shift_req[0]: shift_grant[0] = 1'b1;
                shift_req[1]: shift_grant[1] = 1'b1;
                shift_req[2]: shift_grant[2] = 1'b1;
                shift_req[3]: shift_grant[3] = 1'b1;
            endcase
    end

    // generate grant signal
    always_comb
    begin
        unique case (rotate_ptr[1:0])
            2'b00: grant[3:0] <= shift_grant[3:0];
            2'b01: grant[3:0] <= {shift_grant[2:0],shift_grant[3]};
            2'b10: grant[3:0] <= {shift_grant[1:0],shift_grant[3:2]};
            2'b11: grant[3:0] <= {shift_grant[0],shift_grant[3:1]};
        endcase
    end

    // update the rotate pointer
    // rotate pointer will set to the one after the current granted
    always @(posedge clk, negedge rst_an)
    begin
        if (!rst_an)
            rotate_ptr[1:0] <= 0;
        else 
            case (1'b1) // synthesis parallel_case
                grant[0] & ack[0]: rotate_ptr[1:0] <= 2'd1;
                grant[1] & ack[1]: rotate_ptr[1:0] <= 2'd2;
                grant[2] & ack[2]: rotate_ptr[1:0] <= 2'd3;
                grant[3] & ack[3]: rotate_ptr[1:0] <= 2'd0;
            endcase
    end
endmodule
