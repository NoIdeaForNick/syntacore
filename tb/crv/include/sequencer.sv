`ifndef SEQUENCER
`define SEQUENCER

class sequencer;
    transaction master_0_trans, master_1_trans, master_2_trans, master_3_trans;
    mailbox master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv;

    static string transaction_type = "full random";
    static int unsigned qty_of_iterations_to_be_sended = 1;
    static shortint unsigned delay_between_iterations = 0;
    event finished;

    function new(mailbox master_0_seq2driv, master_1_seq2driv, master_2_seq2driv, master_3_seq2driv, string transaction_type);
        this.master_0_seq2driv = master_0_seq2driv;
        this.master_1_seq2driv = master_1_seq2driv;
        this.master_2_seq2driv = master_2_seq2driv;
        this.master_3_seq2driv = master_3_seq2driv;
        this.transaction_type = transaction_type;
    endfunction

    static function void SetNumberOfIterations(int unsigned iterations);
        qty_of_iterations_to_be_sended = iterations;
    endfunction

    static function void SetDelayBetweenIterations(shortint unsigned delay);
        delay_between_iterations = delay;
    endfunction

    static function void SetIterationsType(string transaction_type);
        this.transaction_type = transaction_type;
    endfunction

    virtual function transaction GetItem();
        transaction base_trans;
        single_slave_transaction single_slave_trans;
        fixed_request_delay_transaction fixed_delay_trans;

        case(transaction_type)
            "full random":
            begin
                base_trans = new();
                assert(base_trans.randomize()) else ErrorHandler(transaction_type);
            end

            "single slave"
            begin
                single_slave_trans = new();
                assert(single_slave_trans.randomize()) else ErrorHandler(transaction_type);
                base_trans = single_slave_trans;
            end

            "fixed delay"
            begin
                fixed_delay_trans = new();
                assert(fixed_delay_trans.randomize()) else ErrorHandler(transaction_type);
                base_trans = fixed_delay_trans;                
            end

            default:
            begin
                base_trans = new();
                assert(base_trans.randomize()) else ErrorHandler(transaction_type);
            end
        endcase
        return(base_trans);
    endfunction

    function void ErrorHandler(string object_failed);
        $error("%m %t %s %s randomization failed!", $time, object_failed);
        $stop;
    endfunction

    task IsDelayExpired(shortint unsigned delay);
        while(delay)
        begin
           #1; 
           --delay;
        end
    endtask

    task main();
        shortint unsigned   master_0_req_delay, master_1_req_delay,
                            master_2_req_delay, master_3_req_delay;

        repeat(qty_of_iterations_to_be_sended)
        begin
            //creating objects
            master_0_trans = GetItem();
            master_1_trans = GetItem();
            master_2_trans = GetItem();
            master_3_trans = GetItem();

            //setting request delays
            master_0_req_delay = master_0_trans.request_delay;
            master_1_req_delay = master_1_trans.request_delay;
            master_2_req_delay = master_2_trans.request_delay
            master_3_req_delay = master_3_trans.request_delay

            //sending created objects
            fork
                begin
                    IsDelayExpired(master_0_req_delay);
                    master_0_seq2driv.put(master_0_trans);
                end

                begin
                    IsDelayExpired(master_1_req_delay);
                    master_1_seq2driv.put(master_1_trans);
                end

                begin
                    IsDelayExpired(master_2_req_delay);
                    master_2_seq2driv.put(master_2_trans);
                end

                begin
                    IsDelayExpired(master_3_req_delay);
                    master_3_seq2driv.put(master_3_trans);
                end
            join
            IsDelayExpired(delay_between_iterations);
        end
        -> finished;
    endtask
endclass
`endif