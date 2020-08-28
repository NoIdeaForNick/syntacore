module my_tb;

logic		    rst_an;
logic		    clk;
logic	[3:0]	req;
logic	[3:0]	grant;

round_robin_arbiter DUT(.*);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    req = 0;
    rst_an = 1;
    #10;
    rst_an = 0;
    #10;
    rst_an = 1;
    @(posedge clk);
    req <= 4'b1111;
    repeat(5) @(posedge clk);

end
endmodule