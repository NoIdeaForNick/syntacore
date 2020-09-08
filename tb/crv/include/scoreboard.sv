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
                        CompareReplies(0, slave_0_mon2scb, master_0_mon2scb, master_1_mon2scb, master_2_mon2scb, master_3_mon2scb);
                    end
                end

                begin
                    forever 
                    begin
                        CompareRequests(1, master_1_mon2scb, slave_0_mon2scb, slave_1_mon2scb, slave_2_mon2scb, slave_3_mon2scb);
                        CompareReplies(1, slave_1_mon2scb, master_0_mon2scb, master_1_mon2scb, master_2_mon2scb, master_3_mon2scb);                        
                    end
                end

                begin
                    forever
                    begin
                        CompareRequests(2, master_2_mon2scb, slave_0_mon2scb, slave_1_mon2scb, slave_2_mon2scb, slave_3_mon2scb);
                        CompareReplies(2, slave_2_mon2scb, master_0_mon2scb, master_1_mon2scb, master_2_mon2scb, master_3_mon2scb);
                    end
                end

                begin
                    forever
                    begin
                        CompareRequests(3, master_3_mon2scb, slave_0_mon2scb, slave_1_mon2scb, slave_2_mon2scb, slave_3_mon2scb);
                        CompareReplies(3, slave_3_mon2scb, master_0_mon2scb, master_1_mon2scb, master_2_mon2scb, master_3_mon2scb);
                    end   
                end
            join
    endtask



    task CompareRequests(bit [1:0] number_of_master, mailbox master_mail, slave_0_mail, slave_1_mail, slave_2_mail, slave_3_mail);
        transaction master_trans, slave_trans;
        bit [1:0] number_of_slave;
        $display("%t reading request master", $time);
        master_mail.get(master_trans);
        number_of_slave = master_trans.appointed_slave;
        unique case(number_of_slave)
            2'b00: MonitorSlave(0, slave_0_mail, master_trans, slave_trans);
            2'b01: MonitorSlave(1, slave_1_mail, master_trans, slave_trans);
            2'b10: MonitorSlave(2, slave_2_mail, master_trans, slave_trans);
            2'b11: MonitorSlave(3, slave_3_mail, master_trans, slave_trans);
        endcase
        //addr
        assert(master_trans.addr == slave_trans.addr) 
        else ShowErr(number_of_master, number_of_slave, "address", "->");

        //cmd
        assert(master_trans.cmd == slave_trans.cmd) 
        else ShowErr(number_of_master, number_of_slave, "cmd", "->");

        //wdata
        assert(master_trans.wdata == slave_trans.wdata) 
        else ShowErr(number_of_master, number_of_slave, "wdata", "->");

        ShowCorrect(number_of_master, number_of_slave, "request", "->");
    endtask


    task CompareReplies(bit [1:0] number_of_slave, mailbox slave_mail, master_0_mail, master_1_mail, master_2_mail, master_3_mail);
        reply slave_reply, master_reply;
        bit[1:0] number_of_master;
        $display("%t reading reply master", $time);
        slave_mail.get(slave_reply);
        number_of_master = slave_reply.appointed_master;
        $display("%t reading reply slave", $time);
        unique case(number_of_master)
            2'b00: master_0_mail.get(master_reply);
            2'b01: master_1_mail.get(master_reply);
            2'b10: master_2_mail.get(master_reply);
            2'b11: master_3_mail.get(master_reply);
        endcase
        //rdata
        assert(slave_reply.rdata == master_reply.rdata) 
        else ShowErr(number_of_master, number_of_slave, "rdata", "<-");

        ShowCorrect(number_of_master, number_of_slave, "reply", "<-");
    endtask




    task MonitorSlave(bit [1:0] true_appointment, mailbox slave_mail, transaction master_trans, ref transaction slave_trans);
        do slave_mail.peek(slave_trans);
        while(master_trans.appointed_slave != true_appointment);
        slave_mail.get(slave_trans);
    endtask

    task ShowCorrect(bit [1:0] number_of_master, number_of_slave, string handle, direction);
       if(is_transcripts_on) $display("Yay! Correct %s at %t master %d %s slave %d", handle, $time, number_of_master, direction, number_of_slave);
    endtask

    task ShowErr(bit [1:0] number_of_master, number_of_slave, string data_type, direction);
        if(is_transcripts_on)
        begin
            $error("%m %t %s doesn't match: master %d %s slave %d", $time, data_type, number_of_master, direction, number_of_slave);
            #100;
            $stop;       
        end
    endtask

endclass

`endif