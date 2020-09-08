`ifndef SCOREBOARD
`define SCOREBOARD

class scoreboard;
    int unsigned qty_of_transactions;
    mailbox master_0_mon2scb, master_1_mon2scb, master_2_mon2scb, master_3_mon2scb;
    mailbox slave_0_mon2scb, slave_1_mon2scb, slave_2_mon2scb, slave_3_mon2scb;
    bit is_transcripts_on;

    function new(   mailbox master_0_mon2scb, master_1_mon2scb, master_2_mon2scb, master_3_mon2scb,
                    mailbox slave_0_mon2scb, slave_1_mon2scb, slave_2_mon2scb, slave_3_mon2scb,
                    bit is_transcripts_on);
        this.master_0_mon2scb = master_0_mon2scb;
        this.master_1_mon2scb = master_1_mon2scb;
        this.master_2_mon2scb = master_2_mon2scb;
        this.master_3_mon2scb = master_3_mon2scb;
        this.slave_0_mon2scb = slave_0_mon2scb;
        this.slave_1_mon2scb = slave_1_mon2scb;
        this.slave_2_mon2scb = slave_2_mon2scb;
        this.slave_3_mon2scb = slave_3_mon2scb;
        this.is_transcripts_on = is_transcripts_on;
    endfunction

    task main;
            fork
                begin
                    forever 
                    begin
                        CompareRequests(0, master_0_mon2scb, slave_0_mon2scb, slave_1_mon2scb, slave_2_mon2scb, slave_3_mon2scb);
                    end
                end

                begin
                    forever 
                    begin
                        CompareRequests(1, master_1_mon2scb, slave_0_mon2scb, slave_1_mon2scb, slave_2_mon2scb, slave_3_mon2scb);                        
                    end
                end

                begin
                    forever
                    begin
                        CompareRequests(2, master_2_mon2scb, slave_0_mon2scb, slave_1_mon2scb, slave_2_mon2scb, slave_3_mon2scb);
                    end
                end

                begin
                    forever
                    begin
                        CompareRequests(3, master_3_mon2scb, slave_0_mon2scb, slave_1_mon2scb, slave_2_mon2scb, slave_3_mon2scb);
                    end   
                end
            join
    endtask

    task CompareRequests(bit [1:0] number_of_master, mailbox master_mail, slave_0_mail, slave_1_mail, slave_2_mail, slave_3_mail);
        transaction master_trans, slave_trans;
        bit [1:0] number_of_slave; 
        master_mail.get(master_trans);
        number_of_slave = master_trans.addr[31:30];
        unique case(number_of_slave)
            2'b00: slave_0_mail.get(slave_trans);
            2'b01: slave_1_mail.get(slave_trans);
            2'b10: slave_2_mail.get(slave_trans);
            2'b11: slave_3_mail.get(slave_trans);
        endcase
        //addr
        assert(master_trans.addr == slave_trans.addr) 
        else ShowErrRequest(number_of_master, number_of_slave, "address");

        //cmd
        assert(master_trans.cmd == slave_trans.cmd) 
        else ShowErrRequest(number_of_master, number_of_slave, "cmd");

        //wdata
        assert(master_trans.wdata == slave_trans.wdata) 
        else ShowErrRequest(number_of_master, number_of_slave, "wdata");

        ShowCorrectRequest(number_of_master, number_of_slave);
    endtask

    function void ShowCorrectRequest(bit [1:0] number_of_master, number_of_slave);
       if(is_transcripts_on) $display("Yay! Correct Request at %t master %d -> slave %d", $time, number_of_master, number_of_slave);
    endfunction

    task ShowErrRequest(bit [1:0] number_of_master, number_of_slave, string data_type);
        if(is_transcripts_on)
        begin
            $error("%m %t %s doesn't match: master %d -> slave %d", $time, data_type, number_of_master, number_of_slave);
            #100;
            $stop;       
        end
    endtask

endclass

`endif