timeunit 1ns;
timeprecision 1ns;

module tb_top;

    bit clk, rst_n;
    cross_bar_if master_0_if(), master_1_if(), master_2_if(), master_3_if();
    cross_bar_if slave_0_if(), slave_1_if(), slave_2_if(), slave_3_if();

    cross_bar DUT(.*);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 1;
        ResetMasterIf(master_0_if);
        ResetMasterIf(master_1_if);
        ResetMasterIf(master_2_if);
        ResetMasterIf(master_3_if);
        ResetSlaveIf(slave_0_if);
        ResetSlaveIf(slave_1_if);
        ResetSlaveIf(slave_2_if);
        ResetSlaveIf(slave_3_if);

        slave_0_if._rdata <= 1;
        slave_1_if._rdata <= 2;
        slave_2_if._rdata <= 3;
        slave_3_if._rdata <= 4;

        repeat(10) @(posedge clk);
        master_2_if._req <= 1;
        master_2_if._addr <= {2'b11, 30'b0};
        master_2_if._cmd <= 0;
        master_2_if._wdata <= 5;

        repeat(5) @(posedge clk);
        slave_3_if._ack <= 1;
        @(posedge clk);
        slave_3_if._ack <= 0;

        master_0_if._req <= 1;
        master_0_if._addr <= {2'b11, 30'b0};
        master_0_if._cmd <= 1;
        master_0_if._wdata <= 50;

        repeat(5) @(posedge clk);
        slave_3_if._resp <= 1;
        slave_3_if._rdata <= 10;
        @(posedge clk);
        slave_3_if._resp <= 0;
        slave_3_if._rdata <= 10;

    end


    logic [3:0] grant_from_arbiter_to_commutation_block [3:0];
    logic [3:0] requests_to_all_arbiters_from_all_masters [3:0];
    assign grant_from_arbiter_to_commutation_block = DUT.grant_from_arbiter_to_commutation_block;
    assign requests_to_all_arbiters_from_all_masters = DUT.requests_to_all_arbiters_from_all_masters;


    task ResetMasterIf(virtual cross_bar_if.master _if);
        _if._req <= 0;
        _if._addr <= 0;
        _if._cmd <= 0;
        _if._wdata <= 0;
    endtask

    task ResetSlaveIf(virtual cross_bar_if.slave _if);
        _if._resp <= 0;
        _if._ack <= 0;
        _if._rdata <= 0;
    endtask
endmodule