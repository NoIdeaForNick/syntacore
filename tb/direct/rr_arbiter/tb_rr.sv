module my_tb;

logic		    rst_an;
logic		    clk;
logic	    	req0, req1, req2, req3;
logic	    	grant0, grant1, grant2, grant3;
logic           ack0, ack1, ack2, ack3;

round_robin_arbiter DUT(.rst_an(rst_an),
                        .clk(clk),
                        .req({req3, req2, req1, req0}),
                        .grant({grant3, grant2, grant1, grant0}),
                        .ack({ack3, ack2, ack1, ack0}));

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    ack0 = 0;
    ack1 = 0;
    ack2 = 0;
    ack3 = 0;
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
    repeat(5) @(posedge clk);
    req2 <= 1;
    req3 <= 1;
    ack0 <= 1;
    @(posedge clk);
    req0 <= 0;
    ack1 <= 1;
    repeat(5) @(posedge clk);
    ack2 <= 1;
    ack3 <= 1;

    

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