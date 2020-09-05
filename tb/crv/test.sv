timeunit 1ns;
timeprecision 1ns;

package objects;
    bit clk;
    `include "include/transaction.sv"
    `include "include/sequencer.sv"
    `include "include/driver.sv"
//    `include "include/monitor.sv"
//    `include "include/scoreboard.sv"
    `include "include/environment.sv"
endpackage


program cross_bar_crv_test(    
    input bit clk, 
    cross_bar_if.master master_0_if, master_1_if, master_2_if, master_3_if,
    cross_bar_if.slave slave_0_if, slave_1_if, slave_2_if, slave_3_if,
    output bit reset
);
    assign objects::clk = clk; //clk for drivers
    objects::environment env;
    
    semaphore reset_sem;

    string objects_for_testing[] = {"full random", "single slave", "fixed delay"};

    //reset
    initial begin
        reset_sem = new();
        reset = 0;
        #4;
        reset = 1;
        reset_sem.put();
    end

    //main test
    initial begin
        reset_sem.get();
        env.seq.SetNumberOfIterations(2); //it is static method       
        StartTestingThroughAllObjects();
        ShowCongratulation();
        $stop;
    end

    task StartTestingThroughAllObjects();
        foreach(objects_for_testing[i])
        begin
            env = new(   clk, 
                            master_0_if, master_1_if, master_2_if, master_3_if, 
                            slave_0_if, slave_1_if, slave_2_if, slave_3_if,  
                            objects_for_testing[i], 1);                
            env.Run(); 
        end
    endtask

    function void ShowCongratulation();
        $display("******************");
        $display("------------------");
        $display("TESTBENCH Passed!!! =)");
        $display("------------------");
        $display("******************");
    endfunction 
endprogram