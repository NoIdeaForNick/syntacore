`ifndef ENVIRONMEMT
`define ENVIRONMEMT

class environment;
    sequencer seq;
    master_driver master_driv;
    slave_driver slave_driv;
    monitor mon;
    scoreboard scb;

    mailbox master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv;
    mailbox master_0_request_mon2scb, master_1_request_mon2scb, master_2_request_mon2scb, master_3_request_mon2scb;
    mailbox slave_0_request_mon2scb, slave_1_request_mon2scb, slave_2_request_mon2scb, slave_3_request_mon2scb;
    mailbox master_0_reply_mon2scb, master_1_reply_mon2scb, master_2_reply_mon2scb, master_3_reply_mon2scb;
    mailbox slave_0_reply_mon2scb, slave_1_reply_mon2scb, slave_2_reply_mon2scb, slave_3_reply_mon2scb;

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
        master_0_request_mon2scb = new();
        master_1_request_mon2scb = new();
        master_2_request_mon2scb = new();
        master_3_request_mon2scb = new();
        slave_0_request_mon2scb = new();
        slave_1_request_mon2scb = new();
        slave_2_request_mon2scb = new();
        slave_3_request_mon2scb = new();
        master_0_reply_mon2scb = new();
        master_1_reply_mon2scb = new();
        master_2_reply_mon2scb = new();
        master_3_reply_mon2scb = new();
        slave_0_reply_mon2scb = new();
        slave_1_reply_mon2scb = new();
        slave_2_reply_mon2scb = new();
        slave_3_reply_mon2scb = new();

        seq = new(master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv, transaction_type);
        master_driv = new(master_0_if, master_1_if, master_2_if, master_3_if, master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv);
        slave_driv = new(slave_0_if, slave_1_if, slave_2_if, slave_3_if);

        mon = new(  master_0_if, master_1_if, master_2_if, master_3_if,
                    slave_0_if, slave_1_if, slave_2_if, slave_3_if,
                    master_0_request_mon2scb, master_1_request_mon2scb, master_2_request_mon2scb, master_3_request_mon2scb,
                    slave_0_request_mon2scb, slave_1_request_mon2scb, slave_2_request_mon2scb, slave_3_request_mon2scb,
                    master_0_reply_mon2scb, master_1_reply_mon2scb, master_2_reply_mon2scb, master_3_reply_mon2scb,
                    slave_0_reply_mon2scb, slave_1_reply_mon2scb, slave_2_reply_mon2scb, slave_3_reply_mon2scb);

        scb = new(  master_0_request_mon2scb, master_1_request_mon2scb, master_2_request_mon2scb, master_3_request_mon2scb,
                    slave_0_request_mon2scb, slave_1_request_mon2scb, slave_2_request_mon2scb, slave_3_request_mon2scb,
                    master_0_reply_mon2scb, master_1_reply_mon2scb, master_2_reply_mon2scb, master_3_reply_mon2scb,
                    slave_0_reply_mon2scb, slave_1_reply_mon2scb, slave_2_reply_mon2scb, slave_3_reply_mon2scb,
                    is_transcripts_on);                    
    endfunction

    task PreTest();        
        master_driv.Reset();
        slave_driv.Reset();
    endtask

    task Test();
        disable master_driv.main;
        disable slave_driv.main;
        disable mon.main;
        disable scb.main;
        fork
            seq.main();
            master_driv.main();
            slave_driv.main();
            mon.main();
            scb.main();
        join_any
    endtask

    task PostTest();
        wait(seq.finished.triggered);
        wait(seq.qty_of_iterations_to_be_sended == master_driv.number_of_transaction);
    endtask

    task Run();
        CreateObjects();
        PreTest();
        Test();
        PostTest();
    endtask

endclass

`endif