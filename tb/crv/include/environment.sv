`ifndef ENVIRONMEMT
`define ENVIRONMEMT

class environment;
    sequencer seq;
    master_driver master_driv;
    slave_driver slave_driv;

    mailbox master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv;
    virtual cross_bar_if master_0_if, master_1_if, master_2_if, master_3_if;
    virtual cross_bar_if slave_0_if, slave_1_if, slave_2_if, slave_3_if;
    string transaction_type;
    bit is_transcripts_on;

    function new(   virtual cross_bar_if master_0_if, master_1_if, master_2_if, master_3_if,
                    virtual cross_bar_if slave_0_if, slave_1_if, slave_2_if, slave_3_if,
                    string transaction_type = "full random", bit is_transcripts_on = 1);            
        this.master_0_if = master_0_if;
        this.master_1_if = master_1_if;
        this.master_2_if = master_2_if;
        this.master_3_if = master_3_if;
        this.slave_0_if = slave_0_if;
        this.slave_1_if = slave_1_if;
        this.slave_2_if = slave_2_if;
        this.slave_3_if = slave_3_if;
        this.transaction_type = transaction_type;  
        this.is_transcripts_on = is_transcripts_on;    
    endfunction

    function void CreateObjects();
        master_0_seq2driv = new();
        master_1_seq2driv = new();
        master_2_seq2driv = new();
        master_3_seq2driv = new();
        seq = new(master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv, transaction_type);
        master_driv = new(master_0_if, master_1_if, master_2_if, master_3_if, master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv);
        slave_driv = new(slave_0_if, slave_1_if, slave_2_if, slave_3_if);
    endfunction

    task PreTest();        
        master_driv.Reset();
        slave_driv.Reset();
    endtask

    task Test();
        disable master_driv.main;
        disable slave_driv.main;
        fork
            seq.main();
            master_driv.main();
            slave_driv.main();
        join_any
    endtask

    task PostTest();
        wait(seq.finished.triggered);
        wait(seq.qty_of_iterations_to_be_sended == master_driv.number_of_transaction);
//        wait(driv.number_of_transaction == scb.number_of_merged_packets);
    endtask

    task Run();
        CreateObjects();
        PreTest();
        Test();
        PostTest();
    endtask

endclass

`endif