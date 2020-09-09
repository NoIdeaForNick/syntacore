`ifndef MONITOR
`define MONITOR

class monitor;
    virtual cross_bar_if master_0_if, master_1_if, master_2_if, master_3_if;
    virtual cross_bar_if slave_0_if, slave_1_if, slave_2_if, slave_3_if;

    mailbox master_0_request_mon2scb, master_1_request_mon2scb, master_2_request_mon2scb, master_3_request_mon2scb;
    mailbox slave_0_request_mon2scb, slave_1_request_mon2scb, slave_2_request_mon2scb, slave_3_request_mon2scb;
    mailbox master_0_reply_mon2scb, master_1_reply_mon2scb, master_2_reply_mon2scb, master_3_reply_mon2scb;
    mailbox slave_0_reply_mon2scb, slave_1_reply_mon2scb, slave_2_reply_mon2scb, slave_3_reply_mon2scb;

    function new(   virtual cross_bar_if master_0_if, master_1_if, master_2_if, master_3_if,
                    virtual cross_bar_if slave_0_if, slave_1_if, slave_2_if, slave_3_if,
                    mailbox master_0_request_mon2scb, master_1_request_mon2scb, master_2_request_mon2scb, master_3_request_mon2scb,
                    mailbox slave_0_request_mon2scb, slave_1_request_mon2scb, slave_2_request_mon2scb, slave_3_request_mon2scb,
                    mailbox master_0_reply_mon2scb, master_1_reply_mon2scb, master_2_reply_mon2scb, master_3_reply_mon2scb,
                    mailbox slave_0_reply_mon2scb, slave_1_reply_mon2scb, slave_2_reply_mon2scb, slave_3_reply_mon2scb);

        this.master_0_if = master_0_if;
        this.master_1_if = master_1_if;
        this.master_2_if = master_2_if;
        this.master_3_if = master_3_if;
        this.slave_0_if = slave_0_if;
        this.slave_1_if = slave_1_if;
        this.slave_2_if = slave_2_if;
        this.slave_3_if = slave_3_if;

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
    endfunction

    task main();
            //parsing interfaces
            fork
                //send firstly
                RequestIfListener(master_0_if, master_0_request_mon2scb);
                RequestIfListener(master_1_if, master_1_request_mon2scb);
                RequestIfListener(master_2_if, master_2_request_mon2scb);
                RequestIfListener(master_3_if, master_3_request_mon2scb);

                RequestIfListener(slave_0_if, slave_0_request_mon2scb);
                RequestIfListener(slave_1_if, slave_1_request_mon2scb);
                RequestIfListener(slave_2_if, slave_2_request_mon2scb);
                RequestIfListener(slave_3_if, slave_3_request_mon2scb);

                //send secondly
                ReplyIfListener(master_0_if, master_0_reply_mon2scb);
                ReplyIfListener(master_1_if, master_1_reply_mon2scb);
                ReplyIfListener(master_2_if, master_2_reply_mon2scb);
                ReplyIfListener(master_3_if, master_3_reply_mon2scb);

                ReplyIfListener(slave_0_if, slave_0_reply_mon2scb);
                ReplyIfListener(slave_1_if, slave_1_reply_mon2scb);
                ReplyIfListener(slave_2_if, slave_2_reply_mon2scb);
                ReplyIfListener(slave_3_if, slave_3_reply_mon2scb);  
            join
    endtask

    task RequestIfListener(virtual cross_bar_if _if, mailbox mail);
        transaction trans;
        trans = new();
        forever 
        begin                
            @(posedge _if._req);              
            trans.addr = _if._addr;
            trans.wdata = _if._wdata;
            trans.cmd = _if._cmd;
            trans.appointed_slave = _if._addr[31:30];
            mail.put(trans);            
        end    
    endtask

    task ReplyIfListener(virtual cross_bar_if _if, mailbox mail);
        reply rep;
        rep = new();
        forever 
        begin
            @(posedge _if._ack);
            rep.appointed_slave = _if._addr[31:30];            
            if(_if._cmd)
            begin
                rep.rdata = _if._rdata; //actually rdata isnt used with write cmd. so check that it is zero at both ends
                mail.put(rep);
            end    
            else
            begin
                @(posedge _if._resp);
                rep.rdata = _if._rdata;
                mail.put(rep);                
            end
        end
    endtask
endclass

`endif