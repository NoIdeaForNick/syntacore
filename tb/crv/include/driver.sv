`ifndef DRIVER
`define DRIVER

class master_driver;
    int unsigned number_of_transaction;
    mailbox master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv;
    virtual cross_bar_if master_0_if, master_1_if, master_2_if, master_3_if;
    virtual clk_if clk;

    function new(   virtual cross_bar_if master_0_if, master_1_if, master_2_if, master_3_if, 
                    virtual clk_if clk,
                    mailbox master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv);
        this.master_0_if = master_0_if;
        this.master_1_if = master_1_if;
        this.master_2_if = master_2_if;
        this.master_3_if = master_3_if;
        this.clk = clk;
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
                    SetNewTransDataToIf(master_0_seq2driv, master_0_if);
                end
                
                begin
                    SetNewTransDataToIf(master_1_seq2driv, master_1_if);
                end

                begin
                    SetNewTransDataToIf(master_2_seq2driv, master_2_if);
                end

                begin
                    SetNewTransDataToIf(master_3_seq2driv, master_3_if);
                end
            join 
            ++number_of_transaction;
        end
    endtask

    task SetNewTransDataAndWaitForAck(mailbox mail, virtual cross_bar_if _if);
        transaction trans;
        mail.get(trans);
        @(posedge clk.clk);
        _if._req <= trans.req;
        _if._addr <= trans.addr;
        _if._cmd <= trans.cmd;
        _if.wdata <= trans.wdata;
        if(trans.req) 
        begin
            @(posedge _if._ack);
            @(posedge clk.clk);
            _if._req <= 0;
            _if._addr <= 0;
            _if._cmd <= 0;
            _if.wdata <= 0;
            if(!trans.cmd) //0 -> read request
            begin
                @(posedge _if._resp);
                @(posedge clk.clk);
            end
        end    
    endtask
endclass

`endif