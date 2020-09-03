timeunit 1ns;
timeprecision 1ns;

module tb_communication;

    logic                         clk;
    logic                         rst_n;
    logic [3:0]    granted_matrix [4];
    cross_bar_if master_0_if(), master_1_if(), master_2_if(), master_3_if();
    cross_bar_if slave_0_if(), slave_1_if(), slave_2_if(), slave_3_if();
    logic                        session_is_finished [4];

    commutation_block DUT(.*);

    initial begin
        rst_n = 1;
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        granted_matrix = '{0, 0, 0, 0};        
        ResetMasterIf(master_0_if);
        ResetMasterIf(master_1_if);
        ResetMasterIf(master_2_if);
        ResetMasterIf(master_3_if);
        ResetSlaveIf(slave_0_if);
        ResetSlaveIf(slave_1_if);
        ResetSlaveIf(slave_2_if);
        ResetSlaveIf(slave_3_if);

        @(posedge clk);
        granted_matrix[3] = 4'b1000;
        master_3_if._req <= 1;
        master_3_if._addr <= {2'b11, 30'b0};
        master_3_if._cmd <= 1;
        master_3_if._wdata <= 5;

        master_1_if._req <= 1;
        master_1_if._addr <= {2'b11, 30'b0};
        master_1_if._cmd <= 1;
        master_1_if._wdata <= 10;

        @(posedge clk);
        granted_matrix[1] = 4'b0010;

        @(posedge clk);
        slave_3_if._resp <= 1;

        @(posedge clk);
        master_3_if._req <= 0;
    end

    task ResetMasterIf(virtual cross_bar_if.master _if);
        _if._req <= 0;
        _if._addr <= 0;
        _if._cmd <= 0;
        _if._wdata <= 0;
    endtask

    task ResetSlaveIf(virtual cross_bar_if.slave _if);
        _if._ack <= 0;
        _if._rdata <= 0;
        _if._resp <= 0;
    endtask

endmodule