`ifndef MONITOR
`define MONITOR

class monitor;
    virtual cross_bar_if master_0_if, master_1_if, master_2_if, master_3_if;
    virtual cross_bar_if slave_0_if, slave_1_if, slave_2_if, slave_3_if;

    mailbox master_0_mon2scb, master_1_mon2scb, master_2_mon2scb, master_3_mon2scb;
    mailbox slave_0_mon2scb, slave_1_mon2scb, slave_2_mon2scb, slave_3_mon2scb;

    function new(   virtual cross_bar_if master_0_if, master_1_if, master_2_if, master_3_if,
                    virtual cross_bar_if slave_0_if, slave_1_if, slave_2_if, slave_3_if,
                    mailbox master_0_mon2scb, master_1_mon2scb, master_2_mon2scb, master_3_mon2scb,
                    mailbox slave_0_mon2scb, slave_1_mon2scb, slave_2_mon2scb, slave_3_mon2scb);
        this.master_0_if = master_0_if;
        this.master_1_if = master_1_if;
        this.master_2_if = master_2_if;
        this.master_3_if = master_3_if;
        this.slave_0_if = slave_0_if;
        this.slave_1_if = slave_1_if;
        this.slave_2_if = slave_2_if;
        this.slave_3_if = slave_3_if;
        this.master_0_mon2scb = master_0_mon2scb;
        this.master_1_mon2scb = master_1_mon2scb;
        this.master_2_mon2scb = master_2_mon2scb;
        this.master_3_mon2scb = master_3_mon2scb;
        this.slave_0_mon2scb = slave_0_mon2scb;
        this.slave_1_mon2scb = slave_1_mon2scb;
        this.slave_2_mon2scb = slave_2_mon2scb;
        this.slave_3_mon2scb = slave_3_mon2scb;
    endfunction

    task main();
            transaction master_0_trans, master_1_trans, master_2_trans, master_3_trans; //mastert transaction -> 
            transaction slave_0_trans, slave_1_trans, slave_2_trans, slave_3_trans;     // -> slave transaction
            reply slave_0_resp, slave_1_resp, slave_2_resp, slave_3_resp;                   //slave response ->
            reply master_0_resp, master_1_resp, master_2_resp, master_3_resp;               // -> master response

            master_0_trans = new();
            master_1_trans = new();
            master_2_trans = new();
            master_3_trans = new();
            slave_0_trans = new();
            slave_1_trans = new();
            slave_2_trans = new();
            slave_3_trans = new();

            master_0_resp = new();
            master_1_resp = new();
            master_2_resp = new();
            master_3_resp = new();
            slave_0_resp = new();
            slave_1_resp = new();
            slave_2_resp = new();
            slave_3_resp = new();
            
            //parsing packets
            fork
                //send firstly
                RequestIfListener(master_0_if, master_0_mon2scb, master_0_trans);
                RequestIfListener(master_1_if, master_1_mon2scb, master_1_trans);
                RequestIfListener(master_2_if, master_2_mon2scb, master_2_trans);
                RequestIfListener(master_3_if, master_3_mon2scb, master_3_trans);

                RequestIfListener(slave_0_if, slave_0_mon2scb, slave_0_trans);
                RequestIfListener(slave_1_if, slave_1_mon2scb, slave_1_trans);
                RequestIfListener(slave_2_if, slave_2_mon2scb, slave_2_trans);
                RequestIfListener(slave_3_if, slave_3_mon2scb, slave_3_trans);

                //send secondly
 /*               ReplyIfListener(master_0_if, master_0_mon2scb, master_0_resp);
                ReplyIfListener(master_1_if, master_1_mon2scb, master_1_resp);
                ReplyIfListener(master_2_if, master_2_mon2scb, master_2_resp);
                ReplyIfListener(master_3_if, master_3_mon2scb, master_3_resp);

                ReplyIfListener(slave_0_if, slave_0_mon2scb, slave_0_resp);
                ReplyIfListener(slave_1_if, slave_1_mon2scb, slave_1_resp);
                ReplyIfListener(slave_2_if, slave_2_mon2scb, slave_2_resp);
                ReplyIfListener(slave_3_if, slave_3_mon2scb, slave_3_resp); */
            join
    endtask

    task RequestIfListener(virtual cross_bar_if _if, mailbox mail, transaction trans);
        forever 
        begin                
            @(posedge _if._req);              
            trans.addr = _if._addr;
            trans.wdata = _if._wdata;
            trans.cmd = _if._cmd;
            mail.put(trans);            
        end    
    endtask

    task ReplyIfListener(virtual cross_bar_if _if, mailbox mail, reply rep);
        forever 
        begin
            @(posedge _if._ack);
            rep.session_complete = 1;
            if(_if._cmd) mail.put(rep);
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