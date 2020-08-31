timeunit 1ns;
timeprecision 1ns;

module tb_generate;

    bit clk, rst_n;
    cross_bar_if master_0_if();
    cross_bar_if master_1_if();
    cross_bar_if master_2_if();
    cross_bar_if master_3_if();
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

        @(posedge clk);
        master_3_if._req <= 1;
        master_3_if._addr <= {2'b11, 30'b0};
        master_3_if._cmd <= 1;
        master_3_if._wdata <= 5;

        master_1_if._req <= 1;
        master_1_if._addr <= {2'b11, 30'b0};
        master_1_if._cmd <= 1;
        master_1_if._wdata <= 5;

    end


    logic [3:0] grant_from_arbiter_to_slave [3:0];
    logic [3:0] requests_to_all_arbiters_from_all_masters [3:0];
    assign grant_from_arbiter_to_slave = DUT.grant_from_arbiter_to_slave;
    assign requests_to_all_arbiters_from_all_masters = DUT.requests_to_all_arbiters_from_all_masters;

    logic [3:0] slave0, slave1, slave2, slave3;
    assign  slave0 = DUT.slave0,
            slave1 = DUT.slave1,
            slave2 = DUT.slave2,
            slave3 = DUT.slave3;


    task ResetMasterIf(virtual cross_bar_if.master _if);
        _if._req <= 0;
        _if._addr <= 0;
        _if._cmd <= 0;
        _if._wdata <= 0;
    endtask

    task ResetSlaveIf(virtual cross_bar_if.slave _if);
        _if._ack <= 0;
        _if._rdata <= 0;
    endtask
endmodule