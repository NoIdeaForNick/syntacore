`ifndef DRIVER
`define DRIVER

class master_driver;
    int unsigned number_of_transaction;
    mailbox master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv;
    virtual cross_bar_if master_0_if, master_1_if, master_2_if, master_3_if;

    function new(   input bit clk,
                    virtual cross_bar_if master_0_if, master_1_if, master_2_if, master_3_if, 
                    mailbox master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv);
        this.master_0_if = master_0_if;
        this.master_1_if = master_1_if;
        this.master_2_if = master_2_if;
        this.master_3_if = master_3_if;
        this.master_0_seq2driv = master_0_seq2driv;
        this.master_1_seq2driv = master_1_seq2driv;
        this.master_2_seq2driv = master_2_seq2driv;
        this.master_3_seq2driv = master_3_seq2driv;
    endfunction

    task Reset();
        master_0_if._req    <= 0;
        master_0_if._addr   <= 0;
        master_0_if._cmd    <= 0;
        master_0_if._wdata  <= 0;

        master_1_if._req    <= 0;
        master_1_if._addr   <= 0;
        master_1_if._cmd    <= 0;
        master_1_if._wdata  <= 0;

        master_2_if._req    <= 0;
        master_2_if._addr   <= 0;
        master_2_if._cmd    <= 0;
        master_2_if._wdata  <= 0;

        master_3_if._req    <= 0;
        master_3_if._addr   <= 0;
        master_3_if._cmd    <= 0;
        master_3_if._wdata  <= 0;
    endtask

    task main;
        forever begin
            fork
                begin
                    SetNewTransDataAndWaitForAck(master_0_seq2driv, master_0_if);
                end
                
                begin
                    SetNewTransDataAndWaitForAck(master_1_seq2driv, master_1_if);
                end

                begin
                    SetNewTransDataAndWaitForAck(master_2_seq2driv, master_2_if);
                end

                begin
                    SetNewTransDataAndWaitForAck(master_3_seq2driv, master_3_if);
                end
            join 
            ++number_of_transaction;
        end
    endtask

    task SetNewTransDataAndWaitForAck(mailbox mail, virtual cross_bar_if _if);
        transaction trans;
        mail.get(trans);
        @(posedge clk);
        _if._req <= trans.req;
        _if._addr <= trans.addr;
        _if._cmd <= trans.cmd;
        _if._wdata <= trans.wdata;
        if(trans.req) 
        begin
            @(posedge _if._ack);
            @(posedge clk);
            _if._req <= 0;
            _if._addr <= 0;
            _if._cmd <= 0;
            _if._wdata <= 0;
            if(!trans.cmd) //0 -> read request
            begin
                @(posedge _if._resp);
                @(posedge clk);
            end
        end    
    endtask
endclass


class slave_driver;
    virtual cross_bar_if slave_0_if, slave_1_if, slave_2_if, slave_3_if;

    function new(input bit clk, virtual cross_bar_if slave_0_if, slave_1_if, slave_2_if, slave_3_if);
        this.slave_0_if = slave_0_if;
        this.slave_1_if = slave_1_if;
        this.slave_2_if = slave_2_if;
        this.slave_3_if = slave_3_if;   
    endfunction

    task Reset();
        slave_0_if._ack      <= 0;
        slave_0_if._resp     <= 0;
        slave_0_if._rdata    <= 0;

        slave_1_if._ack     <= 0;
        slave_1_if._resp    <= 0;
        slave_1_if._rdata   <= 0;

        slave_2_if._ack     <= 0;
        slave_2_if._resp    <= 0;
        slave_2_if._rdata   <= 0;

        slave_3_if._ack     <= 0;
        slave_3_if._resp    <= 0;
        slave_3_if._rdata   <= 0;
    endtask

    task main;
        forever begin
            fork
                begin
                    WaitingForReqAndReply(slave_0_if);
                end

                begin
                    WaitingForReqAndReply(slave_1_if);
                end

                begin
                    WaitingForReqAndReply(slave_2_if);  
                end

                begin
                    WaitingForReqAndReply(slave_3_if);    
                end
            join
        end
    endtask

    task WaitingForReqAndReply(virtual cross_bar_if _if);
        byte unsigned resp_delay_cycles = $urandom_range(0,10); 
        bit is_it_read_cmd;
        @(posedge _if._req);
        if(!_if._cmd) is_it_read_cmd = 1;
        @(posedge clk);
        _if._ack <= 1;
        @(posedge clk);
        _if._ack <= 0;
        if(is_it_read_cmd)
        begin
            repeat(resp_delay_cycles) @(posedge clk);
            _if._resp <= 1;
            @(posedge clk);
            _if._resp <= 0;
        end    
    endtask
endclass

`endif