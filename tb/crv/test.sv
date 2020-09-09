timeunit 1ns;
timeprecision 1ns;

package objects;
    bit clk;
    `include "include/transaction.sv"
    `include "include/sequencer.sv"
    `include "include/driver.sv"
    `include "include/monitor.sv"
    `include "include/scoreboard.sv"
    `include "include/environment.sv"
endpackage


program cross_bar_crv_test(    
    input bit clk, 
    cross_bar_if.master master_0_if, master_1_if, master_2_if, master_3_if,
    cross_bar_if.slave slave_0_if, slave_1_if, slave_2_if, slave_3_if,
    output bit reset
);

    covergroup cross_bar_coverage @(posedge clk);
        all_slaves_appointed_from_master_0: coverpoint master_0_if._addr[31:30] iff(master_0_if._req);
        all_slaves_appointed_from_master_1: coverpoint master_1_if._addr[31:30] iff(master_1_if._req);
        all_slaves_appointed_from_master_2: coverpoint master_2_if._addr[31:30] iff(master_2_if._req);
        all_slaves_appointed_from_master_3: coverpoint master_3_if._addr[31:30] iff(master_3_if._req);

        all_request_combinations: cross all_slaves_appointed_from_master_0, all_slaves_appointed_from_master_1, all_slaves_appointed_from_master_2, all_slaves_appointed_from_master_3;

        request_delay_from_master_0: coverpoint env.seq.master_0_trans.request_delay iff(master_0_if._req)
        {
            option.auto_bin_max = 5;
        }
        request_delay_from_master_1: coverpoint env.seq.master_1_trans.request_delay iff(master_1_if._req)
        {
            option.auto_bin_max = 5;
        }
        request_delay_from_master_2: coverpoint env.seq.master_2_trans.request_delay iff(master_2_if._req)
        {
            option.auto_bin_max = 5;
        }
        request_delay_from_master_3: coverpoint env.seq.master_3_trans.request_delay iff(master_3_if._req)
        {
            option.auto_bin_max = 5;
        } 
    endgroup 

    assign objects::clk = clk; //clk for drivers
    objects::environment env;
    cross_bar_coverage simple_cover;
    
    semaphore reset_sem;
    semaphore test_order_sem;

    string objects_for_testing[] = {"full random", "fixed delay", "single slave", "single slave obligate", "single slave obligate simultaneous"};
    bit is_coverage_enabled = 0;

    //reset
    initial begin
        simple_cover = new();
        test_order_sem = new();
        reset_sem = new();
        reset = 0;
        #4;
        reset = 1;
        reset_sem.put(2);
    end

    //coverage test
    initial begin
        reset_sem.get();
        test_order_sem.get();
        $display("Starting coverage test...It takes a lot of time!");
        $display("Coverage test is running. You are able to pause whenever you want");
        env = new(  master_0_if, master_1_if, master_2_if, master_3_if, 
                    slave_0_if, slave_1_if, slave_2_if, slave_3_if,  
                    "full random", 0);
        while(simple_cover.get_coverage < 100) env.Run();
        ShowCongratulation("Coverage Test");
        $stop;       
    end

    //main test
    initial begin
        reset_sem.get();
        $display("Starting simple test...");
        env.seq.SetNumberOfIterations(5); //it is static method       
        StartTestingThroughAllObjects();
        ShowCongratulation("Main Test");
        if(is_coverage_enabled) test_order_sem.put(); 
        else $stop;
    end

    task StartTestingThroughAllObjects();
        foreach(objects_for_testing[i])
        begin
            env = new(  master_0_if, master_1_if, master_2_if, master_3_if, 
                        slave_0_if, slave_1_if, slave_2_if, slave_3_if,  
                        objects_for_testing[i], 1);                
            env.Run(); 
        end
    endtask

    function void ShowCongratulation(string test_type);
        $display("**********************");
        $display("----------------------");
        $display("%s Passed!!! =)", test_type);
        $display("----------------------");
        $display("**********************");
    endfunction 
endprogram