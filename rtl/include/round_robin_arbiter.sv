`ifndef RR_ARBITER
`define RR_ARBITER

//Rotate -> Priority -> Rotate
module round_robin_arbiter (
	rst_an,
	clk,
	req,
	grant,
	session_is_finished
);


    input	logic			rst_an;
    input	logic			clk;
    input 	logic	[3:0]	req;
    output	logic	[3:0]	grant;
    input 	logic	    	session_is_finished;

    logic	[1:0]	rotate_ptr;
    logic	[3:0]	shift_req;
    logic	[3:0]	shift_grant;
    logic   [3:0]   req_buf;

    initial 
    begin
        rotate_ptr = 0;
        grant = 0;
        req_buf = 0;
    end        
        
    always @(posedge clk)
        if(session_is_finished) $display("%m %t session_is_finished req = %h", $time, req);

    always @(posedge clk, negedge rst_an)
        if(~rst_an) req_buf <= 0;
        else
            if(!grant || session_is_finished)  req_buf <= req; //sampling when no active grants OR last grant session is finished so get new one

    // shift req_buf to round robin the current priority
    always_comb
    begin
        unique case (rotate_ptr[1:0])
            2'b00: shift_req[3:0] = req_buf[3:0];
            2'b01: shift_req[3:0] = {req_buf[0],req_buf[3:1]};
            2'b10: shift_req[3:0] = {req_buf[1:0],req_buf[3:2]};
            2'b11: shift_req[3:0] = {req_buf[2:0],req_buf[3]};
        endcase
    end

    // simple priority arbiter
    always_comb
    begin                
        if(shift_req)
        begin
            shift_grant = 0;            
            priority case(1'b1)
                shift_req[0]: shift_grant[0] = 1'b1;
                shift_req[1]: shift_grant[1] = 1'b1;
                shift_req[2]: shift_grant[2] = 1'b1;
                shift_req[3]: shift_grant[3] = 1'b1;
            endcase
        end    
        else shift_grant = 0;    
    end

    // generate grant signal
    always @(posedge clk, negedge rst_an)
        if(~rst_an) grant <= 0;
        else
            unique case (rotate_ptr[1:0])
                2'b00: grant[3:0] <= shift_grant[3:0];
                2'b01: grant[3:0] <= {shift_grant[2:0],shift_grant[3]};
                2'b10: grant[3:0] <= {shift_grant[1:0],shift_grant[3:2]};
                2'b11: grant[3:0] <= {shift_grant[0],shift_grant[3:1]};
            endcase

    // update the rotate pointer
    // rotate pointer will set to the one after the current granted
    always @(posedge clk, negedge rst_an)    
        if (~rst_an) rotate_ptr <= 0;
        else
            if(session_is_finished && grant) 
               priority case (1'b1)
                    grant[0]: rotate_ptr[1:0] <= 2'd1;
                    grant[1]: rotate_ptr[1:0] <= 2'd2;
                    grant[2]: rotate_ptr[1:0] <= 2'd3;
                    grant[3]: rotate_ptr[1:0] <= 2'd0;
                endcase
endmodule

`endif