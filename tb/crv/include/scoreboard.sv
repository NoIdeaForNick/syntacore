`ifndef SCOREBOARD
`define SCOREBOARD

class scoreboard;
    bit is_transcripts_on;

    mailbox master_0_request_mon2scb, master_1_request_mon2scb, master_2_request_mon2scb, master_3_request_mon2scb;
    mailbox slave_0_request_mon2scb, slave_1_request_mon2scb, slave_2_request_mon2scb, slave_3_request_mon2scb;
    mailbox master_0_reply_mon2scb, master_1_reply_mon2scb, master_2_reply_mon2scb, master_3_reply_mon2scb;
    mailbox slave_0_reply_mon2scb, slave_1_reply_mon2scb, slave_2_reply_mon2scb, slave_3_reply_mon2scb;

    function new(   mailbox master_0_request_mon2scb, master_1_request_mon2scb, master_2_request_mon2scb, master_3_request_mon2scb,
                    mailbox slave_0_request_mon2scb, slave_1_request_mon2scb, slave_2_request_mon2scb, slave_3_request_mon2scb,
                    mailbox master_0_reply_mon2scb, master_1_reply_mon2scb, master_2_reply_mon2scb, master_3_reply_mon2scb,
                    mailbox slave_0_reply_mon2scb, slave_1_reply_mon2scb, slave_2_reply_mon2scb, slave_3_reply_mon2scb,
                    bit is_transcripts_on);

        this.master_0_request_mon2scb = master_0_request_mon2scb;
        this.master_1_request_mon2scb = master_1_request_mon2scb;
        this.master_2_request_mon2scb = master_2_request_mon2scb;
        this.master_3_request_mon2scb = master_3_request_mon2scb;
        this.slave_0_request_mon2scb = slave_0_request_mon2scb;
        this.slave_1_request_mon2scb = slave_1_request_mon2scb;
        this.slave_2_request_mon2scb = slave_2_request_mon2scb;
        this.slave_3_request_mon2scb = slave_3_request_mon2scb;

        this.master_0_reply_mon2scb = master_0_reply_mon2scb;
        this.master_1_reply_mon2scb = master_1_reply_mon2scb;
        this.master_2_reply_mon2scb = master_2_reply_mon2scb;
        this.master_3_reply_mon2scb = master_3_reply_mon2scb;
        this.slave_0_reply_mon2scb = slave_0_reply_mon2scb;
        this.slave_1_reply_mon2scb = slave_1_reply_mon2scb;
        this.slave_2_reply_mon2scb = slave_2_reply_mon2scb;
        this.slave_3_reply_mon2scb = slave_3_reply_mon2scb;

        this.is_transcripts_on = is_transcripts_on;
    endfunction

    task main;
            fork
                begin
                    forever 
                    begin
                        CompareRequests(0, master_0_request_mon2scb, slave_0_request_mon2scb, slave_1_request_mon2scb, slave_2_request_mon2scb, slave_3_request_mon2scb);
                        CompareReplies(0, master_0_reply_mon2scb, slave_0_reply_mon2scb, slave_1_reply_mon2scb, slave_2_reply_mon2scb, slave_3_reply_mon2scb);
                    end
                end

                begin
                    forever 
                    begin
                        CompareRequests(1, master_1_request_mon2scb, slave_0_request_mon2scb, slave_1_request_mon2scb, slave_2_request_mon2scb, slave_3_request_mon2scb);
                        CompareReplies(1, master_1_reply_mon2scb, slave_0_reply_mon2scb, slave_1_reply_mon2scb, slave_2_reply_mon2scb, slave_3_reply_mon2scb);                        
                    end
                end

                begin
                    forever
                    begin
                        CompareRequests(2, master_2_request_mon2scb, slave_0_request_mon2scb, slave_1_request_mon2scb, slave_2_request_mon2scb, slave_3_request_mon2scb);
                        CompareReplies(2, master_2_reply_mon2scb, slave_0_reply_mon2scb, slave_1_reply_mon2scb, slave_2_reply_mon2scb, slave_3_reply_mon2scb);
                    end
                end

                begin
                    forever
                    begin
                        CompareRequests(3, master_3_request_mon2scb, slave_0_request_mon2scb, slave_1_request_mon2scb, slave_2_request_mon2scb, slave_3_request_mon2scb);
                        CompareReplies(3, master_3_reply_mon2scb, slave_0_reply_mon2scb, slave_1_reply_mon2scb, slave_2_reply_mon2scb, slave_3_reply_mon2scb);
                    end   
                end
            join
    endtask


    //Request
    task CompareRequests(bit [1:0] number_of_master, mailbox master_mail, slave_0_mail, slave_1_mail, slave_2_mail, slave_3_mail);
        transaction master_trans, slave_trans;
        master_mail.get(master_trans);
        unique case(master_trans.appointed_slave)
            2'b00: LookForDedicatedRequestOnSlave(slave_0_mail, master_trans, slave_trans);
            2'b01: LookForDedicatedRequestOnSlave(slave_1_mail, master_trans, slave_trans);
            2'b10: LookForDedicatedRequestOnSlave(slave_2_mail, master_trans, slave_trans);
            2'b11: LookForDedicatedRequestOnSlave(slave_3_mail, master_trans, slave_trans);
        endcase
        ShowCorrect(number_of_master, master_trans.appointed_slave, "request", "->");
    endtask

    task LookForDedicatedRequestOnSlave(mailbox slave_mail, transaction master_trans, ref transaction slave_trans);
        do
        begin 
            slave_mail.peek(slave_trans);
            #1;
        end    
        while( !((master_trans.addr == slave_trans.addr) &&
                (master_trans.cmd == slave_trans.cmd)   &&
                (master_trans.wdata == slave_trans.wdata))); //looking for right packet
        slave_mail.get(slave_trans);
    endtask


    //Reply
    task CompareReplies(bit [1:0] number_of_master, mailbox master_mail, slave_0_mail, slave_1_mail, slave_2_mail, slave_3_mail);
        reply slave_reply, master_reply;
        master_mail.get(master_reply); 
        unique case(master_reply.appointed_slave)
            2'b00: LookForDedicatedReplytOnSlave(slave_0_mail, master_reply, slave_reply);
            2'b01: LookForDedicatedReplytOnSlave(slave_1_mail, master_reply, slave_reply);
            2'b10: LookForDedicatedReplytOnSlave(slave_2_mail, master_reply, slave_reply);
            2'b11: LookForDedicatedReplytOnSlave(slave_3_mail, master_reply, slave_reply);
        endcase
        //rdata
        assert(slave_reply.rdata == master_reply.rdata) 
    
        ShowCorrect(number_of_master, master_reply.appointed_slave, "reply", "<-");
    endtask

    task LookForDedicatedReplytOnSlave(mailbox slave_mail, reply master_reply, ref reply slave_reply);
        do 
        begin
            slave_mail.peek(slave_reply);
            #1;
        end    
        while(!(slave_reply.rdata == master_reply.rdata));
        slave_mail.get(slave_reply);
    endtask






    task ShowCorrect(bit [1:0] number_of_master, number_of_slave, string handle, direction);
       if(is_transcripts_on) $display("Yay! Correct %s at \t\t\t\t %0t \t\t\t master %d %s slave %d", handle, $time, number_of_master, direction, number_of_slave);
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