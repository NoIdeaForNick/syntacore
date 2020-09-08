module tb_rr_arbiter;

logic		    rst_an;
logic		    clk;
logic	    	req0, req1, req2, req3;
logic	    	grant0, grant1, grant2, grant3;
logic           session_is_finished;

round_robin_arbiter DUT(.rst_an(rst_an),
                        .clk(clk),
                        .req({req3, req2, req1, req0}),
                        .grant({grant3, grant2, grant1, grant0}),
                        .session_is_finished(session_is_finished));

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    session_is_finished = 0;
    req0 = 0;
    req1 = 0;
    req2 = 0;
    req3 = 0;
    rst_an = 1;
    #10;
    rst_an = 0;
    #10;
    rst_an = 1;


    @(posedge clk);
    req0 <= 1;
    req1 <= 1;
    req2 <= 1;
    session_is_finished <= 1;
    repeat(5) @(posedge clk);
    session_is_finished <= 1;
    req0 <= 1;
    req1 <= 0;
    repeat(5) @(posedge clk);
    req2 <= 1;
    req3 <= 1;
    session_is_finished <= 1;
    @(posedge clk);
    session_is_finished <= 0;
    repeat(5) @(posedge clk);
    session_is_finished <= 1;
    repeat(5) @(posedge clk);
    session_is_finished <= 0;
    repeat(5) @(posedge clk);
    session_is_finished <= 1;
    repeat(5) @(posedge clk);
    session_is_finished <= 0;
    repeat(5) @(posedge clk);
    session_is_finished <= 1;
    repeat(5) @(posedge clk);
    session_is_finished <= 0;

    

end

logic	[1:0]	rotate_ptr;
logic	[3:0]	shift_req;
logic	[3:0]	shift_grant;
logic	[3:0]	grant;

assign  rotate_ptr = DUT.rotate_ptr,
        shift_req = DUT.shift_req,
        shift_grant = DUT.shift_grant,
        grant = DUT.grant;

endmodule