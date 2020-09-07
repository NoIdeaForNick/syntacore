timeunit 1ns;
timeprecision 1ns;

`include "../../rtl/include/interface.sv"

module tb_top;
    bit clk, rst_n;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    cross_bar_if master_0_if(), master_1_if(), master_2_if(), master_3_if();
    cross_bar_if slave_0_if(), slave_1_if(), slave_2_if(), slave_3_if();

    cross_bar_crv_test special_cases_plus_coverage(
        clk,
        master_0_if, master_1_if, master_2_if, master_3_if,
        slave_0_if, slave_1_if, slave_2_if, slave_3_if,
        rst_n
    );

    cross_bar DUT(
        clk,
        rst_n,
        master_0_if, master_1_if, master_2_if, master_3_if,
        slave_0_if, slave_1_if, slave_2_if, slave_3_if
    );

    logic [3:0] grant_from_arbiter_to_commutation_block [4];
    assign grant_from_arbiter_to_commutation_block = DUT.grant_from_arbiter_to_commutation_block;
    logic session_with_slave_finished [4];
    assign session_with_slave_finished = DUT.session_with_slave_finished;

endmodule